import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/onboarding/controllers/onboarding.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

class GenderView extends StatelessWidget {
  GenderView({super.key});

  final controller = Get.find<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.horizontal,
      ),
      child: Column(
        children: [
          Text(
            "What is your Gender?",
            textAlign: TextAlign.center,
            style: h2.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.headlineMedium!.color,
            ),
          ),
          Text(
            "Help us to understand you better by specifying your gender.",
            textAlign: TextAlign.center,
            style: r14.copyWith(
              color: Theme.of(context).textTheme.bodySmall!.color,
            ),
          ),
          Spacing.s32.h,

          // Male and Female Options
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => GenderOption(
                  icon: Icons.male,
                  label: "Male",
                  isSelected: controller.selectedGenderIsMale.value,
                  onTap: () {
                    controller.selectedGenderIsMale.value = true;
                  },
                ),
              ),
              Spacing.s20.w,
              Obx(
                () => GenderOption(
                  icon: Icons.female,
                  label: "Female",
                  isSelected: !controller.selectedGenderIsMale.value,
                  onTap: () {
                    controller.selectedGenderIsMale.value = false;
                  },
                ),
              ),
            ],
          ),
          Spacing.s32.h,

          // Prefer not to say option
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              side: BorderSide(
                color:
                    Theme.of(
                      context,
                    ).outlinedButtonTheme.style?.side?.resolve({})?.color ??
                    Colors.grey,
              ),
            ),
            onPressed: () {},
            child: Text(
              "Prefer not to say",
              style: r14.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GenderOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderOption({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ButtonStyle? style = Theme.of(context).outlinedButtonTheme.style;

    final BorderSide inactiveSide =
        style?.side?.resolve({}) ??
        BorderSide(color: Theme.of(context).dividerColor, width: 1.2);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? theme.colorScheme.primary
                  : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : inactiveSide.color.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              size: 80,
              color: isSelected
                  ? white
                  : theme.iconTheme.color!.withValues(alpha: 0.5),
            ),
          ),
          Spacing.s8.h,
          Text(
            label,
            style: r14.copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.textTheme.bodyMedium!.color!.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
