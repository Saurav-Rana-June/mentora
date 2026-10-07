import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/doctor_appointment.model.dart';
import 'package:Mentora/infrastructure/theme/app_scale.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'complete_session.dialog.dart';

class StartSessionCallDialog extends StatefulWidget {
  final DoctorAppointmentModel appointment;

  const StartSessionCallDialog({super.key, required this.appointment});

  static Future<bool?> show({
    required BuildContext context,
    required DoctorAppointmentModel appointment,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StartSessionCallDialog(appointment: appointment),
    );
  }

  @override
  State<StartSessionCallDialog> createState() => _StartSessionCallDialogState();
}

class _StartSessionCallDialogState extends State<StartSessionCallDialog> {
  Timer? _timer;
  int _elapsedSeconds = 0;

  bool _isMicMuted = false;
  bool _isVideoOff = false;
  bool _isSpeakerOn = true;
  bool _isNotesExpanded = false;

  final TextEditingController _liveNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startCallTimer();
  }

  void _startCallTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _liveNotesController.dispose();
    super.dispose();
  }

  String _formatTimer(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _endCall() async {
    _timer?.cancel();
    final shouldComplete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('End Consultation Session?'),
        content: Text(
          'Are you ready to end the consultation with ${widget.appointment.patientName} and submit clinical summary notes?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(false);
              _startCallTimer();
            },
            child: const Text('Continue Session'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: dangerColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('End Session'),
          ),
        ],
      ),
    );

    if (shouldComplete == true && mounted) {
      Navigator.of(context).pop(true);
      CompleteSessionDialog.show(
        context: context,
        appointment: widget.appointment,
        initialNotes: _liveNotesController.text,
        elapsedDurationMinutes: (_elapsedSeconds / 60).ceil(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isVideo = widget.appointment.modalityType.toLowerCase().contains('video');

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF141414) : const Color(0xFF1E1E1E),
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppScale.isMobile ? 12 : 24,
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 900,
          maxHeight: 700,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              // Main Screen Area (Patient Video / Call Graphic)
              Column(
                children: [
                  buildTopCallHeader(context),
                  Expanded(
                    child: isVideo ? buildVideoConsultationView(context) : buildAudioConsultationView(context),
                  ),
                  buildBottomControlsBar(context),
                ],
              ),

              // Doctor Self Preview (Picture in Picture)
              if (isVideo && !_isVideoOff)
                Positioned(
                  top: 70,
                  right: 16,
                  child: Container(
                    width: AppScale.isMobile ? 90 : 140,
                    height: AppScale.isMobile ? 120 : 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B2C2A),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: primary, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=500',
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                'You (Doctor)',
                                style: r10.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Live Clinical Notes Drawer
              if (_isNotesExpanded)
                Positioned(
                  top: 60,
                  bottom: 90,
                  left: 16,
                  right: AppScale.isMobile ? 16 : 400,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (isDark ? const Color(0xFF222320) : white).withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'In-Call Clinical Notes',
                              style: h3.copyWith(fontWeight: FontWeight.w700),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, size: 20),
                              onPressed: () => setState(() => _isNotesExpanded = false),
                            ),
                          ],
                        ),
                        Spacing.s8.h,
                        Text(
                          'Notes taken here will be automatically forwarded to the clinical summary.',
                          style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                        ),
                        Spacing.s12.h,
                        Expanded(
                          child: TextField(
                            controller: _liveNotesController,
                            maxLines: null,
                            expands: true,
                            decoration: InputDecoration(
                              hintText: 'Type patient observations, symptoms, thoughts...',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                              contentPadding: const EdgeInsets.all(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTopCallHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: Colors.black.withValues(alpha: 0.4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: primary.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Spacing.s4.w,
                    Text(
                      'LIVE TELEHEALTH',
                      style: r10.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.s12.w,
              Text(
                widget.appointment.patientName,
                style: r14.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: Colors.white70, size: 16),
                    Spacing.s4.w,
                    Text(
                      _formatTimer(_elapsedSeconds),
                      style: r14.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.s8.w,
              IconButton(
                icon: Icon(
                  _isNotesExpanded ? Icons.note_alt_rounded : Icons.note_alt_outlined,
                  color: _isNotesExpanded ? primary : Colors.white70,
                ),
                tooltip: 'Clinical Notes',
                onPressed: () => setState(() => _isNotesExpanded = !_isNotesExpanded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildVideoConsultationView(BuildContext context) {
    return Container(
      color: const Color(0xFF0F100E),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: widget.appointment.patientImage,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.person, size: 80, color: Colors.white24),
            ),
          ),
          // Subtle overlay gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.5),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
          // Bottom Info Tag
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.appointment.patientName,
                  style: h2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacing.s4.h,
                Text(
                  '${widget.appointment.patientAge} yrs • ${widget.appointment.patientGender} • ${widget.appointment.patientIssue}',
                  style: r12.copyWith(
                    color: Colors.white70,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAudioConsultationView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primary, width: 3),
            ),
            child: CircleAvatar(
              radius: 60.r,
              backgroundImage: NetworkImage(widget.appointment.patientImage),
            ),
          ),
          Spacing.s16.h,
          Text(
            widget.appointment.patientName,
            style: h2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacing.s4.h,
          Text(
            'Secure High-Definition Audio Teleconsultation',
            style: r14.copyWith(color: Colors.white70),
          ),
          Spacing.s16.h,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.graphic_eq_rounded, color: primary, size: 20),
                Spacing.s8.w,
                Text(
                  'Audio Stream Encrypted',
                  style: r12.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomControlsBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      color: Colors.black.withValues(alpha: 0.6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildControlButton(
            icon: _isMicMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
            isActive: !_isMicMuted,
            label: _isMicMuted ? 'Unmute' : 'Mute',
            onTap: () => setState(() => _isMicMuted = !_isMicMuted),
          ),
          Spacing.s16.w,
          if (widget.appointment.modalityType.toLowerCase().contains('video')) ...[
            buildControlButton(
              icon: _isVideoOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
              isActive: !_isVideoOff,
              label: _isVideoOff ? 'Start Video' : 'Stop Video',
              onTap: () => setState(() => _isVideoOff = !_isVideoOff),
            ),
            Spacing.s16.w,
          ],
          buildControlButton(
            icon: _isSpeakerOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
            isActive: _isSpeakerOn,
            label: 'Speaker',
            onTap: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
          ),
          Spacing.s24.w,
          ElevatedButton.icon(
            onPressed: _endCall,
            icon: const Icon(Icons.call_end_rounded, color: Colors.white),
            label: Text(
              'End Consultation',
              style: r14.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: dangerColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildControlButton({
    required IconData icon,
    required bool isActive,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30.r),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.white.withValues(alpha: 0.15) : dangerColor.withValues(alpha: 0.8),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
        Spacing.s4.h,
        Text(
          label,
          style: r10.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}
