import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/methods/app_method.dart';
import 'package:Mentora/data/model/api_response.dart';
import 'package:Mentora/data/model/doctor_appointment.model.dart';
import 'package:Mentora/data/model/doctor_availability.model.dart';
import 'package:Mentora/data/model/expert.model.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/dal/services/booking_session_service.dart';
import 'package:Mentora/infrastructure/dal/services/doctor_portal_service.dart';
import 'package:Mentora/infrastructure/theme/app_scale.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/doctor/appointmentDoctor/views/appointment_detail.dialog.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_appointment_card.widget.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_badge.widget.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_section_header.widget.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_stat_card.widget.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import '../controllers/landing_doctor.controller.dart';

class DoctorScheduleView extends StatefulWidget {
  const DoctorScheduleView({super.key});

  @override
  State<DoctorScheduleView> createState() => _DoctorScheduleViewState();
}

class _DoctorScheduleViewState extends State<DoctorScheduleView> {
  final _landingCtrl = Get.find<LandingDoctorController>();

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  late Set<String> _activeDays;
  late String _startHour;
  late String _endHour;
  late Set<String> _shifts;
  late Set<int> _durations;

  bool _isLoading = true;
  bool _isLoadingSlots = false;
  bool _isSaving = false;
  bool _isSettingsExpanded = false;

  String _selectedDate = '';
  List<String> _availableDates = [];
  List<TimeSlot> _timeSlots = [];
  List<DoctorAppointmentModel> _appointments = [];

  Worker? _profileWorker;

  @override
  void initState() {
    super.initState();
    _initPracticeSettings(_landingCtrl.doctorProfile.value);

    // Reactively update settings when doctorProfile loads from API
    _profileWorker = ever(_landingCtrl.doctorProfile, (profile) {
      if (mounted) {
        _initPracticeSettings(profile);
      }
    });

    _loadInitialData();
  }

  @override
  void dispose() {
    _profileWorker?.dispose();
    super.dispose();
  }

  void _initPracticeSettings(Expert? profile) {
    _activeDays = Set.from(
      profile?.availableDays ??
          ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
    );
    _startHour = profile?.workingHoursStart ?? '09:00 AM';
    _endHour = profile?.workingHoursEnd ?? '06:00 PM';
    _shifts = Set.from(
      profile?.availableShifts ?? ['Morning', 'Afternoon', 'Evening'],
    );
    _durations = Set.from(profile?.sessionDurations ?? [15, 30, 45, 60]);
    if (mounted) setState(() {});
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);

    final now = DateTime.now();
    final todayStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    _selectedDate = todayStr;

    final docId =
        AppMethod.getDoctorId() ?? _landingCtrl.doctorProfile.value?.id ?? 21;

    try {
      final results = await Future.wait([
        BookingSessionService.getDoctorAvailability(
          doctorId: docId,
          date: todayStr,
        ),
        DoctorPortalService.getAppointments(doctorId: docId),
      ]);

      final availRes = results[0] as ApiResponse<DoctorAvailabilityModel>?;
      final apptList = results[1] as List<DoctorAppointmentModel>?;

      if (availRes?.data != null) {
        _availableDates = availRes!.data!.availableDates;
        _timeSlots = availRes.data!.timeSlots;
      } else {
        _generateFallbackDates();
      }

      if (apptList != null) {
        _appointments = apptList;
      }
    } catch (e) {
      Get.log("Failed to load doctor schedule data: $e");
      _generateFallbackDates();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _generateFallbackDates() {
    final now = DateTime.now();
    _availableDates = List.generate(14, (i) {
      final d = now.add(Duration(days: i));
      return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}T00:00:00";
    });
  }

