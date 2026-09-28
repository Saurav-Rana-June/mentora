import 'package:flutter/material.dart';

extension SpacingBox on num {
  Widget get gapH => SizedBox(height: toDouble());
  Widget get gapW => SizedBox(width: toDouble());
}
