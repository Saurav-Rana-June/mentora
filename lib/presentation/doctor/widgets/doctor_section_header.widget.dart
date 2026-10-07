import 'package:flutter/material.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/fields/custom_textfield.widget.dart';

class DoctorSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final String? buttonIcon;
  final VoidCallback? onRefresh;
  final Widget? filterWidget;
  final Widget? trailing;

  const DoctorSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.searchHint,
    this.onSearchChanged,
    this.buttonText,
    this.onButtonPressed,
    this.buttonIcon,
    this.onRefresh,
    this.filterWidget,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: h2.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.textTheme.headlineMedium?.color,
                            letterSpacing: -0.3,
                          ),
                        ),
                        if (subtitle != null) ...[
                          Spacing.s4.h,
                          Text(
                            subtitle!,
                            style: r14.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (onRefresh != null) ...[
                    Spacing.s8.w,
                    IconButton(
                      icon: Icon(
                        Icons.refresh_rounded,
                        color: theme.textTheme.bodyMedium?.color,
                        size: 22,
                      ),
                      onPressed: onRefresh,
                      tooltip: 'Refresh',
                    ),
                  ],
                  if (trailing != null) ...[
                    Spacing.s8.w,
                    trailing!,
                  ],
                ],
              ),
              if (searchHint != null || buttonText != null || filterWidget != null) ...[
                Spacing.s16.h,
                if (isMobile)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (searchHint != null) buildSearchField(context),
                      if (filterWidget != null) ...[
                        Spacing.s8.h,
                        filterWidget!,
                      ],
                      if (buttonText != null) ...[
                        Spacing.s8.h,
                        buildActionButton(),
                      ],
                    ],
                  )
                else
                  Row(
                    children: [
                      if (searchHint != null)
                        Expanded(
                          flex: 3,
                          child: buildSearchField(context),
                        ),
                      if (filterWidget != null) ...[
                        Spacing.s12.w,
                        filterWidget!,
                      ],
                      if (buttonText != null) ...[
                        Spacing.s12.w,
                        buildActionButton(),
                      ],
                    ],
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget buildSearchField(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 44,
      child: CustomTextFormField(
        hintText: searchHint ?? 'Search...',
        fillColor: theme.canvasColor,
        onChanged: onSearchChanged,
        prefixIcon: Container(
          width: 20,
          padding: const EdgeInsets.only(left: 8),
          child: Center(
            child: Text(
              '\u{f002}', // search icon
              style: TextStyle(
                fontFamily: 'FontAwesomeLight',
                fontSize: 14,
                color: primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildActionButton() {
    return SizedBox(
      height: 44,
      child: CustomPrimaryButton(
        text: buttonText ?? 'Action',
        onPressed: onButtonPressed,
        backgroundColor: primary,
        prefixIcon: buttonIcon != null
            ? Text(
                buttonIcon!,
                style: const TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 14,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}
