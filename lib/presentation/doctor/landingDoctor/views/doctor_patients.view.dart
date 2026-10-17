import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

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

  final List<Map<String, dynamic>> _patients = [
    {
      'name': 'Jessica Miller',
      'age': 29,
      'gender': 'Female',
      'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
      'lastVisit': 'Today',
      'totalSessions': 4,
      'condition': 'Work burnout & acute anxiety triggers',
      'status': 'Active Patient',
    },
    {
      'name': 'David Kim',
      'age': 35,
      'gender': 'Male',
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
      'lastVisit': 'Today',
      'totalSessions': 6,
      'condition': 'Generalized Anxiety Disorder (GAD)',
      'status': 'Active Patient',
    },
    {
      'name': 'Sophia Patel',
      'age': 32,
      'gender': 'Female',
      'image': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200',
      'lastVisit': 'Today',
      'totalSessions': 2,
      'condition': 'Post-partum emotional changes & sleep issues',
      'status': 'Active Patient',
    },
    {
      'name': 'Marcus Reed',
      'age': 41,
      'gender': 'Male',
      'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
      'lastVisit': 'Tomorrow',
      'totalSessions': 1,
      'condition': 'Grief counseling & motivational fatigue',
      'status': 'New Patient',
    },
    {
      'name': 'Elena Rostova',
      'age': 26,
      'gender': 'Female',
      'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
      'lastVisit': 'Yesterday',
      'totalSessions': 8,
      'condition': 'Health anxiety & intrusive thoughts',
      'status': 'Maintenance Phase',
    },
    {
      'name': 'Benjamin Vance',
      'age': 48,
      'gender': 'Male',
      'image': 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=200',
      'lastVisit': '4 days ago',
      'totalSessions': 12,
      'condition': 'Executive stress & depressive episodes',
      'status': 'Maintenance Phase',
    },
  ];

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
