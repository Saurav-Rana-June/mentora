import 'package:Mentora/widgets/others/custom.rating.gauage.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/mood_checkin.controller.dart';

class MoodCheckinScreen extends GetView<MoodCheckinController> {
  const MoodCheckinScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MoodCheckinScreen'), centerTitle: true),
      body: SizedBox(width: 300, child: RatingGauge()),
    );
  }
}
