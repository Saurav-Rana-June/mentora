import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Mentora/presentation/musicPlayer/music_player_view.dart';
import 'controllers/meditation_player.controller.dart';

class MeditationPlayerScreen extends GetView<MeditationPlayerController> {
  MeditationPlayerScreen({super.key});

  @override
  final controller = Get.put(MeditationPlayerController());

  @override
  Widget build(BuildContext context) {
    return MusicPlayerView(
      audioUrl: controller.session.soundTrack,
      title: controller.session.title,
      category: controller.session.category,
      imageUrl: controller.session.imageUrl,
      description: controller.session.description,
      duration: controller.session.duration,
      isFavorited: controller.isFavorited,
      onFavoriteTap: () => controller.toggleFavorite(),
    );
  }
}
