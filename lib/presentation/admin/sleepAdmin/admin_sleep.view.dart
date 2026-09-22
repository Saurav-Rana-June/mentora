import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/calm_music.model.dart';
import 'package:Mentora/data/model/sound.model.dart';
import 'package:Mentora/data/model/story.model.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:Mentora/widgets/others/custom.segmented.tab.widget.dart';
import '../widgets/admin_delete_dialog.widget.dart';
import '../widgets/admin_section_header.widget.dart';
import '../widgets/admin_skeleton_loading.widget.dart';
import 'controllers/admin_sleep.controller.dart';
import 'views/admin_music_form.dialog.dart';
import 'views/admin_sound_form.dialog.dart';
import 'views/admin_story_form.dialog.dart';

class AdminSleepView extends StatefulWidget {
  const AdminSleepView({super.key});

  @override
  State<AdminSleepView> createState() => _AdminSleepViewState();
}

class _AdminSleepViewState extends State<AdminSleepView>
    with SingleTickerProviderStateMixin {
  late final AdminSleepController controller;
  late final TabController _tabController;
  late final Worker _tabWorker;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<AdminSleepController>()
        ? Get.find<AdminSleepController>()
        : Get.put(AdminSleepController());

    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: controller.activeTab.value,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        controller.switchTab(_tabController.index);
      }
    });

    _tabWorker = ever(controller.activeTab, (int index) {
      if (_tabController.index != index) {
        _tabController.animateTo(index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => AdminSectionHeader(
              title: 'Sleep & Ambient Sounds CMS',
              subtitle:
                  'Manage nature soundscapes, calm sleep music tracks, and bedtime stories.',
              searchHint: 'Search sleep content...',
              onSearchChanged: controller.onSearchChanged,
              buttonText: controller.activeTab.value == 0
                  ? 'Add Sound'
                  : (controller.activeTab.value == 1 ? 'Add Music Track' : 'Add Story'),
              onAddPressed: () {
                if (controller.activeTab.value == 0) {
                  AdminSoundFormDialog.show(context: context);
                } else if (controller.activeTab.value == 1) {
                  AdminMusicFormDialog.show(context: context);
                } else {
                  AdminStoryFormDialog.show(context: context);
                }
              },
              onRefresh: controller.fetchAll,
            ),
          ),
          Spacing.s16.h,
          // Segmented Tabs
          Obx(() {
            final segmentTabs = [
              SegmentTab(
                label: '🌧️  Ambient Sounds (${controller.sounds.length})',
                color: primary,
                selectedTextColor: Colors.white,
                textColor: isDark ? slate[400] : slate[600],
              ),
              SegmentTab(
                label: '🎵  Calm Music (${controller.musicList.length})',
                color: primary,
                selectedTextColor: Colors.white,
                textColor: isDark ? slate[400] : slate[600],
              ),
              SegmentTab(
                label: '📖  Bedtime Stories (${controller.stories.length})',
                color: primary,
                selectedTextColor: Colors.white,
                textColor: isDark ? slate[400] : slate[600],
              ),
            ];

            return Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 640.w),
                child: CustomSegmentedTab(
                  tabs: segmentTabs,
                  controller: _tabController,
                  height: 44.h,
                  indicatorPadding: EdgeInsets.all(3.r),
                  textStyle: r14.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark ? slate[400] : slate[600],
                  ),
                  selectedTextStyle: r14.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  barDecoration: BoxDecoration(
                    color: isDark ? const Color(0xFF242522) : const Color(0xFFF1F3EB),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : slate[200]!,
                    ),
                  ),
                  indicatorDecoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(9.r),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          Spacing.s20.h,
          Obx(() {
            if (controller.isLoading.value) {
              final tab = controller.activeTab.value;
              if (tab == 0) {
                return const AdminGridSkeleton(
                  childAspectRatio: 1.6,
                  cardType: AdminSkeletonCardType.emoji,
                );
              } else {
                return const AdminGridSkeleton(
                  childAspectRatio: 1.35,
                  cardType: AdminSkeletonCardType.standard,
                );
              }
            }

            final tab = controller.activeTab.value;
            if (tab == 0) {
              return _buildSoundsList(context, controller);
            } else if (tab == 1) {
              return _buildMusicList(context, controller);
            } else {
              return _buildStoriesList(context, controller);
            }
          }),
        ],
      ),
    );
  }

  Widget _buildSoundsList(
    BuildContext context,
    AdminSleepController controller,
  ) {
    if (controller.sounds.isEmpty) {
      return _buildEmptyState('No ambient sounds found');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1100
            ? 3
            : (constraints.maxWidth > 700 ? 2 : 1);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1.6,
          ),
          itemCount: controller.sounds.length,
          itemBuilder: (context, index) {
            final sound = controller.sounds[index];
            return _buildSoundCard(context, sound, controller);
          },
        );
      },
    );
  }

  Widget _buildSoundCard(
    BuildContext context,
    SoundModel sound,
    AdminSleepController controller,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomPrimaryCard(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : slate[200]!,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      sound.emoji ?? '🌧️',
                      style: TextStyle(fontSize: 24.spMin),
                    ),
                  ),
                ),
                Spacing.s12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          sound.category ?? 'Nature',
                          style: r10.copyWith(
                            color: primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Spacing.s4.h,
                      Text(
                        sound.title ?? 'Ambient Sound',
                        style: r14.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.textTheme.headlineLarge?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            Icons.graphic_eq_rounded,
                            size: 13.spMin,
                            color: slate[400],
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              sound.audioUrl?.split('/').last ?? 'Looping audio',
                              style: r10.copyWith(
                                color: isDark ? slate[400] : slate[500],
                                fontFamily: 'monospace',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Divider(
              height: 1,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : slate[200]!,
            ),
            Spacing.s8.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF282926) : slate[100],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'ID: #${sound.id ?? 0}',
                    style: r10.copyWith(
                      color: isDark ? slate[400] : slate[600],
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Tooltip(
                      message: 'Edit Sound',
                      child: InkWell(
                        onTap: () => AdminSoundFormDialog.show(
                          context: context,
                          sound: sound,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 16.spMin,
                            color: primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Tooltip(
                      message: 'Delete Sound',
                      child: InkWell(
                        onTap: () => AdminDeleteDialog.show(
                          context: context,
                          title: 'Delete Sound',
                          itemName: sound.title ?? 'Sound',
                          onConfirm: () => controller.deleteSound(sound.id ?? 0),
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: dangerColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 16.spMin,
                            color: dangerColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicList(
    BuildContext context,
    AdminSleepController controller,
  ) {
    if (controller.musicList.isEmpty) {
      return _buildEmptyState('No calm music tracks found');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1100
            ? 3
            : (constraints.maxWidth > 700 ? 2 : 1);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1.35,
          ),
          itemCount: controller.musicList.length,
          itemBuilder: (context, index) {
            final item = controller.musicList[index];
            return _buildMusicCard(context, item, controller);
          },
        );
      },
    );
  }

  Widget _buildMusicCard(
    BuildContext context,
    CalmMusicModel item,
    AdminSleepController controller,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomPrimaryCard(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : slate[200]!,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11.r),
                    child: Image.network(
                      item.imageUrl ?? '',
                      width: 56.w,
                      height: 56.w,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 56.w,
                        height: 56.w,
                        color: primary.withValues(alpha: 0.15),
                        child: const Center(
                          child: Text('🎵', style: TextStyle(fontSize: 22)),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacing.s12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          item.category ?? 'Calm Music',
                          style: r10.copyWith(
                            color: primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Spacing.s4.h,
                      Text(
                        item.title ?? 'Music Track',
                        style: r14.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.textTheme.headlineLarge?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 12.spMin,
                            color: slate[400],
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            item.duration ?? '10 min',
                            style: r12.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Text(
                item.description ?? '',
                style: r12.copyWith(
                  color: theme.textTheme.bodyMedium?.color,
                  height: 1.35,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 6.h),
            Divider(
              height: 1,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : slate[200]!,
            ),
            Spacing.s8.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF282926) : slate[100],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'ID: #${item.id ?? 0}',
                    style: r10.copyWith(
                      color: isDark ? slate[400] : slate[600],
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Tooltip(
                      message: 'Edit Music',
                      child: InkWell(
                        onTap: () => AdminMusicFormDialog.show(
                          context: context,
                          music: item,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 16.spMin,
                            color: primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Tooltip(
                      message: 'Delete Music',
                      child: InkWell(
                        onTap: () => AdminDeleteDialog.show(
                          context: context,
                          title: 'Delete Music Track',
                          itemName: item.title ?? 'Track',
                          onConfirm: () => controller.deleteMusic(item.id ?? 0),
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: dangerColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 16.spMin,
                            color: dangerColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoriesList(
    BuildContext context,
    AdminSleepController controller,
  ) {
    if (controller.stories.isEmpty) {
      return _buildEmptyState('No bedtime stories found');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1100
            ? 3
            : (constraints.maxWidth > 700 ? 2 : 1);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1.35,
          ),
          itemCount: controller.stories.length,
          itemBuilder: (context, index) {
            final story = controller.stories[index];
            return _buildStoryCard(context, story, controller);
          },
        );
      },
    );
  }

  Widget _buildStoryCard(
    BuildContext context,
    StoryModel story,
    AdminSleepController controller,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomPrimaryCard(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : slate[200]!,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11.r),
                    child: Image.network(
                      story.imageUrl ?? '',
                      width: 56.w,
                      height: 56.w,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 56.w,
                        height: 56.w,
                        color: primary.withValues(alpha: 0.15),
                        child: const Center(
                          child: Text('📖', style: TextStyle(fontSize: 22)),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacing.s12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          story.category ?? 'Bedtime Story',
                          style: r10.copyWith(
                            color: primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Spacing.s4.h,
                      Text(
                        story.title ?? 'Bedtime Story',
                        style: r14.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.textTheme.headlineLarge?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 12.spMin,
                            color: slate[400],
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            story.duration ?? '15 min',
                            style: r12.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Text(
                story.description ?? '',
                style: r12.copyWith(
                  color: theme.textTheme.bodyMedium?.color,
                  height: 1.35,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 6.h),
            Divider(
              height: 1,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : slate[200]!,
            ),
            Spacing.s8.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF282926) : slate[100],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'ID: #${story.id ?? 0}',
                    style: r10.copyWith(
                      color: isDark ? slate[400] : slate[600],
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Tooltip(
                      message: 'Edit Story',
                      child: InkWell(
                        onTap: () => AdminStoryFormDialog.show(
                          context: context,
                          story: story,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 16.spMin,
                            color: primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Tooltip(
                      message: 'Delete Story',
                      child: InkWell(
                        onTap: () => AdminDeleteDialog.show(
                          context: context,
                          title: 'Delete Story',
                          itemName: story.title ?? 'Story',
                          onConfirm: () => controller.deleteStory(story.id ?? 0),
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: dangerColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 16.spMin,
                            color: dangerColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(48.h),
        child: Column(
          children: [
            Icon(Icons.nightlight_round, size: 48.spMin, color: slate[400]),
            Spacing.s12.h,
            Text(message, style: h3.copyWith(color: slate[500])),
          ],
        ),
      ),
    );
  }
}
