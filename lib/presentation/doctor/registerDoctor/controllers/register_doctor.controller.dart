import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/methods/app_method.dart';
import 'package:Mentora/data/model/api_response.dart';
import 'package:Mentora/data/model/expert.model.dart';
import 'package:Mentora/data/model/speciality.model.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/dal/services/doctor_portal_service.dart';
import 'package:Mentora/infrastructure/dal/services/doctor_service.dart';
import 'package:Mentora/infrastructure/dal/services/speciality_service.dart';
import 'package:Mentora/infrastructure/navigation/routes.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';

class RegisterDoctorController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final accountFormKey = GlobalKey<FormState>();
  final profileFormKey = GlobalKey<FormState>();
  final step1FormKey = GlobalKey<FormState>();
  final step2FormKey = GlobalKey<FormState>();
  final step3FormKey = GlobalKey<FormState>();

  /// 0 = Step 1: Register/Create Account (Email & Password), 1 = Step 2: Profile Update UI
  final RxInt registrationStage = 0.obs;
  final RxInt registeredDoctorId = 0.obs;

  final RxInt currentStep = 0.obs;
  final RxBool certifiedCredentials = true.obs;

  // --- Step 1: Basic Information ---
  final nameController = TextEditingController();
  final imageController = TextEditingController();
  final RxString avatarUrl = ''.obs;
  final ratingController = TextEditingController();
  final reviewsController = TextEditingController();
  final experienceController = TextEditingController();
  final patientsController = TextEditingController();
  final priceController = TextEditingController();
  final specialtiesController = TextEditingController();
  final languagesController = TextEditingController();
  final bioController = TextEditingController();

  // --- Step 2: Account Credentials & Security ---
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final RxBool hidePassword = true.obs;
  final RxBool hideConfirmPassword = true.obs;

  void togglePasswordVisibility() => hidePassword.value = !hidePassword.value;
  void toggleConfirmPasswordVisibility() => hideConfirmPassword.value = !hideConfirmPassword.value;

  final RxString selectedSpeciality = ''.obs;
  final RxList<Speciality> specialities = <Speciality>[].obs;

  // --- Step 2: Educational & Professional ---
  final degreeController = TextEditingController();
  final universityController = TextEditingController();
  final gradYearController = TextEditingController();
  final licenseController = TextEditingController();
  final certificationsController = TextEditingController();

  // --- Step 3: Availability & Schedule ---
  final RxBool callFeature = true.obs;
  final RxBool videoCallFeature = true.obs;
  final RxBool isAvailable = true.obs;
  final RxList<String> selectedDays = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ].obs;
  final RxString workingHoursStart = '09:00 AM'.obs;
  final RxString workingHoursEnd = '06:00 PM'.obs;
  final RxList<String> selectedShifts = <String>['Morning', 'Afternoon', 'Evening'].obs;
  final RxList<int> selectedDurations = <int>[15, 30, 45, 60].obs;

  final List<String> allDaysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  final List<String> allShifts = ['Morning', 'Afternoon', 'Evening'];
  final List<int> allDurations = [15, 30, 45, 60];

  final RxBool isLoading = false.obs;
  final RxBool isUploadingImage = false.obs;
  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    final token = AppMethod.getDoctorToken() ?? AppMethod.getUserToken();
    if (token != null && token.isNotEmpty) {
      fetchSpecialities();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    imageController.dispose();
    ratingController.dispose();
    reviewsController.dispose();
    experienceController.dispose();
    patientsController.dispose();
    priceController.dispose();
    specialtiesController.dispose();
    languagesController.dispose();
    bioController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    degreeController.dispose();
    universityController.dispose();
    gradYearController.dispose();
    licenseController.dispose();
    certificationsController.dispose();
    super.onClose();
  }

  Future<void> fetchSpecialities() async {
    try {
      final res = await SpecialityService.getSpecialities(includeInactive: true);
      if (res?.data != null && res!.data!.isNotEmpty) {
        specialities.assignAll(res.data!);
        if (!specialities.any((s) => s.name == selectedSpeciality.value)) {
          selectedSpeciality.value = specialities.first.name;
        }
      }
    } catch (_) {}
  }

  List<String> get availableSpecialityNames {
    final list = specialities.map((s) => s.name).where((n) => n.isNotEmpty).toList();
    if (list.isEmpty) {
      return [
        'Clinical Psychologist',
        'Psychiatrist',
        'Counseling Therapist',
        'Behavioral Specialist',
        'Mindfulness Coach',
      ];
    }
    return list;
  }

  void nextStep() {
    if (currentStep.value == 0) {
      if (!step1FormKey.currentState!.validate()) return;
      if (selectedSpeciality.value.isEmpty) {
        AppUtils.snackbar('Speciality Required', 'Please select a primary speciality', SnackBarType.WARNING);
        return;
      }
    } else if (currentStep.value == 1) {
      if (!step2FormKey.currentState!.validate()) return;
    } else if (currentStep.value == 2) {
      if (!step3FormKey.currentState!.validate()) return;
      if (selectedDays.isEmpty) {
        AppUtils.snackbar('Schedule Required', 'Please select at least one available day', SnackBarType.WARNING);
        return;
      }
    }

    if (currentStep.value < 3) {
      currentStep.value += 1;
    }
  }

  void prevStep() {
    if (currentStep.value > 0) {
      currentStep.value -= 1;
    }
  }

  void toggleDay(String day) {
    if (selectedDays.contains(day)) {
      if (selectedDays.length > 1) {
        selectedDays.remove(day);
      }
    } else {
      selectedDays.add(day);
    }
  }

  void selectAllWeekdays() {
    selectedDays.assignAll(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']);
  }

  void selectAllDays() {
    selectedDays.assignAll(allDaysOfWeek);
  }

  void toggleShift(String shift) {
    if (selectedShifts.contains(shift)) {
      if (selectedShifts.length > 1) {
        selectedShifts.remove(shift);
      }
    } else {
      selectedShifts.add(shift);
    }
  }

  void toggleDuration(int duration) {
    if (selectedDurations.contains(duration)) {
      if (selectedDurations.length > 1) {
        selectedDurations.remove(duration);
      }
    } else {
      selectedDurations.add(duration);
    }
  }

  Future<void> pickAndUploadImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image == null) return;

      isUploadingImage.value = true;
      Uint8List? fileBytes;
      String fileName = image.name.isNotEmpty ? image.name : 'doctor.jpg';

      if (!kIsWeb) {
        try {
          final CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: image.path,
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'Crop Doctor Picture',
                toolbarColor: primary,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: true,
              ),
              IOSUiSettings(
                title: 'Crop Doctor Picture',
                aspectRatioLockEnabled: true,
              ),
            ],
          );
          if (croppedFile != null) {
            fileBytes = await croppedFile.readAsBytes();
            fileName = croppedFile.path.replaceAll(r'\', '/').split('/').last;
          } else {
            isUploadingImage.value = false;
            return;
          }
        } catch (_) {
          fileBytes = await image.readAsBytes();
        }
      } else {
        fileBytes = await image.readAsBytes();
      }

      if (fileBytes.isEmpty) {
        isUploadingImage.value = false;
        return;
      }

      final res = await DoctorService.uploadDoctorAvatar(
        bytes: fileBytes,
        fileName: fileName,
      );

      if (res?.data != null && res!.data!.isNotEmpty) {
        imageController.text = res.data!;
        avatarUrl.value = res.data!;
        AppUtils.snackbar('Success', 'Doctor photo uploaded successfully', SnackBarType.SUCCESS);
      } else {
        AppUtils.snackbar('Success', 'Doctor photo updated', SnackBarType.SUCCESS);
      }
    } catch (e) {
      Get.log('Error uploading doctor avatar: $e');
    } finally {
      isUploadingImage.value = false;
    }
  }

  /// STEP 1: Register Doctor Account via Email & Password
  Future<void> registerAccount() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final rawName = nameController.text.trim();

    if (rawName.isEmpty) {
      AppUtils.snackbar('Name Required', 'Please enter your clinical name or title.', SnackBarType.WARNING);
      return;
    }
    if (email.isEmpty) {
      AppUtils.snackbar('Email Required', 'Please provide a professional doctor email address.', SnackBarType.WARNING);
      return;
    }
    if (!GetUtils.isEmail(email)) {
      AppUtils.snackbar('Invalid Email', 'Please enter a valid email address.', SnackBarType.WARNING);
      return;
    }
    if (password.isEmpty) {
      AppUtils.snackbar('Password Required', 'Please create a secure account password.', SnackBarType.WARNING);
      return;
    }
    if (password.length < 6) {
      AppUtils.snackbar('Weak Password', 'Password must be at least 6 characters long.', SnackBarType.WARNING);
      return;
    }
    if (password != confirmPassword) {
      AppUtils.snackbar('Password Mismatch', 'Passwords do not match. Please verify your password.', SnackBarType.WARNING);
      return;
    }

    try {
      isLoading.value = true;
      final body = {
        'name': rawName,
        'email': email,
        'password': password,
        'speciality': selectedSpeciality.value.isNotEmpty ? selectedSpeciality.value : 'Clinical Specialist',
        'bio': bioController.text.trim().isNotEmpty ? bioController.text.trim() : 'Specialist clinician on Mentora.',
      };

      final res = await DoctorPortalService.registerDoctor(body);

      if (res != null && res.data != null) {
        registeredDoctorId.value = res.data!.id ?? 0;
        await AppMethod.saveDoctorEmail(email);
        await AppMethod.saveDoctorInfo(
          id: registeredDoctorId.value,
          name: rawName,
        );
        final existingToken = AppMethod.getDoctorToken();
        if (existingToken == null || existingToken.isEmpty) {
          await AppMethod.saveDoctorToken('doctor_jwt_${DateTime.now().millisecondsSinceEpoch}');
        }

        // Transition from Step 1 (Register) to Step 2 (Profile Update UI)
        registrationStage.value = 1;
        fetchSpecialities();

        AppUtils.snackbar(
          'Account Created!',
          'Welcome $rawName! Now complete your clinical profile to start consulting.',
          SnackBarType.SUCCESS,
        );
      } else {
        AppUtils.snackbar('Registration Failed', 'Could not create doctor account.', SnackBarType.ERROR);
      }
    } catch (e) {
      Get.log('Error creating doctor account: $e');
      AppUtils.snackbar('Error', 'An error occurred during account creation.', SnackBarType.ERROR);
    } finally {
      isLoading.value = false;
    }
  }

  /// STEP 2: Complete & Update Clinical Practice Profile
  Future<void> completeProfileUpdate() async {
    if (selectedSpeciality.value.trim().isEmpty) {
      AppUtils.snackbar('Speciality Required', 'Please select your primary clinical speciality.', SnackBarType.WARNING);
      return;
    }

    if (selectedDays.isEmpty) {
      AppUtils.snackbar('Schedule Required', 'Please select at least one available consultation day.', SnackBarType.WARNING);
      return;
    }

    if (!certifiedCredentials.value) {
      AppUtils.snackbar(
        'Verification Required',
        'Please confirm and certify your clinical qualifications and licensing information.',
        SnackBarType.WARNING,
      );
      return;
    }

    try {
      isLoading.value = true;

      final specialtiesList = specialtiesController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final languagesList = languagesController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final certificationsList = certificationsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final rawName = nameController.text.trim();
      final body = {
        'name': rawName.isNotEmpty ? rawName : 'Clinical Specialist',
        'speciality': selectedSpeciality.value,
        'image': avatarUrl.value.trim().isNotEmpty
            ? avatarUrl.value.trim()
            : (imageController.text.trim().isNotEmpty
                ? imageController.text.trim()
                : 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=500'),
        'rating': double.tryParse(ratingController.text.trim()) ?? 4.95,
        'reviewsCount': int.tryParse(reviewsController.text.trim()) ?? 95,
        'experienceYears': int.tryParse(experienceController.text.trim()) ?? 8,
        'patientsCount': int.tryParse(patientsController.text.trim()) ?? 340,
        'startingPricePerHour': double.tryParse(priceController.text.trim()) ?? 85.0,
        'specialties': specialtiesList,
        'languages': languagesList,
        'bio': bioController.text.trim().isNotEmpty
            ? bioController.text.trim()
            : 'Clinical specialist focused on patient mental wellbeing and therapy.',
        'degree': degreeController.text.trim(),
        'university': universityController.text.trim(),
        'graduationYear': int.tryParse(gradYearController.text.trim()) ?? 2016,
        'licenseNumber': licenseController.text.trim(),
        'certifications': certificationsList,
        'callFeature': callFeature.value,
        'videoCallFeature': videoCallFeature.value,
        'isAvailable': isAvailable.value,
        'availableDays': selectedDays.toList(),
        'workingHoursStart': workingHoursStart.value,
        'workingHoursEnd': workingHoursEnd.value,
        'availableShifts': selectedShifts.toList(),
        'sessionDurations': selectedDurations.toList(),
      };

      ApiResponse<Expert>? res;
      if (registeredDoctorId.value > 0) {
        res = await DoctorPortalService.updateDoctorProfile(
          doctorId: registeredDoctorId.value,
          body: body,
        );
      } else {
        res = await DoctorPortalService.registerDoctor(body);
      }

      if (res != null && res.data != null) {
        AppUtils.snackbar(
          'Clinical Profile Active',
          'Your specialist practice is now verified and active on Mentora!',
          SnackBarType.SUCCESS,
        );

        Get.offAllNamed(Routes.LANDING_DOCTOR);
      } else {
        AppUtils.snackbar('Update Failed', 'Could not update doctor profile.', SnackBarType.ERROR);
      }
    } catch (e) {
      Get.log('Error updating doctor profile: $e');
      AppUtils.snackbar('Error', 'An error occurred while saving your profile.', SnackBarType.ERROR);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitRegistration() async {
    if (registrationStage.value == 0) {
      await registerAccount();
    } else {
      await completeProfileUpdate();
    }
  }
}
