import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/fields/custom_textfield.widget.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_icons/icons.dart';

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
              return CircleAvatar(
                radius: 54.r,
                backgroundImage: pictureUrl.isNotEmpty
                    ? NetworkImage(pictureUrl)
                    : const NetworkImage(
                            "https://austinfilm.s3.us-east-2.amazonaws.com/wp-content/uploads/2019/07/29115643/john-doe-jim-herrington-cropped-1024x675.jpg",
                          )
                          as ImageProvider,
              );
            }),
          ),
          GestureDetector(
            onTap: () => _showAvatarEditSheet(context),
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
          ),
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
          CustomTextFormField(
            controller: controller.genderController,
            labelText: "Gender",
            hintText: "Enter gender (e.g. Male, Female)",
            borderColor: isDark ? slate[800] : slate[200],
            borderWidth: 1,
            focusedBorderColor: primary,
            prefixIcon: _buildFieldIcon("\u{f228}"), // genderless
          ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tempController = TextEditingController(
      text: controller.pictureController.text,
    );

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(Spacing.s20.value),
        decoration: BoxDecoration(
          color: isDark ? slate[900] : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          border: Border(
            top: BorderSide(
              color: isDark ? slate[800]! : slate[100]!,
              width: 1,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Update Profile Picture",
                style: r16.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacing.s8.h,
              Text(
                "Enter a web link (URL) of the image you want to use as your avatar.",
                style: r12.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              Spacing.s16.h,
              CustomTextFormField(
                controller: tempController,
                labelText: "Image URL",
                hintText: "https://example.com/image.png",
                borderColor: isDark ? slate[700] : slate[200],
                borderWidth: 1,
                focusedBorderColor: primary,
                prefixIcon: Container(
                  width: 20,
                  padding: const EdgeInsets.only(left: 8),
                  child: Center(
                    child: Text(
                      "\u{f0c1}", // link
                      style: TextStyle(
                        fontFamily: 'FontAwesomeLight',
                        fontSize: 16.sp,
                        color: primary,
                      ),
                    ),
                  ),
                ),
              ),
              Spacing.s24.h,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? white : slate[800],
                        side: BorderSide(
                          color: isDark ? slate[700]! : slate[200]!,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: Text(
                        "Cancel",
                        style: r14.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Spacing.s16.w,
                  Expanded(
                    child: CustomPrimaryButton(
                      text: "Apply",
                      onPressed: () {
                        controller.updatePictureUrl(tempController.text.trim());
                        Get.back();
                      },
                      height: 48.h,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
