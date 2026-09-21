import 'package:get/get.dart';
import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/model/calm_music.model.dart';
import 'package:Mentora/data/model/sound.model.dart';
import 'package:Mentora/data/model/story.model.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/dal/services/sleep_service.dart';

class AdminSleepController extends GetxController {
  final RxInt activeTab = 0.obs; // 0: Sounds, 1: Music, 2: Stories
  final RxList<SoundModel> sounds = <SoundModel>[].obs;
  final RxList<CalmMusicModel> musicList = <CalmMusicModel>[].obs;
  final RxList<StoryModel> stories = <StoryModel>[].obs;

  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    isLoading.value = true;
    try {
      await Future.wait([
        fetchSounds(),
        fetchMusic(),
        fetchStories(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSounds() async {
    try {
      final res = await SleepService.getSleepSounds();
      if (res?.data != null) {
        sounds.assignAll(res!.data!);
      }
    } catch (e) {
      Get.log('Error fetching sleep sounds: $e');
    }
  }

  Future<void> fetchMusic() async {
    try {
      final res = await SleepService.getSleepMusic();
      if (res?.data != null) {
        musicList.assignAll(res!.data!);
      }
    } catch (e) {
      Get.log('Error fetching sleep music: $e');
    }
  }

  Future<void> fetchStories() async {
    try {
      final res = await SleepService.getSleepStories();
      if (res?.data != null) {
        stories.assignAll(res!.data!);
      }
    } catch (e) {
      Get.log('Error fetching sleep stories: $e');
    }
  }

  void switchTab(int index) {
    activeTab.value = index;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  // --- SOUNDS CRUD ---
  Future<bool> createSound({
    required String title,
    required String emoji,
    required String audioUrl,
    required String category,
  }) async {
    try {
      isSubmitting.value = true;
      final res = await SleepService.createSleepSound({
        'title': title,
        'emoji': emoji,
        'audioUrl': audioUrl,
        'category': category,
      });
      if (res?.data != null) {
        AppUtils.snackbar('Success', 'Sound created successfully', SnackBarType.SUCCESS);
        await fetchSounds();
        return true;
      }
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> updateSound({
    required int id,
    required String title,
    required String emoji,
    required String audioUrl,
    required String category,
  }) async {
    try {
      isSubmitting.value = true;
      final res = await SleepService.updateSleepSound(id, {
        'title': title,
        'emoji': emoji,
        'audioUrl': audioUrl,
        'category': category,
      });
      if (res?.data != null) {
        AppUtils.snackbar('Success', 'Sound updated successfully', SnackBarType.SUCCESS);
        await fetchSounds();
        return true;
      }
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteSound(int id) async {
    final res = await SleepService.deleteSleepSound(id);
    if (res != null) {
      sounds.removeWhere((s) => s.id == id);
      AppUtils.snackbar('Deleted', 'Sleep sound removed', SnackBarType.INFO);
      return true;
    }
    return false;
  }

  // --- MUSIC CRUD ---
  Future<bool> createMusic({
    required String title,
    required String category,
    required String duration,
    required String imageUrl,
    required String audioUrl,
    required String description,
  }) async {
    try {
      isSubmitting.value = true;
      final res = await SleepService.createSleepMusic({
        'title': title,
        'category': category,
        'duration': duration,
        'imageUrl': imageUrl,
        'audioUrl': audioUrl,
        'description': description,
      });
      if (res?.data != null) {
        AppUtils.snackbar('Success', 'Music track created', SnackBarType.SUCCESS);
        await fetchMusic();
        return true;
      }
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> updateMusic({
    required int id,
    required String title,
    required String category,
    required String duration,
    required String imageUrl,
    required String audioUrl,
    required String description,
  }) async {
    try {
      isSubmitting.value = true;
      final res = await SleepService.updateSleepMusic(id, {
        'title': title,
        'category': category,
        'duration': duration,
        'imageUrl': imageUrl,
        'audioUrl': audioUrl,
        'description': description,
      });
      if (res?.data != null) {
        AppUtils.snackbar('Success', 'Music track updated', SnackBarType.SUCCESS);
        await fetchMusic();
        return true;
      }
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteMusic(int id) async {
    final res = await SleepService.deleteSleepMusic(id);
    if (res != null) {
      musicList.removeWhere((m) => m.id == id);
      AppUtils.snackbar('Deleted', 'Music track removed', SnackBarType.INFO);
      return true;
    }
    return false;
  }

  // --- STORIES CRUD ---
  Future<bool> createStory({
    required String title,
    required String category,
    required String duration,
    required String imageUrl,
    required String audioUrl,
    required String description,
  }) async {
    try {
      isSubmitting.value = true;
      final res = await SleepService.createSleepStory({
        'title': title,
        'category': category,
        'duration': duration,
        'imageUrl': imageUrl,
        'audioUrl': audioUrl,
        'description': description,
      });
      if (res?.data != null) {
        AppUtils.snackbar('Success', 'Bedtime story created', SnackBarType.SUCCESS);
        await fetchStories();
        return true;
      }
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> updateStory({
    required int id,
    required String title,
    required String category,
    required String duration,
    required String imageUrl,
    required String audioUrl,
    required String description,
  }) async {
    try {
      isSubmitting.value = true;
      final res = await SleepService.updateSleepStory(id, {
        'title': title,
        'category': category,
        'duration': duration,
        'imageUrl': imageUrl,
        'audioUrl': audioUrl,
        'description': description,
      });
      if (res?.data != null) {
        AppUtils.snackbar('Success', 'Bedtime story updated', SnackBarType.SUCCESS);
        await fetchStories();
        return true;
      }
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteStory(int id) async {
    final res = await SleepService.deleteSleepStory(id);
    if (res != null) {
      stories.removeWhere((s) => s.id == id);
      AppUtils.snackbar('Deleted', 'Bedtime story removed', SnackBarType.INFO);
      return true;
    }
    return false;
  }
}
