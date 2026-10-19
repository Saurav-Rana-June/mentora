import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/dal/services/doctor_portal_service.dart';
import 'package:Mentora/infrastructure/theme/app_scale.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_badge.widget.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_section_header.widget.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';

class DoctorPatientsView extends StatefulWidget {
  const DoctorPatientsView({super.key});

  @override
  State<DoctorPatientsView> createState() => _DoctorPatientsViewState();
}

class _DoctorPatientsViewState extends State<DoctorPatientsView> {
  String _searchQuery = '';
  List<Map<String, dynamic>> _patients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    try {
      final appts = await DoctorPortalService.getAppointments();
      final Map<int, Map<String, dynamic>> patientMap = {};
      for (final a in appts) {
        if (!patientMap.containsKey(a.userId)) {
          patientMap[a.userId] = {
            'name': a.patientName,
            'age': a.patientAge,
            'gender': a.patientGender,
            'image': a.patientImage,
            'lastVisit': a.bookingDate,
            'totalSessions': 1,
            'condition': a.patientIssue,
            'status': a.bookingStatus == 'Completed' ? 'Active Patient' : 'Upcoming Consultation',
          };
        } else {
          final p = patientMap[a.userId]!;
          p['totalSessions'] = (p['totalSessions'] as int) + 1;
        }
      }
      if (mounted) {
        setState(() {
          _patients = patientMap.values.toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _patients.where((p) {
      final name = p['name'].toString().toLowerCase();
      final cond = p['condition'].toString().toLowerCase();
      final q = _searchQuery.toLowerCase().trim();
      return name.contains(q) || cond.contains(q);
    }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal(),
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoctorSectionHeader(
            title: 'Patient Directory & History',
            subtitle: 'Review clinical patient records, visit histories, and ongoing care plans.',
            searchHint: 'Search patients by name or condition...',
            onSearchChanged: (val) => setState(() => _searchQuery = val),
          ),
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(48),
                child: CircularProgressIndicator(),
              ),
            )
          else if (filtered.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '\u{f0c0}', // users icon
                        style: TextStyle(
                          fontFamily: 'FontAwesomeSolid',
                          fontSize: 32,
                          color: primary,
                        ),
                      ),
                    ),
                    Spacing.s16.h,
                    Text(
                      'No Patient Records Found',
                      style: h3.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Spacing.s4.h,
                    Text(
                      'You do not have any patient consultation records yet.',
                      style: r14.copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => Spacing.s12.h,
            itemBuilder: (context, index) {
              final p = filtered[index];
              return CustomPrimaryCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.r),
                            child: CachedNetworkImage(
                              imageUrl: p['image'],
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => const CircleAvatar(child: Icon(Icons.person)),
                            ),
                          ),
                          Spacing.s12.w,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        p['name'],
                                        style: h3.copyWith(fontWeight: FontWeight.w700),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Spacing.s8.w,
                                    DoctorBadge(
                                      text: p['status'],
                                      color: p['status'] == 'New Patient' ? infoColor : primary,
                                    ),
                                  ],
                                ),
                                Spacing.s4.h,
                                Text(
                                  '${p['age']}y • ${p['gender']} • ${p['condition']}',
                                  style: r12.copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Spacing.s8.h,
                      Text(
                        'Last consultation: ${p['lastVisit']} • Total completed sessions: ${p['totalSessions']}',
                        style: r10.copyWith(color: primary, fontWeight: FontWeight.w600),
                      ),
                      Spacing.s12.h,
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Patient Record: ${p['name']}'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Primary Condition: ${p['condition']}'),
                                    Spacing.s8.h,
                                    Text('Total Sessions: ${p['totalSessions']}'),
                                    Spacing.s8.h,
                                    Text('Care Plan: Weekly cognitive behavioral sessions + guided breathing.'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text('Clinical History'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
