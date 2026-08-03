import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/controllers/global.controller.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/fields/custom_textfield.widget.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_icons/icons.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
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

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final profile = globalController.userProfile.value;
    nameController = TextEditingController(text: profile?.name);
    genderController = TextEditingController(text: profile?.gender);
    ageController = TextEditingController(text: profile?.age?.toString());
    phoneController = TextEditingController(text: profile?.phoneNumber);
    emailController = TextEditingController(text: profile?.email);
    addressController = TextEditingController(text: profile?.address);
    heightController = TextEditingController(text: profile?.height?.toString());
    weightController = TextEditingController(text: profile?.weight?.toString());
    pictureController = TextEditingController(text: profile?.profilePictureUrl);
  }

  @override
  void dispose() {
    nameController.dispose();
    genderController.dispose();
    ageController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    heightController.dispose();
    weightController.dispose();
    pictureController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await globalController.updateUserProfile(
      name: nameController.text.trim(),
      gender: genderController.text.trim(),
      age: int.tryParse(ageController.text.trim()),
      phoneNumber: phoneController.text.trim(),
      email: emailController.text.trim(),
      address: addressController.text.trim(),
      height: double.tryParse(heightController.text.trim()),
      weight: double.tryParse(weightController.text.trim()),
      profilePictureUrl: pictureController.text.trim(),
    );

    if (success) {
      Get.back();
      Get.snackbar(
        "Success",
        "Profile updated successfully",
        backgroundColor: primary.withValues(alpha: 0.15),
        colorText: Get.theme.textTheme.bodyLarge?.color,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Error",
        "Failed to update profile",
        backgroundColor: Colors.red.withValues(alpha: 0.15),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Center(
          child: CustomBackButton(icon: MyIcons.chevronLeft),
        ),
        title: Text(
          "Edit Profile",
          style: r18.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final isLoading = globalController.isLoadingProfile.value;

        return SingleChildScrollView(
          padding: EdgeInsets.all(Spacing.s16.value),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Avatar preview
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primary, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundImage: pictureController.text.isNotEmpty
                          ? NetworkImage(pictureController.text)
                          : const NetworkImage(
                                  "https://austinfilm.s3.us-east-2.amazonaws.com/wp-content/uploads/2019/07/29115643/john-doe-jim-herrington-cropped-1024x675.jpg",
                                )
                                as ImageProvider,
                    ),
                  ),
                ),
                Spacing.s24.h,

                CustomTextFormField(
                  controller: pictureController,
                  labelText: "Profile Picture URL",
                  hintText: "Enter picture link",
                  borderColor: isDark ? slate[700] : slate[200],
                  borderWidth: 1,
                  focusedBorderColor: primary,
                  onChanged: (val) {
                    setState(() {}); // refresh local avatar review
                  },
                ),
                Spacing.s16.h,

                CustomTextFormField(
                  controller: nameController,
                  labelText: "Full Name",
                  hintText: "Enter your name",
                  borderColor: isDark ? slate[700] : slate[200],
                  borderWidth: 1,
                  focusedBorderColor: primary,
                  validator: (val) => val == null || val.isEmpty
                      ? "Name cannot be empty"
                      : null,
                ),
                Spacing.s16.h,

                CustomTextFormField(
                  controller: genderController,
                  labelText: "Gender",
                  hintText: "Enter gender (e.g. Male, Female)",
                  borderColor: isDark ? slate[700] : slate[200],
                  borderWidth: 1,
                  focusedBorderColor: primary,
                ),
                Spacing.s16.h,

                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: ageController,
                        labelText: "Age",
                        hintText: "Enter age",
                        keyboardType: TextInputType.number,
                        borderColor: isDark ? slate[700] : slate[200],
                        borderWidth: 1,
                        focusedBorderColor: primary,
                      ),
                    ),
                    Spacing.s16.w,
                    Expanded(
                      child: CustomTextFormField(
                        controller: phoneController,
                        labelText: "Phone Number",
                        hintText: "Enter phone",
                        keyboardType: TextInputType.phone,
                        borderColor: isDark ? slate[700] : slate[200],
                        borderWidth: 1,
                        focusedBorderColor: primary,
                      ),
                    ),
                  ],
                ),
                Spacing.s16.h,

                CustomTextFormField(
                  controller: emailController,
                  labelText: "Alternative Email",
                  hintText: "Enter email",
                  keyboardType: TextInputType.emailAddress,
                  borderColor: isDark ? slate[700] : slate[200],
                  borderWidth: 1,
                  focusedBorderColor: primary,
                ),
                Spacing.s16.h,

                CustomTextFormField(
                  controller: addressController,
                  labelText: "Address",
                  hintText: "Enter home address",
                  borderColor: isDark ? slate[700] : slate[200],
                  borderWidth: 1,
                  focusedBorderColor: primary,
                ),
                Spacing.s16.h,

                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: heightController,
                        labelText: "Height (cm)",
                        hintText: "Enter height",
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        borderColor: isDark ? slate[700] : slate[200],
                        borderWidth: 1,
                        focusedBorderColor: primary,
                      ),
                    ),
                    Spacing.s16.w,
                    Expanded(
                      child: CustomTextFormField(
                        controller: weightController,
                        labelText: "Weight (kg)",
                        hintText: "Enter weight",
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        borderColor: isDark ? slate[700] : slate[200],
                        borderWidth: 1,
                        focusedBorderColor: primary,
                      ),
                    ),
                  ],
                ),
                Spacing.s32.h,

                CustomPrimaryButton(
                  text: "Save Changes",
                  isLoading: isLoading,
                  onPressed: _saveChanges,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
