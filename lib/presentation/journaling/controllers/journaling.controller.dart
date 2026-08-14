import 'dart:async';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Mentora/data/model/journal_entry.model.dart';
import 'package:Mentora/data/model/journal_question.model.dart';
import 'package:Mentora/data/utils/storage_utils.dart';
import 'package:Mentora/infrastructure/dal/services/journaling_service.dart';

class JournalingController extends GetxController {
  final entries = <JournalEntryModel>[].obs;
  final todayQuestion = ''.obs;
  final isSearching = false.obs;
  final searchText = ''.obs;
  final isLoading = true.obs;

  // Attachment states for the editing draft
  final attachedImagePath = Rxn<String>();
  final ImagePicker _picker = ImagePicker();

  static const String _questionsCacheKey = 'journaling_questions_cache';
  static const String _questionsLastUpdatedCacheKey = 'journaling_questions_last_updated';
  static const String _entriesCacheKey = 'journaling_entries_cache';
  static const String _entriesLastUpdatedCacheKey = 'journaling_entries_last_updated';

  final RxList<JournalQuestionModel> questionsList = <JournalQuestionModel>[].obs;

  final List<String> fallbackQuestions = [
    "What activities usually make you feel better when you're feeling low?",
    "If you could travel, where would you go and why?",
    "What small steps can you take this week to make your life better?",
    "How do you practice self-care and prioritize your well-being?",
    "What are three things you are most grateful for today?",
    "What was the most peaceful moment of your day today?",
    "What is a personal boundary you want to establish or strengthen?",
    "Describe a challenge you overcame recently and what you learned from it.",
    "What is a recent success, no matter how small, that you are proud of?",
    "What does your ideal morning routine look like?",
    "Who in your life makes you feel the most supported, and why?",
    "What is one thing you can forgive yourself for today?",
    "What are you holding onto that you need to let go of?",
    "What is a compliment you received recently that made you smile?",
    "How do you handle stress, and is there a healthier way you could try?",
    "What does a perfect, stress-free day look like to you?",
  ];

  @override
  void onInit() {
    super.onInit();
    // Initial fetch of questions and entries
    Future.wait([fetchQuestions(), fetchEntries()]);
  }

  Future<void> fetchQuestions({bool forceRefresh = false}) async {
    try {
      final List<dynamic>? cachedQuestions = StorageUtils.read<List<dynamic>>(_questionsCacheKey);
      final String? cachedLastUpdated = StorageUtils.read<String>(_questionsLastUpdatedCacheKey);

      bool hasCache = false;
      if (cachedQuestions != null && cachedQuestions.isNotEmpty && cachedLastUpdated != null) {
        questionsList.assignAll(
          cachedQuestions.map((e) => JournalQuestionModel.fromJson(Map<String, dynamic>.from(e as Map))).toList()
        );
        hasCache = true;
      }

      if (todayQuestion.value.isEmpty) {
        _setInitialTodayQuestion();
      }

      if (hasCache && !forceRefresh) {
        final checkRes = await JournalingService.getJournalingQuestions(lastUpdated: cachedLastUpdated);
        if (checkRes != null) {
          final cachedDateTime = DateTime.tryParse(cachedLastUpdated!);
          if (checkRes.lastUpdated != null && checkRes.lastUpdated == cachedDateTime) {
            return;
          }
        }
      }

      final res = await JournalingService.getJournalingQuestions();
      if (res != null && res.data != null) {
        questionsList.assignAll(res.data!);
        await StorageUtils.write(_questionsCacheKey, res.data!.map((e) => e.toJson()).toList());
        if (res.lastUpdated != null) {
          await StorageUtils.write(_questionsLastUpdatedCacheKey, res.lastUpdated!.toIso8601String());
        }
        _setInitialTodayQuestion();
      }
    } catch (e) {
      Get.log("Failed to load questions: $e");
    }
  }

