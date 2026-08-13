import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Mentora/data/model/journal_entry.model.dart';
import 'package:Mentora/data/utils/storage_utils.dart';

class JournalingController extends GetxController {
  static const String _storageKey = 'journal_entries';

  final entries = <JournalEntryModel>[].obs;
  final todayQuestion = ''.obs;
  final isSearching = false.obs;
  final searchText = ''.obs;

  // Attachment states for the editing draft
  final attachedImagePath = Rxn<String>();
  final ImagePicker _picker = ImagePicker();

  final List<String> presetQuestions = [
    "What activities usually make you feel better when you're feeling low?",
    "If you could travel, where would you go and why?",
    "What small steps can you take this week to make your life better?",
    "How do you practice self-care and prioritize your well-being?",
    "What are three things you are most grateful for today?",
    "What was the most peaceful moment of your day today?",
    "What is a personal boundary you want to establish or strengthen?",
    "Describe a challenge you overcame recently and what you learned from it.",
  ];

  @override
  void onInit() {
    super.onInit();
    loadEntries();
  }

  void loadEntries() {
    final List<dynamic>? stored = StorageUtils.read<List<dynamic>>(_storageKey);
    if (stored != null) {
      entries.assignAll(
        stored
            .map((e) => JournalEntryModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
    }
    _sortEntries();
    if (presetQuestions.isNotEmpty) {
      todayQuestion.value = presetQuestions.first;
    }
  }

  void _sortEntries() {
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void _saveToStorage() {
    final List<Map<String, dynamic>> data =
        entries.map((e) => e.toJson()).toList();
    StorageUtils.write(_storageKey, data);
  }

  void rotateTodayQuestion() {
    final current = todayQuestion.value;
    final available = presetQuestions.where((q) => q != current).toList();
    if (available.isNotEmpty) {
      todayQuestion.value = (available..shuffle()).first;
    }
  }

  void addEntry(String question, String answer, {String? imagePath}) {
    final newEntry = JournalEntryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      question: question,
      answer: answer,
      createdAt: DateTime.now(),
      imagePath: imagePath,
    );
    entries.insert(0, newEntry);
    _sortEntries();
    _saveToStorage();
  }

  void updateEntry(String id, String answer, {String? imagePath}) {
    final index = entries.indexWhere((e) => e.id == id);
    if (index != -1) {
      entries[index] = entries[index].copyWith(
        answer: answer,
        imagePath: imagePath,
        createdAt: DateTime.now(), // Update timestamp to now on edit
      );
      _sortEntries();
      _saveToStorage();
    }
  }

  void deleteEntry(String id) {
    entries.removeWhere((e) => e.id == id);
    _saveToStorage();
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
