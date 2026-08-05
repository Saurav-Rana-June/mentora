import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';

class MeditationHeader extends StatelessWidget {
  final VoidCallback? onSearchTap;

  const MeditationHeader({
    super.key,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      surfaceTintColor: Colors.transparent,
      pinned: true,
      elevation: 0,
      centerTitle: true,
      leading: const Center(
        child: CustomBackButton(),
      ),
      title: Text(
        "Meditation",
        style: h2.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: Spacing.s16.value.w),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onSearchTap,
              child: Container(
                height: 40.h,
                width: 40.h,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    MyIcons.magnifyingGlass,
                    style: TextStyle(
                      fontFamily: 'FontAwesomeLight',
                      fontSize: 20.sp,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
