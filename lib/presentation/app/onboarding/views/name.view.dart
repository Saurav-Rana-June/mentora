import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';

class NameView extends StatelessWidget {
  const NameView({super.key});

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
            "What should we call you?",
            textAlign: TextAlign.center,
            style: h2.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.headlineMedium!.color,
            ),
          ),
          Text(
            "First thing first, what should we call you?",
            textAlign: TextAlign.center,
            style: r14.copyWith(
              color: Theme.of(context).textTheme.bodySmall!.color,
            ),
          ),
          Spacing.s32.h,

          TextFormField(
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            style: h1.copyWith(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: Spacing.s8.symmetric.horizontal,
                vertical: Spacing.s8.symmetric.vertical,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
