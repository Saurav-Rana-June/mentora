import 'package:get/get.dart';
import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/model/journal_question.model.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/dal/services/journaling_service.dart';

class AdminJournalingController extends GetxController {
  final RxList<JournalQuestionModel> questions = <JournalQuestionModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      isLoading.value = true;
      final res = await JournalingService.getJournalingQuestions();
      if (res?.data != null) {
        questions.assignAll(res!.data!);
      }
    } catch (e) {
      Get.log('Error fetching journaling questions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<JournalQuestionModel> get filteredQuestions {
    if (searchQuery.value.isEmpty) return questions;
    return questions
        .where((q) => q.questionText.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  Future<bool> createQuestion(String questionText) async {
    try {
      isSubmitting.value = true;
      final res = await JournalingService.createPresetQuestion(questionText);
      if (res?.data != null) {
        AppUtils.snackbar('Success', 'Journal prompt question created', SnackBarType.SUCCESS);
        await fetchQuestions();
        return true;
      }
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> updateQuestion(int id, String questionText) async {
    try {
      isSubmitting.value = true;
      final res = await JournalingService.updatePresetQuestion(id, questionText);
      if (res?.data != null) {
        AppUtils.snackbar('Success', 'Journal prompt question updated', SnackBarType.SUCCESS);
        await fetchQuestions();
        return true;
      }
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteQuestion(int id) async {
    final res = await JournalingService.deletePresetQuestion(id);
    if (res != null) {
      questions.removeWhere((q) => q.id == id);
      AppUtils.snackbar('Deleted', 'Journal prompt question deleted', SnackBarType.INFO);
      return true;
    }
    return false;
  }
}
