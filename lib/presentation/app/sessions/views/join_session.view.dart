import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/app/sessions/controllers/sessions.controller.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/fields/custom_textfield.widget.dart';
import 'package:Mentora/widgets/others/custom.divider.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:Mentora/widgets/others/custom.screen.wrapper.dart';

class JoinSessionView extends StatefulWidget {
  final SessionModel session;

  const JoinSessionView({super.key, required this.session});

  @override
  State<JoinSessionView> createState() => _JoinSessionViewState();
}

class _JoinSessionViewState extends State<JoinSessionView>
    with SingleTickerProviderStateMixin {
  // Call Controls State
  bool isMicMuted = false;
  bool isVideoOff = false;
  bool isFrontCamera = true;
  bool isSpeakerOn = true;
  bool isConnecting = true;

  // Live Timer
  int elapsedSeconds = 0;
  Timer? callTimer;
  late int totalSessionSeconds;

  // Voice wave animation
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // In-call Notes & Messages
  final TextEditingController _inCallNotesController = TextEditingController();
  final TextEditingController _chatMessageController = TextEditingController();
  final List<Map<String, dynamic>> _inCallMessages = [];

  // Drag position for PIP
  Offset pipPosition = const Offset(16, 80);

  @override
  void initState() {
    super.initState();
    isVideoOff = widget.session.callType.toLowerCase().contains("voice");
    totalSessionSeconds = widget.session.duration > 0
        ? widget.session.duration * 60
        : 30 * 60;

    _inCallNotesController.text = widget.session.notes ?? "";

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Initial simulated chat welcome
    _inCallMessages.add({
      "sender": widget.session.expertName,
      "text":
          "Hello! I am ready for our session. Feel free to speak or drop notes here.",
      "time": "Just now",
      "isMe": false,
    });

    // Simulated connection setup
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          isConnecting = false;
          _startTimer();
        });
      }
    });
  }

  void _startTimer() {
    callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          elapsedSeconds++;
        });
      }
    });
  }

  @override
  void dispose() {
    callTimer?.cancel();
    _pulseController.dispose();
    _inCallNotesController.dispose();
    _chatMessageController.dispose();
    super.dispose();
  }

  String _formatTimer(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }

  String _formatRemainingTime() {
    final remaining = (totalSessionSeconds - elapsedSeconds).clamp(
      0,
      totalSessionSeconds,
    );
    final mins = (remaining ~/ 60);
    return "$mins mins left";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isVideoCall = widget.session.callType.toLowerCase().contains("video");

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _showLeaveConfirmation(context);
      },
      child: CustomScreenWrapper(
        useSafeArea: false,
        backgroundColor: isDark
            ? const Color(0xFF121417)
            : const Color(0xFF1E242B),
        body: Stack(
          children: [
            // Main Consultation Stage
            Positioned.fill(
              child: isVideoCall && !isVideoOff
                  ? buildVideoConsultationView(context)
                  : buildVoiceConsultationView(context),
            ),

            // Top Floating Header & Info
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(bottom: false, child: buildTopOverlay(context)),
            ),

            // Video PIP (Only for Video Calls)
            if (isVideoCall)
              Positioned(
                right: pipPosition.dx,
                top: pipPosition.dy + 80,
                child: buildPatientPip(context),
              ),

            // Bottom In-Call Controls Dock
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: buildBottomControlsDock(context),
            ),

            // Connecting Spinner Overlay
            if (isConnecting)
              Positioned.fill(
                child: Container(
                  color: Colors.black87,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(primary),
                        ),
                        Spacing.s16.h,
                        Text(
                          "Connecting securely with ${widget.session.expertName}...",
                          textAlign: TextAlign.center,
                          style: r14.copyWith(
                            color: white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacing.s8.h,
                        Text(
                          "🔒 End-to-End 256-bit Encrypted",
                          style: r12.copyWith(
                            color: slate[400],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top Floating Header
  // ---------------------------------------------------------------------------
  Widget buildTopOverlay(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withValues(alpha: 0.75), Colors.transparent],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back / Minimize Button
          Material(
            color: Colors.white.withValues(alpha: 0.15),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => _showLeaveConfirmation(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Doctor Info & Timer Pill
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Live green dot
                Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: BoxDecoration(
                    color: isConnecting ? warningColor : successColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Spacing.s8.w,
                Text(
                  _formatTimer(elapsedSeconds),
                  style: r14.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                Spacing.s8.w,
                Container(width: 1, height: 12.h, color: Colors.white24),
                Spacing.s8.w,
                Text(
                  _formatRemainingTime(),
                  style: r12.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Session Info / Notes Trigger
          Material(
            color: Colors.white.withValues(alpha: 0.15),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => _showSessionDetailsModal(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Video Consultation View (Doctor Simulated Stream)
  // ---------------------------------------------------------------------------
  Widget buildVideoConsultationView(BuildContext context) {
    return Container(
      color: const Color(0xFF181C22),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Doctor Video Stream / Simulated Camera View
          Image.network(
            widget.session.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFF242C35),
                child: Center(
                  child: Icon(Icons.person, size: 100.r, color: Colors.white38),
                ),
              );
            },
          ),

          // Subtle Gradient Vignette
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.65),
                ],
              ),
            ),
          ),

          // Doctor Live Status Tag
          Positioned(
            left: 20.w,
            bottom: 120.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.mic_rounded, size: 16, color: successColor),
                  Spacing.s8.w,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.session.expertName,
                        style: r14.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.session.specialty,
                        style: r10.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Voice Consultation View (Audio Waveform & Doctor Avatar)
  // ---------------------------------------------------------------------------
  Widget buildVoiceConsultationView(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.2),
          radius: 1.2,
          colors: [Color(0xFF28343D), Color(0xFF14191F), Color(0xFF0D1014)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacing.s40.h,

            // Animated Audio Pulsing Avatar
            Stack(
              alignment: Alignment.center,
              children: [
                // Animated ripple 2
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 200.r,
                    height: 200.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                // Animated ripple 1
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 160.r,
                    height: 160.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary.withValues(alpha: 0.15),
                    ),
                  ),
                ),
                // Doctor Avatar
                Container(
                  width: 120.r,
                  height: 120.r,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: primary, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      widget.session.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: slate[700],
                          child: Icon(Icons.person, size: 60.r, color: white),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            Spacing.s24.h,

            // Doctor Name & Specialty
            Text(
              widget.session.expertName,
              style: h2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacing.s4.h,
            Text(
              widget.session.specialty,
              style: r14.copyWith(
                color: slate[300],
                fontWeight: FontWeight.w400,
              ),
            ),

            Spacing.s20.h,

            // Voice Session Status Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.volume_up_rounded, size: 16, color: primary),
                  Spacing.s8.w,
                  Text(
                    "Encrypted Voice Consultation Active",
                    style: r12.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            Spacing.s40.h,
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Patient Picture-in-Picture (Selfie Video Preview)
  // ---------------------------------------------------------------------------
  Widget buildPatientPip(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100.w,
        height: 140.h,
        decoration: BoxDecoration(
          color: const Color(0xFF2C3440),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isMicMuted ? dangerColor : primary,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Simulated Self Camera
              isVideoOff
                  ? Container(
                      color: const Color(0xFF1E252E),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.videocam_off_rounded,
                            size: 24,
                            color: slate[400],
                          ),
                          Spacing.s4.h,
                          Text(
                            "Camera Off",
                            style: r10.copyWith(color: slate[400]),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF384351), Color(0xFF242C35)],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person_rounded,
                          size: 45.r,
                          color: Colors.white54,
                        ),
                      ),
                    ),

              // PIP Top Controls (Flip Camera)
              if (!isVideoOff)
                Positioned(
                  top: 6,
                  right: 6,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isFrontCamera = !isFrontCamera;
                      });
                      HapticFeedback.lightImpact();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.cameraswitch_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              // "You" Badge with mic indicator
              Positioned(
                bottom: 6,
                left: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isMicMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                        size: 11,
                        color: isMicMuted ? dangerColor : successColor,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        "You",
                        style: r10.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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

  // ---------------------------------------------------------------------------
  // Bottom In-Call Controls Dock
  // ---------------------------------------------------------------------------
  Widget buildBottomControlsDock(BuildContext context) {
    final isVideoCall = widget.session.callType.toLowerCase().contains("video");

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF12161C).withValues(alpha: 0.95),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
          // Mic Toggle
          buildControlButton(
            icon: isMicMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
            label: isMicMuted ? "Unmute" : "Mute",
            isActive: !isMicMuted,
            activeColor: Colors.white.withValues(alpha: 0.15),
            inactiveColor: dangerColor.withValues(alpha: 0.25),
            iconColor: isMicMuted ? dangerColor : Colors.white,
            onTap: () {
              setState(() => isMicMuted = !isMicMuted);
              HapticFeedback.lightImpact();
            },
          ),

          // Video Toggle (Only enabled for Video calls)
          if (isVideoCall)
            buildControlButton(
              icon: isVideoOff
                  ? Icons.videocam_off_rounded
                  : Icons.videocam_rounded,
              label: isVideoOff ? "Start Video" : "Stop Video",
              isActive: !isVideoOff,
              activeColor: Colors.white.withValues(alpha: 0.15),
              inactiveColor: dangerColor.withValues(alpha: 0.25),
              iconColor: isVideoOff ? dangerColor : Colors.white,
              onTap: () {
                setState(() => isVideoOff = !isVideoOff);
                HapticFeedback.lightImpact();
              },
            ),

          // Speaker Toggle
          buildControlButton(
            icon: isSpeakerOn
                ? Icons.volume_up_rounded
                : Icons.volume_off_rounded,
            label: isSpeakerOn ? "Speaker" : "Earpiece",
            isActive: isSpeakerOn,
            activeColor: isSpeakerOn
                ? primary.withValues(alpha: 0.25)
                : Colors.white.withValues(alpha: 0.15),
            iconColor: isSpeakerOn ? primary : Colors.white,
            onTap: () {
              setState(() => isSpeakerOn = !isSpeakerOn);
              HapticFeedback.lightImpact();
            },
          ),

          // In-Call Chat / Messages
          buildControlButton(
            icon: Icons.chat_bubble_outline_rounded,
            label: "Chat",
            badgeCount: _inCallMessages.length,
            activeColor: Colors.white.withValues(alpha: 0.15),
            iconColor: Colors.white,
            onTap: () => _showChatModal(context),
          ),

          // End Call Action (Distinct Red Button)
          Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => _showLeaveConfirmation(context),
              child: Container(
                width: 56.r,
                height: 56.r,
                decoration: BoxDecoration(
                  color: dangerColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: dangerColor.withValues(alpha: 0.45),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.call_end_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);
  }

  Widget buildControlButton({
    required IconData icon,
    required String label,
    required Color activeColor,
    Color? inactiveColor,
    required Color iconColor,
    required VoidCallback onTap,
    bool isActive = true,
    int? badgeCount,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              color: isActive ? activeColor : (inactiveColor ?? activeColor),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Icon(icon, size: 22, color: iconColor),
                ),
              ),
            ),
            if (badgeCount != null && badgeCount > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    "$badgeCount",
                    textAlign: TextAlign.center,
                    style: r10.copyWith(
                      color: white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        Spacing.s4.h,
        Text(
          label,
          style: r10.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Session Agenda & Doctor Details Modal
  // ---------------------------------------------------------------------------
  void _showSessionDetailsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(context);
        return SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: theme.primaryColorLight,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: theme.dividerTheme.color ?? slate[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Spacing.s16.h,
              Text(
                "Consultation Information",
                style: h3.copyWith(
                  color: theme.textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacing.s12.h,
              CustomPrimaryCard(
                borderRadius: 12,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24.r,
                      backgroundImage: NetworkImage(widget.session.imageUrl),
                    ),
                    Spacing.s12.w,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.session.expertName,
                            style: r16.copyWith(
                              color: theme.textTheme.bodyLarge?.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.session.specialty,
                            style: r12.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.s16.h,
              Text(
                "Booking Time & Format",
                style: r14.copyWith(
                  color: theme.textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacing.s4.h,
              Text(
                "${widget.session.dateTime} • ${widget.session.callType} (${widget.session.duration} mins)",
                style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
              ),
              Spacing.s16.h,
              Text(
                "Your Consultation Notes / Goal",
                style: r14.copyWith(
                  color: theme.textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacing.s8.h,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: theme.dividerTheme.color ?? slate[200]!,
                  ),
                ),
                child: Text(
                  widget.session.notes?.isNotEmpty == true
                      ? widget.session.notes!
                      : "No specific notes provided during booking.",
                  style: r12.copyWith(color: theme.textTheme.bodyMedium?.color),
                ),
              ),
              Spacing.s24.h,
              CustomPrimaryButton(
                text: "Back to Consultation",
                backgroundColor: primary,
                onPressed: () => Navigator.pop(ctx),
              ),
              Spacing.s12.h,
            ],
          ),
        ),
      );
    },
  );
}

  // ---------------------------------------------------------------------------
  // In-Call Chat / Quick Message Modal
  // ---------------------------------------------------------------------------
  void _showChatModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(context);
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              top: false,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: BoxDecoration(
                  color: theme.primaryColorLight,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
              child: Column(
                children: [
                  Spacing.s12.h,
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: slate[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "In-Call Messages",
                          style: h3.copyWith(
                            color: theme.textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),
                  const CustomDivider(),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      itemCount: _inCallMessages.length,
                      itemBuilder: (context, index) {
                        final msg = _inCallMessages[index];
                        final isMe = msg["isMe"] == true;
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 10.h,
                            ),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.72,
                            ),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? primary
                                  : theme.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(14),
                                topRight: const Radius.circular(14),
                                bottomLeft: Radius.circular(isMe ? 14 : 2),
                                bottomRight: Radius.circular(isMe ? 2 : 14),
                              ),
                              border: isMe
                                  ? null
                                  : Border.all(
                                      color:
                                          theme.dividerTheme.color ??
                                          slate[200]!,
                                    ),
                            ),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg["text"] ?? "",
                                  style: r14.copyWith(
                                    color: isMe
                                        ? white
                                        : theme.textTheme.bodyLarge?.color,
                                  ),
                                ),
                                Spacing.s4.h,
                                Text(
                                  msg["time"] ?? "",
                                  style: r10.copyWith(
                                    color: isMe
                                        ? white.withValues(alpha: 0.8)
                                        : slate[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: 10.h,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      border: Border(
                        top: BorderSide(
                          color: theme.dividerTheme.color ?? slate[200]!,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            hintText: "Type in-call message...",
                            controller: _chatMessageController,
                          ),
                        ),
                        Spacing.s8.w,
                        Material(
                          color: primary,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              final text = _chatMessageController.text.trim();
                              if (text.isNotEmpty) {
                                final now = DateTime.now();
                                final timeStr =
                                    "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
                                setState(() {
                                  _inCallMessages.add({
                                    "sender": "You",
                                    "text": text,
                                    "time": timeStr,
                                    "isMe": true,
                                  });
                                });
                                setModalState(() {});
                                _chatMessageController.clear();
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

  // ---------------------------------------------------------------------------
  // Leave / End Consultation Confirmation Bottom Sheet
  // ---------------------------------------------------------------------------
  void _showLeaveConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(context);
        return SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            decoration: BoxDecoration(
              color: theme.primaryColorLight,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    color: dangerColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.call_end_rounded,
                      color: dangerColor,
                      size: 26,
                    ),
                  ),
                ),
                Spacing.s16.h,
                Text(
                  "End Consultation?",
                  style: h3.copyWith(
                    color: theme.textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacing.s8.h,
                Text(
                  "You have been connected for ${_formatTimer(elapsedSeconds)} with ${widget.session.expertName}. Are you sure you want to end this session?",
                  textAlign: TextAlign.center,
                  style: r14.copyWith(color: theme.textTheme.bodySmall?.color),
                ),
                Spacing.s24.h,
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          side: BorderSide(color: primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "Stay in Call",
                          style: r14.copyWith(
                            color: primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Spacing.s12.w,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _showFeedbackAndExitModal(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: dangerColor,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "End Session",
                          style: r14.copyWith(
                            color: white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Spacing.s8.h,
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Post-Session Feedback & Exit
  // ---------------------------------------------------------------------------
  void _showFeedbackAndExitModal(BuildContext context) {
    int rating = 5;
    final List<String> feedbackTags = [
      "Helpful Guidance",
      "Empathetic",
      "Clear Action Steps",
      "Calm & Safe Space",
    ];
    final Set<String> selectedTags = {"Helpful Guidance"};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(context);
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                decoration: BoxDecoration(
                  color: theme.primaryColorLight,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50.r,
                      height: 50.r,
                      decoration: BoxDecoration(
                        color: successColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: successColor,
                          size: 30,
                        ),
                      ),
                    ),
                    Spacing.s12.h,
                    Text(
                      "Session Complete",
                      style: h2.copyWith(
                        color: theme.textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacing.s4.h,
                    Text(
                      "Duration: ${_formatTimer(elapsedSeconds)} • With ${widget.session.expertName}",
                      style: r12.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                    Spacing.s16.h,
                    Text(
                      "How was your consultation experience?",
                      style: r14.copyWith(
                        color: theme.textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacing.s12.h,
                    // Star Rating Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starNum = index + 1;
                        return IconButton(
                          icon: Icon(
                            starNum <= rating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 34,
                            color: starNum <= rating
                                ? const Color(0xFFFFB800)
                                : slate[400],
                          ),
                          onPressed: () {
                            setModalState(() {
                              rating = starNum;
                            });
                          },
                        );
                      }),
                    ),
                    Spacing.s12.h,
                    // Tag chips
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      alignment: WrapAlignment.center,
                      children: feedbackTags.map((tag) {
                        final isSelected = selectedTags.contains(tag);
                        return FilterChip(
                          label: Text(
                            tag,
                            style: r12.copyWith(
                              color: isSelected
                                  ? white
                                  : theme.textTheme.bodyMedium?.color,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: primary,
                          backgroundColor: theme.scaffoldBackgroundColor,
                          checkmarkColor: white,
                          onSelected: (val) {
                            setModalState(() {
                              if (val) {
                                selectedTags.add(tag);
                              } else {
                                selectedTags.remove(tag);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    Spacing.s24.h,
                    CustomPrimaryButton(
                      text: "Submit & Return",
                      backgroundColor: primary,
                      onPressed: () {
                        if (widget.session.id != null &&
                            Get.isRegistered<SessionsController>()) {
                          Get.find<SessionsController>().updateSessionStatus(
                            widget.session.id!,
                            "Completed",
                          );
                        }
                        Navigator.pop(ctx);
                        Get.back();
                        Get.snackbar(
                          "Session Completed",
                          "Thank you for your feedback! Your session notes and booking summary are saved.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: successColor.withValues(alpha: 0.9),
                          colorText: white,
                          margin: const EdgeInsets.all(16),
                          duration: const Duration(seconds: 3),
                        );
                      },
                    ),
                    Spacing.s8.h,
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
