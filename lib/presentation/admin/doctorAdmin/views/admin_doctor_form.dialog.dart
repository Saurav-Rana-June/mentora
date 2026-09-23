import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/model/expert.model.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/bottomsheets/change_profile_picture.bottomsheet.dart';
import 'package:Mentora/widgets/others/custom.avatar.dart';
import '../controllers/admin_doctor.controller.dart';

class AdminDoctorFormDialog extends StatefulWidget {
  final Expert? doctor;

  const AdminDoctorFormDialog({super.key, this.doctor});

  static Future<bool?> show({
    required BuildContext context,
    Expert? doctor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AdminDoctorFormDialog(doctor: doctor),
    );
  }

  @override
  State<AdminDoctorFormDialog> createState() => _AdminDoctorFormDialogState();
}

class _AdminDoctorFormDialogState extends State<AdminDoctorFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<AdminDoctorController>();

  late final TextEditingController _nameController;
  late final TextEditingController _specialityController;
  late final TextEditingController _imageController;
  late final TextEditingController _ratingController;
  late final TextEditingController _reviewsController;
  late final TextEditingController _experienceController;
  late final TextEditingController _patientsController;
  late final TextEditingController _priceController;
  late final TextEditingController _specialtiesController;
  late final TextEditingController _bioController;

  bool _callFeature = true;
  bool _videoCallFeature = true;
  bool _isAvailable = true;
  bool _isLoading = false;
  bool _isUploadingImage = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final d = widget.doctor;
    _nameController = TextEditingController(text: d?.name ?? '');
    _specialityController = TextEditingController(text: d?.speciality ?? 'Clinical Psychologist');
    _imageController = TextEditingController(
      text: d?.image ?? 'https://randomuser.me/api/portraits/men/32.jpg',
    );
    _ratingController = TextEditingController(text: (d?.rating ?? 4.9).toString());
    _reviewsController = TextEditingController(text: (d?.reviewsCount ?? 120).toString());
    _experienceController = TextEditingController(text: (d?.experienceYears ?? 8).toString());
    _patientsController = TextEditingController(text: (d?.patientsCount ?? 500).toString());
    _priceController = TextEditingController(text: (d?.startingPricePerHour ?? 25.0).toString());
    _specialtiesController = TextEditingController(
      text: (d?.specialties ?? ['Anxiety & Stress', 'Mindfulness']).join(', '),
    );
    _bioController = TextEditingController(
      text: d?.bio ??
          'Highly dedicated mental health professional specialized in supporting emotional resilience and wellbeing.',
    );
    _callFeature = d?.callFeature ?? true;
    _videoCallFeature = d?.videoCallFeature ?? true;
    _isAvailable = d?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialityController.dispose();
    _imageController.dispose();
    _ratingController.dispose();
    _reviewsController.dispose();
    _experienceController.dispose();
    _patientsController.dispose();
    _priceController.dispose();
    _specialtiesController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image == null) return;

      if (mounted) setState(() => _isUploadingImage = true);

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
                aspectRatioPresets: [CropAspectRatioPreset.square],
              ),
              IOSUiSettings(
                title: 'Crop Doctor Picture',
                aspectRatioLockEnabled: true,
                resetAspectRatioEnabled: false,
                aspectRatioPresets: [CropAspectRatioPreset.square],
              ),
            ],
          );
          if (croppedFile != null) {
            fileBytes = await croppedFile.readAsBytes();
            fileName = croppedFile.path.replaceAll(r'\', '/').split('/').last;
          } else {
            if (mounted) setState(() => _isUploadingImage = false);
            return;
          }
        } catch (cropErr) {
          Get.log('Cropper skipped/failed: $cropErr');
          fileBytes = await image.readAsBytes();
        }
      } else {
        fileBytes = await image.readAsBytes();
      }

      if (fileBytes.isEmpty) {
        if (mounted) setState(() => _isUploadingImage = false);
        return;
      }

      final uploadedUrl = await _controller.uploadAvatar(
        bytes: fileBytes,
        fileName: fileName,
      );

      if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
        if (mounted) {
          setState(() {
            _imageController.text = uploadedUrl;
          });
        }
        AppUtils.snackbar(
          'Success',
          'Doctor profile photo uploaded',
          SnackBarType.SUCCESS,
        );
      } else {
        AppUtils.snackbar(
          'Error',
          'Failed to upload doctor photo',
          SnackBarType.ERROR,
        );
      }
    } catch (e) {
      Get.log('Error in _pickAndUploadImage: $e');
      AppUtils.snackbar(
        'Error',
        'Failed to pick or upload image',
        SnackBarType.ERROR,
      );
    } finally {
      if (mounted) {
        setState(() => _isUploadingImage = false);
      }
    }
  }

  void _deleteImage() {
    setState(() {
      _imageController.text = '';
    });
    AppUtils.snackbar(
      'Success',
      'Doctor photo removed',
      SnackBarType.SUCCESS,
    );
  }

  void _handleAvatarTap(BuildContext context) {
    if (_isUploadingImage) return;

    final hasPhoto = _imageController.text.trim().isNotEmpty;

    if (kIsWeb) {
      if (!hasPhoto) {
        _pickAndUploadImage(source: ImageSource.gallery);
      } else {
        _showWebPhotoOptions(context);
      }
    } else {
      Get.bottomSheet(
        ChangeProfilePictureBottomsheet(
          onTakePhoto: () => _pickAndUploadImage(source: ImageSource.camera),
          onChooseFromGallery: () =>
              _pickAndUploadImage(source: ImageSource.gallery),
          showRemoveOption: hasPhoto,
          onRemovePhoto: _deleteImage,
        ),
        isScrollControlled: true,
      );
    }
  }

  void _showWebPhotoOptions(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1F1D) : white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          'Doctor Photo',
          style: h3.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.headlineMedium?.color,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library_rounded, color: primary),
              title: Text(
                'Upload New Image',
                style: r14.copyWith(
                  color: theme.textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              onTap: () {
                Navigator.of(dialogCtx).pop();
                _pickAndUploadImage(source: ImageSource.gallery);
              },
            ),
            Spacing.s8.h,
            ListTile(
              leading: Icon(Icons.delete_outline_rounded, color: dangerColor),
              title: Text(
                'Remove Photo',
                style: r14.copyWith(
                  color: dangerColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              onTap: () {
                Navigator.of(dialogCtx).pop();
                _deleteImage();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(
              'Cancel',
              style: r14.copyWith(color: theme.textTheme.bodyMedium?.color),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final specialtiesList = _specialtiesController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final body = {
      'name': _nameController.text.trim(),
      'speciality': _specialityController.text.trim(),
      'image': _imageController.text.trim(),
      'rating': double.tryParse(_ratingController.text.trim()) ?? 5.0,
      'reviewsCount': int.tryParse(_reviewsController.text.trim()) ?? 0,
      'experienceYears': int.tryParse(_experienceController.text.trim()) ?? 1,
      'patientsCount': int.tryParse(_patientsController.text.trim()) ?? 0,
      'startingPricePerHour': double.tryParse(_priceController.text.trim()) ?? 25.0,
      'specialties': specialtiesList,
      'bio': _bioController.text.trim(),
      'callFeature': _callFeature,
      'videoCallFeature': _videoCallFeature,
      'isAvailable': _isAvailable,
    };

    bool success;
    if (widget.doctor != null) {
      success = await _controller.updateDoctor(widget.doctor!.id ?? 0, body);
    } else {
      success = await _controller.createDoctor(body);
    }

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.of(context, rootNavigator: true).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEditing = widget.doctor != null;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E1F1D) : white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: 580.w,
        constraints: BoxConstraints(maxHeight: Get.height * 0.9),
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Edit Doctor Profile' : 'Register Doctor / Expert',
                    style: h3.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.textTheme.headlineLarge?.color,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              Spacing.s16.h,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildAvatarPicker(context),
                      Spacing.s16.h,
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: 'Full Name *',
                              controller: _nameController,
                              hint: 'e.g. Dr. William Butcher',
                              validator: (v) => v == null || v.isEmpty ? 'Name required' : null,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          Spacing.s12.w,
                          Expanded(
                            child: _buildTextField(
                              label: 'Speciality Title *',
                              controller: _specialityController,
                              hint: 'e.g. Clinical Psychologist',
                              validator: (v) => v == null || v.isEmpty ? 'Speciality required' : null,
                            ),
                          ),
                        ],
                      ),
                      Spacing.s12.h,
                      _buildTextField(
                        label: 'Avatar / Profile Image URL *',
                        controller: _imageController,
                        hint: 'https://... or upload photo',
                        validator: (v) => v == null || v.isEmpty ? 'Image URL required' : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.add_photo_alternate_rounded,
                            color: primary,
                            size: 20.spMin,
                          ),
                          tooltip: 'Upload photo from files',
                          onPressed: _isUploadingImage
                              ? null
                              : () => _handleAvatarTap(context),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      Spacing.s12.h,
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: 'Price / Hour (\$) *',
                              controller: _priceController,
                              hint: '25.0',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Spacing.s8.w,
                          Expanded(
                            child: _buildTextField(
                              label: 'Exp. (Years)',
                              controller: _experienceController,
                              hint: '8',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Spacing.s8.w,
                          Expanded(
                            child: _buildTextField(
                              label: 'Rating (0-5)',
                              controller: _ratingController,
                              hint: '4.9',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      Spacing.s12.h,
                      _buildTextField(
                        label: 'Specialties (Comma Separated)',
                        controller: _specialtiesController,
                        hint: 'Anxiety & Stress, CBT, Mindfulness, Trauma',
                      ),
                      Spacing.s12.h,
                      _buildTextField(
                        label: 'Doctor Biography / About',
                        controller: _bioController,
                        hint: 'Doctor qualifications and consultation overview...',
                        maxLines: 3,
                      ),
                      Spacing.s12.h,
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              value: _callFeature,
                              onChanged: (val) => setState(() => _callFeature = val ?? true),
                              title: Text('Voice Call', style: r12.copyWith(fontWeight: FontWeight.w600)),
                              contentPadding: EdgeInsets.zero,
                              activeColor: primary,
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              value: _videoCallFeature,
                              onChanged: (val) => setState(() => _videoCallFeature = val ?? true),
                              title: Text('Video Call', style: r12.copyWith(fontWeight: FontWeight.w600)),
                              contentPadding: EdgeInsets.zero,
                              activeColor: primary,
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              value: _isAvailable,
                              onChanged: (val) => setState(() => _isAvailable = val ?? true),
                              title: Text('Available', style: r12.copyWith(fontWeight: FontWeight.w600)),
                              contentPadding: EdgeInsets.zero,
                              activeColor: successColor,
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Spacing.s20.h,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading || _isUploadingImage
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text('Cancel', style: r14.copyWith(color: theme.textTheme.bodyMedium?.color)),
                  ),
                  Spacing.s12.w,
                  ElevatedButton(
                    onPressed: _isLoading || _isUploadingImage ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            isEditing ? 'Save Changes' : 'Register Doctor',
                            style: r14.copyWith(color: white, fontWeight: FontWeight.w600),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAvatarPicker(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final imageUrl = _imageController.text.trim();

    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primary, width: 2),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomAvatar(
                      radius: 46.r,
                      imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
                      name: _nameController.text.isNotEmpty
                          ? _nameController.text
                          : 'Dr.',
                    ),
                    if (_isUploadingImage)
                      Container(
                        width: 92.r,
                        height: 92.r,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _isUploadingImage ? null : () => _handleAvatarTap(context),
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? const Color(0xFF1E1F1D) : Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add_a_photo_rounded,
                    size: 16.spMin,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Spacing.s8.h,
          Text(
            _isUploadingImage
                ? 'Uploading photo...'
                : (kIsWeb
                    ? 'Click avatar to choose an image from files'
                    : 'Click avatar to upload photo'),
            style: r12.copyWith(
              color: _isUploadingImage ? primary : theme.textTheme.bodySmall?.color,
              fontWeight: _isUploadingImage ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    void Function(String)? onChanged,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: r12.copyWith(fontWeight: FontWeight.w600, color: theme.textTheme.bodyMedium?.color),
        ),
        Spacing.s4.h,
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          style: r14.copyWith(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: r14.copyWith(color: slate[400]),
            filled: true,
            fillColor: isDark ? const Color(0xFF282926) : const Color(0xFFF9FAF7),
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.1) : slate[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
