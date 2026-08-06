import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/fields/custom_textfield.widget.dart';
import 'package:Mentora/widgets/fields/custom_dropdownfield.widget.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_icons/icons.dart';
import 'package:Mentora/widgets/others/custom.avatar.dart';

import 'package:Mentora/widgets/bottomsheets/change_profile_picture.bottomsheet.dart';
import '../controllers/edit_account.controller.dart';

class EditAccountScreen extends GetView<EditAccountController> {
  EditAccountScreen({super.key});

  @override
  final controller = Get.put(EditAccountController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        appBar: buildAppbar(context),
        body: buildBody(context),
        bottomNavigationBar: Obx(() {
          final isLoading = controller.globalController.isLoadingProfile.value;
          return Container(
            color: Theme.of(context).primaryColorLight,
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s16.value,
              vertical: Spacing.s16.value,
            ),
            child: buildSaveButton(context, isLoading),
          );
        }),
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: const Center(child: CustomBackButton(icon: MyIcons.chevronLeft)),
      title: Text(
        "Edit Profile",
        style: h2.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s16.value,
        vertical: Spacing.s24.value,
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAvatarPreview(context),
            Spacing.s32.h,
            _buildSectionHeader("PERSONAL DETAILS"),
            buildPersonalDetailsCard(context),
            Spacing.s24.h,
            _buildSectionHeader("CONTACT INFORMATION"),
            buildContactInformationCard(context),
            Spacing.s24.h,
            _buildSectionHeader("PHYSICAL METRICS"),
            buildPhysicalMetricsCard(context),
          ],
        ),
      ),
    );
  }

  Widget buildAvatarPreview(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primary, width: 2),
            ),
            child: Obx(() {
              final pictureUrl = controller.pictureUrl.value;
              final isUploading = controller.isUploadingPicture.value;
              return Stack(
                alignment: Alignment.center,
                children: [
                  CustomAvatar(
                    radius: 54.r,
                    imageUrl: pictureUrl,
                    name: controller.nameController.text,
                  ),
                  if (isUploading)
                    Container(
                      width: 108.r,
                      height: 108.r,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                ],
              );
            }),
          ),
          Obx(() {
            final isUploading = controller.isUploadingPicture.value;
            return GestureDetector(
              onTap: isUploading ? null : () => _showAvatarEditSheet(context),
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? slate[900]! : Colors.white,
                    width: 2,
                  ),
                ),
                child: Text(
                  '\u{f030}', // camera
                  style: TextStyle(
                    fontFamily: 'FontAwesomeSolid',
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buildPersonalDetailsCard(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomPrimaryCard(
      padding: EdgeInsets.all(Spacing.s16.value),
      child: Column(
        children: [
          CustomTextFormField(
            controller: controller.nameController,
            labelText: "Full Name",
            hintText: "Enter your name",
            borderColor: isDark ? slate[800] : slate[200],
            borderWidth: 1,
            focusedBorderColor: primary,
            prefixIcon: _buildFieldIcon("\u{f007}"), // user
            validator: (val) =>
                val == null || val.isEmpty ? "Name cannot be empty" : null,
          ),
          Spacing.s16.h,
          Obx(() {
            final currentGender = controller.selectedGender.value;
            final Map<String, String> genderLabels = {
              "MALE": "Male",
              "FEMALE": "Female",
              "OTHER": "Other",
            };
            return CustomDropdownField<String>(
              value: genderLabels.containsKey(currentGender)
                  ? currentGender
                  : null,
              labelText: "Gender",
              hintText: "Select Gender",
              borderColor: isDark ? slate[800] : slate[200],
              borderWidth: 1,
              focusedBorderColor: primary,
              prefixIcon: _buildFieldIcon("\u{f228}"), // genderless
              items: const [
                DropdownMenuItem(value: "MALE", child: Text("Male")),
                DropdownMenuItem(value: "FEMALE", child: Text("Female")),
                DropdownMenuItem(value: "OTHER", child: Text("Other")),
              ],
              onChanged: (val) {
                if (val != null) {
                  controller.updateGender(val);
                }
              },
            );
          }),
          Spacing.s16.h,
          CustomTextFormField(
            controller: controller.ageController,
            labelText: "Age",
            hintText: "Enter age",
            keyboardType: TextInputType.number,
            borderColor: isDark ? slate[800] : slate[200],
            borderWidth: 1,
            focusedBorderColor: primary,
            prefixIcon: _buildFieldIcon("\u{f1fd}"), // birthday-cake
            validator: controller.validateAge,
          ),
        ],
      ),
    );
  }

  Widget buildContactInformationCard(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomPrimaryCard(
      padding: EdgeInsets.all(Spacing.s16.value),
      child: Column(
        children: [
          CustomTextFormField(
            controller: controller.phoneController,
            labelText: "Phone Number",
            hintText: "Enter phone number",
            keyboardType: TextInputType.phone,
            borderColor: isDark ? slate[800] : slate[200],
            borderWidth: 1,
            focusedBorderColor: primary,
            prefixIcon: _buildFieldIcon("\u{f095}"), // phone
          ),
          Spacing.s16.h,
          CustomTextFormField(
            controller: controller.emailController,
            labelText: "Email Address",
            hintText: "Enter contact email",
            keyboardType: TextInputType.emailAddress,
            borderColor: isDark ? slate[800] : slate[200],
            borderWidth: 1,
            focusedBorderColor: primary,
            enabled: false,
            prefixIcon: _buildFieldIcon("\u{f0e0}", enabled: false),
          ),
          Spacing.s16.h,
          CustomTextFormField(
            controller: controller.addressController,
            labelText: "Address",
            hintText: "Enter home address",
            borderColor: isDark ? slate[800] : slate[200],
            borderWidth: 1,
            focusedBorderColor: primary,
            prefixIcon: _buildFieldIcon("\u{f3c5}"), // map-marker-alt
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget buildPhysicalMetricsCard(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomPrimaryCard(
      padding: EdgeInsets.all(Spacing.s16.value),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              controller: controller.heightController,
              labelText: "Height",
              hintText: "Height",
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              borderColor: isDark ? slate[800] : slate[200],
              borderWidth: 1,
              focusedBorderColor: primary,
              prefixIcon: _buildFieldIcon("\u{f545}"), // ruler-vertical
              validator: (val) => controller.validateDouble(val, "height"),
            ),
          ),
          Spacing.s16.w,
          Expanded(
            child: CustomTextFormField(
              controller: controller.weightController,
              labelText: "Weight",
              hintText: "Weight",
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              borderColor: isDark ? slate[800] : slate[200],
              borderWidth: 1,
              focusedBorderColor: primary,
              prefixIcon: _buildFieldIcon("\u{f496}"), // weight
              validator: (val) => controller.validateDouble(val, "weight"),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSaveButton(BuildContext context, bool isLoading) {
    return CustomPrimaryButton(
      text: "Save Changes",
      isLoading: isLoading,
      onPressed: controller.saveChanges,
      width: double.infinity,
    );
  }

  void _showAvatarEditSheet(BuildContext context) {
    final hasPhoto = controller.pictureUrl.value.isNotEmpty;

    Get.bottomSheet(
      ChangeProfilePictureBottomsheet(
        onTakePhoto: () => controller.pickAndUploadImage(ImageSource.camera),
        onChooseFromGallery: () =>
            controller.pickAndUploadImage(ImageSource.gallery),
        showRemoveOption: hasPhoto,
        onRemovePhoto: () => controller.deleteCurrentPicture(),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildFieldIcon(String iconCode, {bool enabled = true}) {
    return Container(
      width: 20,
      padding: const EdgeInsets.only(left: 8),
      child: Center(
        child: Text(
          iconCode,
          style: TextStyle(
            fontFamily: 'FontAwesomeLight',
            fontSize: 16.sp,
            color: enabled ? primary : slate[400],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: Spacing.s8.value,
        left: Spacing.s4.value,
      ),
      child: Text(
        title,
        style: r14.copyWith(color: primary, fontWeight: FontWeight.bold),
      ),
    );
  }
}
