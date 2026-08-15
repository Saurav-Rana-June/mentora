import 'package:flutter/material.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';

class MeditationHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onSearchTap;

  const MeditationHeader({super.key, this.onSearchTap});

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: const Center(child: CustomBackButton()),
      title: Text(
        "Meditation",
        style: h2.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
