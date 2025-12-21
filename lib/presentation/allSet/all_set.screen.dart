import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/all_set.controller.dart';

class AllSetScreen extends GetView<AllSetController> {
  const AllSetScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AllSetScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AllSetScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
