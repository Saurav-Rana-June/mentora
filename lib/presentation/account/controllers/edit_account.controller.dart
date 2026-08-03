import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:Mentora/controllers/global.controller.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/utils/app_utils.dart';

class EditAccountController extends GetxController {
  final globalController = Get.find<GlobalController>();

  late final TextEditingController nameController;
  late final TextEditingController genderController;
  late final TextEditingController ageController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController addressController;
  late final TextEditingController heightController;
  late final TextEditingController weightController;
  late final TextEditingController pictureController;

  final RxString pictureUrl = "".obs;
  final RxBool isUploadingPicture = false.obs;
  final ImagePicker _picker = ImagePicker();

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    final profile = globalController.userProfile.value;
    nameController = TextEditingController(text: profile?.name);
    genderController = TextEditingController(text: profile?.gender);
    ageController = TextEditingController(text: profile?.age?.toString());
    phoneController = TextEditingController(text: profile?.phoneNumber);
    emailController = TextEditingController(text: profile?.email);
    addressController = TextEditingController(text: profile?.address);
    heightController = TextEditingController(text: profile?.height?.toString());
    weightController = TextEditingController(text: profile?.weight?.toString());

    pictureUrl.value = profile?.profilePictureUrl ?? "";
    pictureController = TextEditingController(text: pictureUrl.value);
  }

  @override
  void onClose() {
    nameController.dispose();
    genderController.dispose();
    ageController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    heightController.dispose();
    weightController.dispose();
    pictureController.dispose();
    super.onClose();
  }

  void updatePictureUrl(String newUrl) {
    pictureUrl.value = newUrl;
    pictureController.text = newUrl;
  }

  String? validateAge(String? val) {
    if (val == null || val.isEmpty) return null;
    final age = int.tryParse(val.trim());
    if (age == null || age < 0 || age > 150) {
      return "Please enter a valid age (0-150)";
    }
    return null;
  }

  String? validateDouble(String? val, String fieldName) {
    if (val == null || val.isEmpty) return null;
    final numVal = double.tryParse(val.trim());
    if (numVal == null || numVal < 0) {
      return "Please enter a valid $fieldName";
    }
    return null;
  }

  Future<void> saveChanges() async {
    if (!formKey.currentState!.validate()) return;

    final success = await globalController.updateUserProfile(
      name: nameController.text.trim(),
      gender: genderController.text.trim(),
      age: int.tryParse(ageController.text.trim()),
      phoneNumber: phoneController.text.trim(),
      email: emailController.text.trim(),
      address: addressController.text.trim(),
      height: double.tryParse(heightController.text.trim()),
      weight: double.tryParse(weightController.text.trim()),
    );

    if (success) {
      Get.back();
      AppUtils.snackbar(
        "Success",
        "Profile updated successfully",
        SnackBarType.SUCCESS,
      );
    } else {
      AppUtils.snackbar(
        "Error",
        "Failed to update profile",
        SnackBarType.ERROR,
      );
    }
  }

  Future<void> pickAndUploadImage(ImageSource source) async {
    try {
      Get.log("pickAndUploadImage: picking image from source=$source");
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      Get.log("pickAndUploadImage: picked image path: ${image?.path}");
      if (image == null) return;

      Get.log("pickAndUploadImage: opening cropper for path: ${image.path}");
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Picture',
            toolbarColor: primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            aspectRatioPresets: [CropAspectRatioPreset.square],
          ),
          IOSUiSettings(
            title: 'Crop Profile Picture',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPresets: [CropAspectRatioPreset.square],
          ),
        ],
      );
      Get.log("pickAndUploadImage: cropped file path: ${croppedFile?.path}");
      if (croppedFile == null) return;

      isUploadingPicture.value = true;

      final String fileName = croppedFile.path.split('/').last;
      Get.log(
        "pickAndUploadImage: uploading fileName=$fileName path=${croppedFile.path}",
      );

      final success = await globalController.uploadProfilePicture(
        croppedFile.path,
        fileName,
      );
      Get.log("pickAndUploadImage: upload finished with success=$success");

      if (success) {
        final newUrl =
            globalController.userProfile.value?.profilePictureUrl ?? "";
        pictureUrl.value = newUrl;
        pictureController.text = newUrl;

        AppUtils.snackbar(
          "Success",
          "Profile picture updated successfully",
          SnackBarType.SUCCESS,
        );
      } else {
        AppUtils.snackbar(
          "Error",
          "Failed to upload image",
          SnackBarType.ERROR,
        );
      }
    } catch (e) {
      Get.log("Error in pickAndUploadImage: $e");
      AppUtils.snackbar(
        "Error",
        "Failed to pick or upload image",
        SnackBarType.ERROR,
      );
    } finally {
      isUploadingPicture.value = false;
    }
  }

  Future<void> deleteCurrentPicture() async {
    try {
      isUploadingPicture.value = true;
      final success = await globalController.deleteProfilePicture();
      if (success) {
        pictureUrl.value = "";
        pictureController.text = "";

        AppUtils.snackbar(
          "Success",
          "Profile picture removed successfully",
          SnackBarType.SUCCESS,
        );
      } else {
        AppUtils.snackbar(
          "Error",
          "Failed to remove profile picture",
          SnackBarType.ERROR,
        );
      }
    } catch (e) {
      Get.log("Error in deleteCurrentPicture: $e");
    } finally {
      isUploadingPicture.value = false;
    }
  }
}