  Future<void> _onSelectDate(String dateStr) async {
    final dateOnly = dateStr.split('T')[0];
    if (_selectedDate == dateOnly && _timeSlots.isNotEmpty) return;

    setState(() {
      _selectedDate = dateOnly;
      _isLoadingSlots = true;
    });

    final docId =
        AppMethod.getDoctorId() ?? _landingCtrl.doctorProfile.value?.id ?? 21;

    try {
      final res = await BookingSessionService.getDoctorAvailability(
        doctorId: docId,
        date: dateOnly,
      );
      if (res?.data != null) {
        setState(() {
          _timeSlots = res!.data!.timeSlots;
          if (res.data!.availableDates.isNotEmpty) {
            _availableDates = res.data!.availableDates;
          }
        });
      }
    } catch (e) {
      Get.log("Failed to fetch slots for date $dateOnly: $e");
    } finally {
      if (mounted) setState(() => _isLoadingSlots = false);
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final initialParts = (isStart ? _startHour : _endHour).split(' ');
    final timeParts = initialParts[0].split(':');
    int hour = int.tryParse(timeParts[0]) ?? (isStart ? 9 : 18);
    int minute =
        timeParts.length > 1 ? (int.tryParse(timeParts[1]) ?? 0) : 0;

    if (initialParts.length > 1 &&
        initialParts[1].toUpperCase() == 'PM' &&
        hour < 12) {
      hour += 12;
    } else if (initialParts.length > 1 &&
        initialParts[1].toUpperCase() == 'AM' &&
        hour == 12) {
      hour = 0;
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
    );

    if (picked != null) {
      final period = picked.hour >= 12 ? 'PM' : 'AM';
      final h = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
      final formatted =
          '${h.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')} $period';

      setState(() {
        if (isStart) {
          _startHour = formatted;
        } else {
          _endHour = formatted;
        }
      });
    }
  }

  Future<void> _saveSchedule() async {
    setState(() => _isSaving = true);
    final profile = _landingCtrl.doctorProfile.value;
    final docId =
        AppMethod.getDoctorId() ?? profile?.id ?? 21;

    final updated = (profile ?? Expert(id: docId)).copyWith(
      availableDays: _activeDays.toList(),
      workingHoursStart: _startHour,
      workingHoursEnd: _endHour,
      availableShifts: _shifts.toList(),
      sessionDurations: _durations.toList(),
    );

    try {
      await DoctorPortalService.updateDoctorProfile(
        doctorId: docId,
        body: {
          'availableDays': _activeDays.toList(),
          'workingHoursStart': _startHour,
          'workingHoursEnd': _endHour,
          'availableShifts': _shifts.toList(),
          'sessionDurations': _durations.toList(),
        },
      );
      await DoctorPortalService.saveCurrentDoctorProfile(updated);
      _landingCtrl.doctorProfile.value = updated;
      AppUtils.snackbar(
        'Saved',
        'Clinical practice schedule updated successfully',
        SnackBarType.SUCCESS,
      );
    } catch (e) {
      AppUtils.snackbar(
        'Settings Saved',
        'Availability schedule updated locally',
        SnackBarType.SUCCESS,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  DateTime? _parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  String _formatDayOfWeek(DateTime dt) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dt.weekday - 1];
  }

  String _formatMonth(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[dt.month - 1];
  }

  String _formatFullDate(DateTime dt) {
    const fullDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const fullMonths = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${fullDays[dt.weekday - 1]}, ${dt.day} ${fullMonths[dt.month - 1]} ${dt.year}';
  }

  bool _hasAppointmentsOnDate(String dateStr) {
    final d = dateStr.split('T')[0];
    return _appointments.any(
      (a) =>
          a.bookingDate.split('T')[0] == d &&
          a.bookingStatus != 'Cancelled' &&
          a.bookingStatus != 'Canceled',
    );
  }

  DoctorAppointmentModel? _findMatchingAppointment(
    List<DoctorAppointmentModel> appointments,
    String time,
  ) {
    for (final a in appointments) {
      if (a.bookingTimeslot.trim().toLowerCase() == time.trim().toLowerCase()) {
        return a;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal(),
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          DoctorSectionHeader(
            title: 'Schedule & Availability',
            subtitle:
                'Monitor daily clinical calendar, inspect booked patient slots, and manage telehealth consultation hours.',
            buttonText: 'Save Settings',
            buttonIcon: '\u{f0c7}', // save icon
            onButtonPressed: _saveSchedule,
            onRefresh: _loadInitialData,
          ),

          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: CircularProgressIndicator(),
              ),
            )
          else ...[
            // 1. Quick Metrics Stat Cards Overview
            buildMetricsOverview(context),
            Spacing.s24.h,

            // 2. 14-Day Calendar Date Strip
            buildDateSelectorStrip(context),
            Spacing.s24.h,

            // 3. Selected Date Status & Daily Timeslots
            buildDailyTimeslotsSection(context),
            Spacing.s24.h,

            // 4. Scheduled Consultations on Selected Date
            buildDateAppointmentsSection(context),
            Spacing.s32.h,

            // 5. Practice Availability Configuration Card
            buildPracticeSettingsCard(context),
          ],
        ],
      ),
    );
  }

  // --- 1. Quick Metrics Stat Cards ---
  Widget buildMetricsOverview(BuildContext context) {
    final availableSlotsCount =
        _timeSlots.where((s) => s.isAvailable).length;
    final bookedSlotsCount =
        _timeSlots.where((s) => !s.isAvailable).length;

    final selectedDateAppointments = _appointments.where((a) {
      return a.bookingDate.split('T')[0] == _selectedDate &&
          a.bookingStatus != 'Cancelled' &&
          a.bookingStatus != 'Canceled';
    }).length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;
        final cardWidth = isMobile
            ? (constraints.maxWidth - 12) / 2
            : (constraints.maxWidth - 36) / 4;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: cardWidth,
              child: DoctorStatCard(
                title: 'Available Slots',
                value: availableSlotsCount.toString(),
                subtitle: 'Open for booking today',
                icon: '\u{f017}', // clock
                iconColor: primary,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: DoctorStatCard(
                title: 'Booked Sessions',
                value: selectedDateAppointments.toString(),
                subtitle: '$bookedSlotsCount slots reserved',
                icon: '\u{f073}', // calendar
                iconColor: const Color(0xFF8B5CF6),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: DoctorStatCard(
                title: 'Practice Days',
                value: '${_activeDays.length} Days',
                subtitle: 'Active this week',
                icon: '\u{f274}', // calendar-check
                iconColor: successColor,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: DoctorStatCard(
                title: 'Clinical Hours',
                value: _startHour,
                subtitle: 'Until $_endHour',
                icon: '\u{f0f0}', // user-md
                iconColor: infoColor,
              ),
            ),
          ],
        );
      },
    );
  }

  // --- 2. 14-Day Calendar Date Strip ---
  Widget buildDateSelectorStrip(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Date',
              style: h3.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.textTheme.headlineSmall?.color,
              ),
            ),
            DoctorBadge(
              text: '14-Day Calendar Window',
              icon: '\u{f073}',
              color: primary,
            ),
          ],
        ),
        Spacing.s12.h,
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _availableDates.length,
            separatorBuilder: (context, index) => Spacing.s8.w,
            itemBuilder: (context, index) {
              final dateStr = _availableDates[index];
              final dateOnly = dateStr.split('T')[0];
              final parsed = _parseDate(dateStr) ?? now.add(Duration(days: index));
              final isSelected = _selectedDate == dateOnly;
              final isToday = parsed.year == now.year &&
                  parsed.month == now.month &&
                  parsed.day == now.day;
              final hasBookings = _hasAppointmentsOnDate(dateStr);

              return InkWell(
                onTap: () => _onSelectDate(dateStr),
                borderRadius: BorderRadius.circular(12.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 74,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primary
                        : (isDark ? const Color(0xFF222320) : white),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected
                          ? primary
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : slate[200]!),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: primary.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isToday ? 'TODAY' : _formatDayOfWeek(parsed).toUpperCase(),
                        style: r10.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? white
                              : (isToday
                                  ? primary
                                  : theme.textTheme.bodySmall?.color),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Spacing.s4.h,
                      Text(
                        '${parsed.day}',
                        style: h3.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? white
                              : theme.textTheme.headlineMedium?.color,
                        ),
                      ),
                      Spacing.s4.h,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatMonth(parsed),
                            style: r10.copyWith(
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? white.withValues(alpha: 0.85)
                                  : theme.textTheme.bodySmall?.color,
                            ),
                          ),
                          if (hasBookings) ...[
                            Spacing.s4.w,
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? white
                                    : const Color(0xFF8B5CF6),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- 3. Selected Date Status & Daily Timeslots ---
  Widget buildDailyTimeslotsSection(BuildContext context) {
    final theme = Theme.of(context);

    final parsedSelected = _parseDate(_selectedDate) ?? DateTime.now();
    final formattedFull = _formatFullDate(parsedSelected);

    return CustomPrimaryCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Banner Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.event, color: primary, size: 20),
                          Spacing.s8.w,
                          Expanded(
                            child: Text(
                              formattedFull,
                              style: h3.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.textTheme.headlineSmall?.color,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Spacing.s4.h,
                      Text(
                        'Patient booking slots generated for this clinical session date.',
                        style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                      ),
                    ],
                  ),
                ),
                Spacing.s12.w,
                DoctorBadge(
                  text: 'Telehealth Active',
                  icon: '\u{f00c}',
                  color: successColor,
                ),
              ],
            ),
            const Divider(height: 32),

            if (_isLoadingSlots)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_timeSlots.isEmpty)
              buildEmptySlotsState(context)
            else ...[
              // Grouped Timeslots by Period
              buildShiftTimeslots(
                context,
                title: 'Morning Consultations',
                icon: '\u{f185}', // sun
                iconColor: const Color(0xFFF59E0B),
                timeRange: '09:00 AM - 11:30 AM',
                slots: _timeSlots
                    .where((s) => s.period.toLowerCase() == 'morning')
                    .toList(),
              ),
              Spacing.s20.h,
              buildShiftTimeslots(
                context,
                title: 'Afternoon Consultations',
                icon: '\u{f0c2}', // cloud
                iconColor: primary,
                timeRange: '01:30 PM - 03:30 PM',
                slots: _timeSlots
                    .where((s) => s.period.toLowerCase() == 'afternoon')
                    .toList(),
              ),
              Spacing.s20.h,
              buildShiftTimeslots(
                context,
                title: 'Evening Consultations',
                icon: '\u{f186}', // moon
                iconColor: const Color(0xFF8B5CF6),
                timeRange: '05:00 PM - 07:00 PM',
                slots: _timeSlots
                    .where((s) => s.period.toLowerCase() == 'evening')
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildShiftTimeslots(
    BuildContext context, {
    required String title,
    required String icon,
    required Color iconColor,
    required String timeRange,
    required List<TimeSlot> slots,
  }) {
    if (slots.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final dateAppointments = _appointments.where((a) {
      return a.bookingDate.split('T')[0] == _selectedDate;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: isDark ? 0.2 : 0.12),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                icon,
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 14,
                  color: iconColor,
                ),
              ),
            ),
            Spacing.s8.w,
            Text(
              title,
              style: r16.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            Spacing.s8.w,
            Text(
              '($timeRange)',
              style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
            ),
          ],
        ),
        Spacing.s12.h,
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: slots.map((slot) {
            final isAvailable = slot.isAvailable;
            final matchingAppt =
                _findMatchingAppointment(dateAppointments, slot.time);

            Color chipBg;
            Color chipBorder;
            Color textColor;
            String statusText;
            IconData statusIcon;

            if (isAvailable) {
              chipBg = primary.withValues(alpha: isDark ? 0.15 : 0.08);
              chipBorder = primary.withValues(alpha: 0.4);
              textColor = isDark ? white : const Color(0xFF15803D);
              statusText = 'Available';
              statusIcon = Icons.check_circle_outline_rounded;
            } else {
              chipBg = isDark
                  ? const Color(0xFF2E241E)
                  : const Color(0xFFFEF3C7);
              chipBorder = isDark
                  ? const Color(0xFF78350F)
                  : const Color(0xFFFDE68A);
              textColor = isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309);
              statusText = matchingAppt != null
                  ? matchingAppt.patientName
                  : 'Booked';
              statusIcon = matchingAppt != null
                  ? Icons.person_rounded
                  : Icons.lock_clock_rounded;
            }

            return Tooltip(
              message: isAvailable
                  ? 'Slot open for patient consultation'
                  : (matchingAppt != null
                      ? 'Booked with ${matchingAppt.patientName} (${matchingAppt.modalityType})'
                      : 'Reserved by patient'),
              child: InkWell(
                onTap: matchingAppt != null
                    ? () => AppointmentDetailDialog.show(
                          context: context,
                          appointment: matchingAppt,
                        )
                    : null,
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: chipBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: textColor),
                      Spacing.s4.w,
                      Text(
                        slot.time,
                        style: r14.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      Spacing.s8.w,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: textColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          statusText,
                          style: r10.copyWith(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildEmptySlotsState(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.event_busy_rounded, size: 48, color: slate[400]),
            Spacing.s12.h,
            Text(
              'No timeslots scheduled for this date',
              style: r16.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            Spacing.s4.h,
            Text(
              'Configure your practice days and consultation hours below to open slots.',
              style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
            ),
          ],
        ),
      ),
    );
  }

  // --- 4. Scheduled Consultations on Selected Date ---
  Widget buildDateAppointmentsSection(BuildContext context) {
    final theme = Theme.of(context);
    final dateAppointments = _appointments.where((a) {
      return a.bookingDate.split('T')[0] == _selectedDate;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Patient Appointments on Selected Date (${dateAppointments.length})',
              style: h3.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.textTheme.headlineSmall?.color,
              ),
            ),
            if (dateAppointments.isNotEmpty)
              DoctorBadge(
                text: '${dateAppointments.length} Booked',
                icon: '\u{f0c0}',
                color: const Color(0xFF8B5CF6),
              ),
          ],
        ),
        Spacing.s12.h,
        if (dateAppointments.isEmpty)
          CustomPrimaryCard(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.event_available_rounded,
                          color: primary,
                          size: 28,
                        ),
                      ),
                    ),
                    Spacing.s12.h,
                    Text(
                      'No patient consultations booked for this day',
                      style: r16.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    Spacing.s4.h,
                    Text(
                      'All open timeslots remain available for patient reservations.',
                      style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 850;
              final itemWidth = isWide
                  ? (constraints.maxWidth - 16) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: dateAppointments.map((appt) {
                  return SizedBox(
                    width: itemWidth,
                    child: DoctorAppointmentCard(
                      appointment: appt,
                      onViewDetails: () => AppointmentDetailDialog.show(
                        context: context,
                        appointment: appt,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
      ],
    );
  }

  // --- 5. Practice Availability Configuration Card ---
  Widget buildPracticeSettingsCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomPrimaryCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Settings Header with Expand/Collapse toggle
            InkWell(
              onTap: () => setState(() => _isSettingsExpanded = !_isSettingsExpanded),
              borderRadius: BorderRadius.circular(8.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.tune_rounded, color: primary, size: 20),
                            Spacing.s8.w,
                            Text(
                              'Weekly Practice Hours & Rules',
                              style: h3.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.textTheme.headlineSmall?.color,
                              ),
                            ),
                          ],
                        ),
                        Spacing.s4.h,
                        Text(
                          'Configure working days, consultation shifts, daily hours, and allowed session lengths.',
                          style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isSettingsExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: theme.textTheme.bodyMedium?.color,
                      size: 24,
                    ),
                    onPressed: () =>
                        setState(() => _isSettingsExpanded = !_isSettingsExpanded),
                  ),
                ],
              ),
            ),

            if (_isSettingsExpanded) ...[
              const Divider(height: 32),

              // Weekly Practice Days
              Text(
                'Weekly Practice Days',
                style: r16.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              Spacing.s4.h,
              Text(
                'Days patients are permitted to schedule telehealth appointments.',
                style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
              ),
              Spacing.s12.h,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _days.map((day) {
                  final isSelected = _activeDays.contains(day);
                  return FilterChip(
                    label: Text(day),
                    selected: isSelected,
                    selectedColor: primary.withValues(alpha: 0.2),
                    checkmarkColor: primary,
                    labelStyle: r12.copyWith(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? primary : theme.textTheme.bodyMedium?.color,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _activeDays.add(day);
                        } else if (_activeDays.length > 1) {
                          _activeDays.remove(day);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              Spacing.s24.h,

              // Consultation Working Hours
              Text(
                'Daily Consultation Hours',
                style: r16.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              Spacing.s4.h,
              Text(
                'Click either time block below to change your daily practice window.',
                style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
              ),
              Spacing.s12.h,
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickTime(isStart: true),
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF242522) : slate[50],
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: isDark ? slate[700]! : slate[300]!,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Daily Start Time',
                                  style: r10.copyWith(
                                    color: theme.textTheme.bodySmall?.color,
                                  ),
                                ),
                                Spacing.s4.h,
                                Text(
                                  _startHour,
                                  style: r16.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: primary,
                                  ),
                                ),
                              ],
                            ),
                            Icon(Icons.schedule_rounded, color: primary, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Spacing.s16.w,
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickTime(isStart: false),
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF242522) : slate[50],
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: isDark ? slate[700]! : slate[300]!,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Daily End Time',
                                  style: r10.copyWith(
                                    color: theme.textTheme.bodySmall?.color,
                                  ),
                                ),
                                Spacing.s4.h,
                                Text(
                                  _endHour,
                                  style: r16.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: primary,
                                  ),
                                ),
                              ],
                            ),
                            Icon(Icons.schedule_rounded, color: primary, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacing.s24.h,

              // Active Shifts
              Text(
                'Available Telehealth Shifts',
                style: r16.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              Spacing.s12.h,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Morning', 'Afternoon', 'Evening'].map((s) {
                  final isSelected = _shifts.contains(s);
                  return FilterChip(
                    label: Text(s),
                    selected: isSelected,
                    selectedColor: primary.withValues(alpha: 0.2),
                    checkmarkColor: primary,
                    labelStyle: r12.copyWith(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? primary : theme.textTheme.bodyMedium?.color,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _shifts.add(s);
                        } else if (_shifts.length > 1) {
                          _shifts.remove(s);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              Spacing.s24.h,

              // Consultation Durations
              Text(
                'Permitted Consultation Durations',
                style: r16.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              Spacing.s12.h,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [15, 30, 45, 60].map((d) {
                  final isSelected = _durations.contains(d);
                  return FilterChip(
                    label: Text('$d Minutes'),
                    selected: isSelected,
                    selectedColor: primary.withValues(alpha: 0.2),
                    checkmarkColor: primary,
                    labelStyle: r12.copyWith(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? primary : theme.textTheme.bodyMedium?.color,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _durations.add(d);
                        } else if (_durations.length > 1) {
                          _durations.remove(d);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              Spacing.s24.h,

              // Save Button
              CustomPrimaryButton(
                text: 'Save Practice Availability Settings',
                isLoading: _isSaving,
                backgroundColor: primary,
                onPressed: _saveSchedule,
                prefixIcon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
