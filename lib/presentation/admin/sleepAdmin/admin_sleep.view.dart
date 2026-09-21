import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/calm_music.model.dart';
import 'package:Mentora/data/model/sound.model.dart';
import 'package:Mentora/data/model/story.model.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import '../widgets/admin_delete_dialog.widget.dart';
import '../widgets/admin_section_header.widget.dart';
import 'controllers/admin_sleep.controller.dart';
import 'views/admin_music_form.dialog.dart';
import 'views/admin_sound_form.dialog.dart';
import 'views/admin_story_form.dialog.dart';

class AdminSleepView extends StatelessWidget {
  const AdminSleepView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminSleepController());
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
          Obx(
            () => Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF242522) : const Color(0xFFF1F3EB),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTabButton(
                    context,
                    title: 'Ambient Sounds (${controller.sounds.length})',
                    icon: '🌧️',
                    isSelected: controller.activeTab.value == 0,
                    onTap: () => controller.switchTab(0),
                  ),
                  _buildTabButton(
                    context,
                    title: 'Calm Music (${controller.musicList.length})',
                    icon: '🎵',
                    isSelected: controller.activeTab.value == 1,
                    onTap: () => controller.switchTab(1),
                  ),
                  _buildTabButton(
                    context,
                    title: 'Bedtime Stories (${controller.stories.length})',
                    icon: '📖',
                    isSelected: controller.activeTab.value == 2,
                    onTap: () => controller.switchTab(2),
                  ),
                ],
              ),
            ),
          ),
          Spacing.s20.h,
          Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(40.h),
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              );
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

  Widget _buildTabButton(
    BuildContext context, {
    required String title,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: isSelected
          ? (isDark ? const Color(0xFF1E1F1D) : white)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8.r),
      elevation: isSelected ? 1 : 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              Text(icon, style: TextStyle(fontSize: 14.spMin)),
              Spacing.s8.w,
              Text(
                title,
                style: r14.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? theme.textTheme.bodyLarge?.color
                      : theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
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
            childAspectRatio: 1.8,
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

    return CustomPrimaryCard(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      sound.emoji ?? '🌧️',
                      style: TextStyle(fontSize: 22.spMin),
                    ),
                  ),
                ),
                Spacing.s12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sound.title ?? 'Ambient Sound',
                        style: r14.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.textTheme.headlineLarge?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacing.s4.h,
                      Text(
                        sound.category ?? 'All',
                        style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID: #${sound.id ?? 0}',
                  style: r10.copyWith(color: slate[400], fontFamily: 'monospace'),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_outlined, size: 18.spMin, color: primary),
                      tooltip: 'Edit Sound',
                      onPressed: () => AdminSoundFormDialog.show(
                        context: context,
                        sound: sound,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline_rounded, size: 18.spMin, color: dangerColor),
                      tooltip: 'Delete Sound',
                      onPressed: () => AdminDeleteDialog.show(
                        context: context,
                        title: 'Delete Sound',
                        itemName: sound.title ?? 'Sound',
                        onConfirm: () => controller.deleteSound(sound.id ?? 0),
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
            childAspectRatio: 1.4,
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

    return CustomPrimaryCard(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.network(
                    item.imageUrl ?? '',
                    width: 52.w,
                    height: 52.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 52.w,
                      height: 52.w,
                      color: primary.withValues(alpha: 0.15),
                      child: const Center(child: Text('🎵', style: TextStyle(fontSize: 20))),
                    ),
                  ),
                ),
                Spacing.s12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title ?? 'Music Track',
                        style: r14.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.textTheme.headlineLarge?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacing.s4.h,
                      Text(
                        '${item.category ?? 'Music'} • ${item.duration ?? '10 min'}',
                        style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacing.s8.h,
            Expanded(
              child: Text(
                item.description ?? '',
                style: r12.copyWith(color: theme.textTheme.bodyMedium?.color),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID: #${item.id ?? 0}',
                  style: r10.copyWith(color: slate[400], fontFamily: 'monospace'),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_outlined, size: 18.spMin, color: primary),
                      tooltip: 'Edit Music',
                      onPressed: () => AdminMusicFormDialog.show(
                        context: context,
                        music: item,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline_rounded, size: 18.spMin, color: dangerColor),
                      tooltip: 'Delete Music',
                      onPressed: () => AdminDeleteDialog.show(
                        context: context,
                        title: 'Delete Music Track',
                        itemName: item.title ?? 'Track',
                        onConfirm: () => controller.deleteMusic(item.id ?? 0),
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
            childAspectRatio: 1.4,
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

    return CustomPrimaryCard(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.network(
                    story.imageUrl ?? '',
                    width: 52.w,
                    height: 52.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 52.w,
                      height: 52.w,
                      color: primary.withValues(alpha: 0.15),
                      child: const Center(child: Text('📖', style: TextStyle(fontSize: 20))),
                    ),
                  ),
                ),
                Spacing.s12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.title ?? 'Bedtime Story',
                        style: r14.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.textTheme.headlineLarge?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacing.s4.h,
                      Text(
                        '${story.category ?? 'Story'} • ${story.duration ?? '15 min'}',
                        style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacing.s8.h,
            Expanded(
              child: Text(
                story.description ?? '',
                style: r12.copyWith(color: theme.textTheme.bodyMedium?.color),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID: #${story.id ?? 0}',
                  style: r10.copyWith(color: slate[400], fontFamily: 'monospace'),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_outlined, size: 18.spMin, color: primary),
                      tooltip: 'Edit Story',
                      onPressed: () => AdminStoryFormDialog.show(
                        context: context,
                        story: story,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline_rounded, size: 18.spMin, color: dangerColor),
                      tooltip: 'Delete Story',
                      onPressed: () => AdminDeleteDialog.show(
                        context: context,
                        title: 'Delete Story',
                        itemName: story.title ?? 'Story',
                        onConfirm: () => controller.deleteStory(story.id ?? 0),
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