  void _setInitialTodayQuestion() {
    final available = questionsList.map((q) => q.questionText).toList();
    if (available.isNotEmpty) {
      todayQuestion.value = available.first;
    } else {
      todayQuestion.value = fallbackQuestions.first;
    }
  }

  void rotateTodayQuestion() {
    final current = todayQuestion.value;
    final available = questionsList.map((q) => q.questionText).toList();
    final listToUse = available.isNotEmpty ? available : fallbackQuestions;
    final filtered = listToUse.where((q) => q != current).toList();
    if (filtered.isNotEmpty) {
      todayQuestion.value = (filtered..shuffle()).first;
    }
  }

  Future<void> fetchEntries({bool forceRefresh = false}) async {
    try {
      final List<dynamic>? cachedEntries = StorageUtils.read<List<dynamic>>(_entriesCacheKey);
      final String? cachedLastUpdated = StorageUtils.read<String>(_entriesLastUpdatedCacheKey);

      bool hasCache = false;
      if (cachedEntries != null && cachedLastUpdated != null) {
        final loaded = cachedEntries
            .map((e) => JournalEntryModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
        entries.assignAll(loaded);
        _sortEntries();
        hasCache = true;
      }

      if (hasCache) {
        isLoading.value = false;
      } else {
        isLoading.value = true;
      }

      if (hasCache && !forceRefresh) {
        final checkRes = await JournalingService.getJournalingEntries(lastUpdated: cachedLastUpdated);
        if (checkRes != null) {
          final cachedDateTime = DateTime.tryParse(cachedLastUpdated!);
          if (checkRes.lastUpdated != null && checkRes.lastUpdated == cachedDateTime) {
            return;
          }
        }
      }

      final res = await JournalingService.getJournalingEntries();
      if (res != null && res.data != null) {
        entries.assignAll(res.data!);
        _sortEntries();
        await StorageUtils.write(_entriesCacheKey, res.data!.map((e) => e.toJson()).toList());
        if (res.lastUpdated != null) {
          await StorageUtils.write(_entriesLastUpdatedCacheKey, res.lastUpdated!.toIso8601String());
        }
      }
    } catch (e) {
      Get.log("Failed to load entries: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _sortEntries() {
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> addEntry(String question, String answer, {String? imagePath}) async {
    try {
      final res = await JournalingService.createJournalingEntry(
        question: question,
        answer: answer,
        imagePath: imagePath,
      );
      if (res != null && res.data != null) {
        entries.insert(0, res.data!);
        _sortEntries();
        _saveToCache();
      }
    } catch (e) {
      Get.log("Failed to add entry: $e");
    }
  }

  Future<void> updateEntry(String id, String answer, {String? imagePath}) async {
    try {
      final res = await JournalingService.updateJournalingEntry(
        id: id,
        answer: answer,
        imagePath: imagePath,
      );
      if (res != null && res.data != null) {
        final index = entries.indexWhere((e) => e.id == id);
        if (index != -1) {
          entries[index] = res.data!;
          _sortEntries();
          _saveToCache();
        }
      }
    } catch (e) {
      Get.log("Failed to update entry: $e");
    }
  }

  Future<void> deleteEntry(String id) async {
    try {
      final res = await JournalingService.deleteJournalingEntry(id: id);
      if (res != null) {
        entries.removeWhere((e) => e.id == id);
        _saveToCache();
      }
    } catch (e) {
      Get.log("Failed to delete entry: $e");
    }
  }

  void _saveToCache() {
    StorageUtils.write(_entriesCacheKey, entries.map((e) => e.toJson()).toList());
  }

  // Media picking helpers
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(source: source);
      if (file != null) {
        attachedImagePath.value = file.path;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pick image: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void clearAttachment() {
    attachedImagePath.value = null;
  }

  List<JournalEntryModel> get filteredEntries {
    final query = searchText.value.trim().toLowerCase();
    if (query.isEmpty) {
      return entries;
    }
    return entries.where((e) {
      return e.question.toLowerCase().contains(query) ||
          e.answer.toLowerCase().contains(query);
    }).toList();
  }
}
