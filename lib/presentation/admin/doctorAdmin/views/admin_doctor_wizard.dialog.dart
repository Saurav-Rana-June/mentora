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
import 'admin_specialities_dialog.widget.dart';

class AdminDoctorWizardDialog extends StatefulWidget {
  final Expert? doctor;

  const AdminDoctorWizardDialog({super.key, this.doctor});

  static Future<bool?> show({
    required BuildContext context,
    Expert? doctor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AdminDoctorWizardDialog(doctor: doctor),
    );
  }

  @override
  State<AdminDoctorWizardDialog> createState() => _AdminDoctorWizardDialogState();
}

class _AdminDoctorWizardDialogState extends State<AdminDoctorWizardDialog> {
  final _controller = Get.find<AdminDoctorController>();

  int _currentStep = 0;
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();
  final _step3FormKey = GlobalKey<FormState>();

  // --- Step 1: Basic Information ---
  late final TextEditingController _nameController;
  late final TextEditingController _imageController;
  late final TextEditingController _ratingController;
  late final TextEditingController _reviewsController;
  late final TextEditingController _experienceController;
  late final TextEditingController _patientsController;
  late final TextEditingController _priceController;
  late final TextEditingController _specialtiesController;
  late final TextEditingController _languagesController;
  late final TextEditingController _bioController;
  String _selectedSpeciality = '';

  // --- Step 2: Educational & Professional ---
  late final TextEditingController _degreeController;
  late final TextEditingController _universityController;
  late final TextEditingController _gradYearController;
  late final TextEditingController _licenseController;
  late final TextEditingController _certificationsController;

  // --- Step 3: Availability & Schedule ---
  bool _callFeature = true;
  bool _videoCallFeature = true;
  bool _isAvailable = true;
  List<String> _selectedDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  String _workingHoursStart = '09:00 AM';
  String _workingHoursEnd = '06:00 PM';
  List<String> _selectedShifts = ['Morning', 'Afternoon', 'Evening'];
  List<int> _selectedDurations = [15, 30, 45, 60];

  bool _isLoading = false;
  bool _isUploadingImage = false;
  final ImagePicker _picker = ImagePicker();

  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final List<String> _shiftsList = ['Morning', 'Afternoon', 'Evening'];
  final List<int> _durationsList = [15, 30, 45, 60];

  @override
  void initState() {
    super.initState();
    final d = widget.doctor;

    _nameController = TextEditingController(text: d?.name ?? '');
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
    _languagesController = TextEditingController(
      text: (d?.languages ?? ['English', 'Spanish']).join(', '),
    );
    _bioController = TextEditingController(
      text: d?.bio ??
          'Highly dedicated mental health professional specialized in supporting emotional resilience and wellbeing.',
    );
    _selectedSpeciality = d?.speciality ?? (_controller.availableSpecialityNames.isNotEmpty
        ? _controller.availableSpecialityNames.first
        : 'Clinical Psychologist');

    // Step 2
    _degreeController = TextEditingController(text: d?.degree ?? 'Ph.D. in Clinical Psychology');
    _universityController = TextEditingController(text: d?.university ?? 'Stanford University');
    _gradYearController = TextEditingController(text: (d?.graduationYear ?? 2016).toString());
    _licenseController = TextEditingController(text: d?.licenseNumber ?? 'PSY-88219');
    _certificationsController = TextEditingController(
      text: (d?.certifications ?? ['Licensed Clinical Psychologist (LCP)', 'Board Certified in Behavioral Health']).join(', '),
    );

    // Step 3
    _callFeature = d?.callFeature ?? true;
    _videoCallFeature = d?.videoCallFeature ?? true;
    _isAvailable = d?.isAvailable ?? true;
    _selectedDays = List<String>.from(d?.availableDays ?? ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']);
    _workingHoursStart = d?.workingHoursStart ?? '09:00 AM';
    _workingHoursEnd = d?.workingHoursEnd ?? '06:00 PM';
    _selectedShifts = List<String>.from(d?.availableShifts ?? ['Morning', 'Afternoon', 'Evening']);
    _selectedDurations = List<int>.from(d?.sessionDurations ?? [15, 30, 45, 60]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    _ratingController.dispose();
    _reviewsController.dispose();
    _experienceController.dispose();
    _patientsController.dispose();
    _priceController.dispose();
    _specialtiesController.dispose();
    _languagesController.dispose();
    _bioController.dispose();
    _degreeController.dispose();
    _universityController.dispose();
    _gradYearController.dispose();
    _licenseController.dispose();
    _certificationsController.dispose();
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
        AppUtils.snackbar('Success', 'Doctor profile photo uploaded', SnackBarType.SUCCESS);
      } else {
        AppUtils.snackbar('Error', 'Failed to upload doctor photo', SnackBarType.ERROR);
      }
    } catch (e) {
      Get.log('Error in _pickAndUploadImage: $e');
      AppUtils.snackbar('Error', 'Failed to pick or upload image', SnackBarType.ERROR);
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
    AppUtils.snackbar('Success', 'Doctor photo removed', SnackBarType.SUCCESS);
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
          onChooseFromGallery: () => _pickAndUploadImage(source: ImageSource.gallery),
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
        title: Text('Doctor Photo', style: h3.copyWith(fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library_rounded, color: primary),
              title: Text('Upload New Image', style: r14.copyWith(fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.of(dialogCtx).pop();
                _pickAndUploadImage(source: ImageSource.gallery);
              },
            ),
            Spacing.s8.h,
            ListTile(
              leading: Icon(Icons.delete_outline_rounded, color: dangerColor),
              title: Text('Remove Photo', style: r14.copyWith(color: dangerColor, fontWeight: FontWeight.w500)),
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
            child: Text('Cancel', style: r14.copyWith(color: theme.textTheme.bodyMedium?.color)),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (!_step1FormKey.currentState!.validate()) return;
      if (_selectedSpeciality.isEmpty) {
        AppUtils.snackbar('Speciality Required', 'Please select a primary speciality', SnackBarType.WARNING);
        return;
      }
    } else if (_currentStep == 1) {
      if (!_step2FormKey.currentState!.validate()) return;
    }

    if (_currentStep < 2) {
      setState(() => _currentStep += 1);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  Future<void> _submitRegistration() async {
    if (!_step3FormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final specialtiesList = _specialtiesController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final languagesList = _languagesController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final certificationsList = _certificationsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final body = {
      // Step 1: Basic
      'name': _nameController.text.trim(),
      'speciality': _selectedSpeciality,
      'image': _imageController.text.trim(),
      'rating': double.tryParse(_ratingController.text.trim()) ?? 5.0,
      'reviewsCount': int.tryParse(_reviewsController.text.trim()) ?? 0,
      'experienceYears': int.tryParse(_experienceController.text.trim()) ?? 1,
      'patientsCount': int.tryParse(_patientsController.text.trim()) ?? 0,
      'startingPricePerHour': double.tryParse(_priceController.text.trim()) ?? 25.0,
      'specialties': specialtiesList,
      'languages': languagesList,
      'bio': _bioController.text.trim(),

      // Step 2: Educational
      'degree': _degreeController.text.trim(),
      'university': _universityController.text.trim(),
      'graduationYear': int.tryParse(_gradYearController.text.trim()) ?? 2016,
      'licenseNumber': _licenseController.text.trim(),
      'certifications': certificationsList,

      // Step 3: Availability
      'callFeature': _callFeature,
      'videoCallFeature': _videoCallFeature,
      'isAvailable': _isAvailable,
      'availableDays': _selectedDays,
      'workingHoursStart': _workingHoursStart,
      'workingHoursEnd': _workingHoursEnd,
      'availableShifts': _selectedShifts,
      'sessionDurations': _selectedDurations,
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
        width: 680.w,
        constraints: BoxConstraints(maxHeight: Get.height * 0.92),
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing ? 'Edit Doctor Profile' : 'Register Doctor / Expert',
                      style: h3.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.textTheme.headlineLarge?.color,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Multi-part verification & onboarding workflow',
                      style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            Spacing.s16.h,

            // Stepper Navigation Header
            buildStepperHeader(context),
            Spacing.s20.h,

            // Step Content Area
            Expanded(
              child: SingleChildScrollView(
                child: [
                  buildStep1BasicInfo(context),
                  buildStep2EducationalInfo(context),
                  buildStep3AvailabilityInfo(context),
                ][_currentStep],
              ),
            ),
            Spacing.s16.h,

            // Bottom Navigation Actions
            buildBottomActions(context, isEditing),
          ],
        ),
      ),
    );
  }

  // --- STEPPER HEADER ---

  Widget buildStepperHeader(BuildContext context) {
    final steps = [
      {'title': '1. Basic Info', 'icon': Icons.person_rounded},
      {'title': '2. Education', 'icon': Icons.school_rounded},
      {'title': '3. Availability', 'icon': Icons.calendar_month_rounded},
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF282926)
            : const Color(0xFFF6F8F2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final isDone = _currentStep > index;
          final isCurrent = _currentStep == index;

          return Expanded(
            child: InkWell(
              onTap: () {
                if (index < _currentStep) {
                  setState(() => _currentStep = index);
                } else if (index > _currentStep) {
                  _nextStep();
                }
              },
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 26.w,
                      height: 26.w,
                      decoration: BoxDecoration(
                        color: isDone || isCurrent
                            ? primary
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDone || isCurrent ? primary : slate[400]!,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: isDone
                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                            : Text(
                                '${index + 1}',
                                style: r12.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isCurrent ? Colors.white : slate[400],
                                ),
                              ),
                      ),
                    ),
                    Spacing.s8.w,
                    Flexible(
                      child: Text(
                        steps[index]['title'] as String,
                        style: r12.copyWith(
                          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                          color: isCurrent
                              ? Theme.of(context).textTheme.bodyLarge?.color
                              : slate[400],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // --- STEP 1: BASIC INFORMATION ---

  Widget buildStep1BasicInfo(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Form(
      key: _step1FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildAvatarPicker(context),
          Spacing.s16.h,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _buildTextField(
                  label: 'Full Name *',
                  controller: _nameController,
                  hint: 'e.g. Dr. William Butcher',
                  validator: (v) => v == null || v.trim().isEmpty ? 'Name required' : null,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              Spacing.s12.w,
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Primary Speciality *',
                          style: r12.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        InkWell(
                          onTap: () => AdminSpecialitiesDialog.show(context),
                          child: Text(
                            '+ Manage Specialities',
                            style: r10.copyWith(color: primary, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    Spacing.s4.h,
                    Obx(() {
                      final specs = _controller.availableSpecialityNames;
                      if (_selectedSpeciality.isEmpty && specs.isNotEmpty) {
                        _selectedSpeciality = specs.first;
                      }

                      return Container(
                        height: 44.h,
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF282926) : const Color(0xFFF9FAF7),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: specs.contains(_selectedSpeciality) ? _selectedSpeciality : (specs.isNotEmpty ? specs.first : null),
                            isExpanded: true,
                            dropdownColor: isDark ? const Color(0xFF282926) : white,
                            items: specs.map((s) {
                              return DropdownMenuItem<String>(
                                value: s,
                                child: Text(
                                  s,
                                  style: r14.copyWith(color: theme.textTheme.bodyLarge?.color),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedSpeciality = val);
                            },
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
          Spacing.s12.h,
          _buildTextField(
            label: 'Avatar / Profile Image URL *',
            controller: _imageController,
            hint: 'https://... or click avatar above to upload',
            validator: (v) => v == null || v.trim().isEmpty ? 'Image URL required' : null,
            suffixIcon: IconButton(
              icon: Icon(Icons.add_photo_alternate_rounded, color: primary, size: 20.spMin),
              tooltip: 'Upload photo from files',
              onPressed: _isUploadingImage ? null : () => _handleAvatarTap(context),
            ),
            onChanged: (_) => setState(() {}),
          ),
          Spacing.s12.h,
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Rate / Hour (\$) *',
                  controller: _priceController,
                  hint: '25.0',
                  keyboardType: TextInputType.number,
                ),
              ),
              Spacing.s8.w,
              Expanded(
                child: _buildTextField(
                  label: 'Experience (Years) *',
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
              Spacing.s8.w,
              Expanded(
                child: _buildTextField(
                  label: 'Consultations Count',
                  controller: _patientsController,
                  hint: '500',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          Spacing.s12.h,
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Sub-Specialties / Focus Tags (Comma Separated)',
                  controller: _specialtiesController,
                  hint: 'Anxiety, CBT, Mindfulness, Trauma',
                ),
              ),
              Spacing.s12.w,
              Expanded(
                child: _buildTextField(
                  label: 'Languages Spoken (Comma Separated)',
                  controller: _languagesController,
                  hint: 'English, Spanish, French',
                ),
              ),
            ],
          ),
          Spacing.s12.h,
          _buildTextField(
            label: 'Doctor Biography / About *',
            controller: _bioController,
            hint: 'Overview of qualifications, clinical approach, and therapy philosophy...',
            maxLines: 3,
            validator: (v) => v == null || v.trim().isEmpty ? 'Biography required' : null,
          ),
        ],
      ),
    );
  }

  // --- STEP 2: EDUCATIONAL & PROFESSIONAL INFORMATION ---

  Widget buildStep2EducationalInfo(BuildContext context) {
    return Form(
      key: _step2FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildTextField(
                  label: 'Highest Degree / Qualification *',
                  controller: _degreeController,
                  hint: 'e.g. Ph.D. in Clinical Psychology, Psy.D., M.D.',
                  validator: (v) => v == null || v.trim().isEmpty ? 'Degree required' : null,
                ),
              ),
              Spacing.s12.w,
              Expanded(
                flex: 2,
                child: _buildTextField(
                  label: 'Graduation Year *',
                  controller: _gradYearController,
                  hint: 'e.g. 2016',
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Year required' : null,
                ),
              ),
            ],
          ),
          Spacing.s12.h,
          _buildTextField(
            label: 'University / Medical Institution *',
            controller: _universityController,
            hint: 'e.g. Stanford University School of Medicine',
            validator: (v) => v == null || v.trim().isEmpty ? 'University required' : null,
          ),
          Spacing.s12.h,
          _buildTextField(
            label: 'Medical License Number / Registration ID *',
            controller: _licenseController,
            hint: 'e.g. PSY-88219-CA',
            validator: (v) => v == null || v.trim().isEmpty ? 'License required' : null,
          ),
          Spacing.s12.h,
          _buildTextField(
            label: 'Certifications & Accreditations (Comma Separated)',
            controller: _certificationsController,
            hint: 'e.g. Licensed Clinical Psychologist (LCP), EMDR Certified, Board Certified',
            maxLines: 2,
          ),
          Spacing.s16.h,
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.verified_user_rounded, color: primary, size: 22.spMin),
                Spacing.s12.w,
                Expanded(
                  child: Text(
                    'All doctor credentials and medical licenses are cross-referenced with authorized state boards prior to verification.',
                    style: r12.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- STEP 3: AVAILABILITY & WORKING SCHEDULE ---

  Widget buildStep3AvailabilityInfo(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Form(
      key: _step3FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consultation Modalities & Features',
            style: r14.copyWith(fontWeight: FontWeight.w700, color: theme.textTheme.headlineMedium?.color),
          ),
          Spacing.s8.h,
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
                  title: Text('Profile Active', style: r12.copyWith(fontWeight: FontWeight.w600)),
                  contentPadding: EdgeInsets.zero,
                  activeColor: successColor,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ],
          ),
          Spacing.s16.h,
          Text(
            'Available Days of the Week',
            style: r14.copyWith(fontWeight: FontWeight.w700, color: theme.textTheme.headlineMedium?.color),
          ),
          Spacing.s8.h,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _daysOfWeek.map((day) {
              final isSelected = _selectedDays.contains(day);

              return FilterChip(
                label: Text(day),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedDays.add(day);
                    } else {
                      _selectedDays.remove(day);
                    }
                  });
                },
                selectedColor: primary.withValues(alpha: 0.2),
                checkmarkColor: primary,
                labelStyle: r12.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? primary : theme.textTheme.bodyMedium?.color,
                ),
              );
            }).toList(),
          ),
          Spacing.s16.h,
          Text(
            'Daily Working Hours',
            style: r14.copyWith(fontWeight: FontWeight.w700, color: theme.textTheme.headlineMedium?.color),
          ),
          Spacing.s8.h,
          Row(
            children: [
              Expanded(
                child: _buildTimeDropdown(
                  label: 'Shift Start Time',
                  value: _workingHoursStart,
                  onChanged: (val) => setState(() => _workingHoursStart = val ?? '09:00 AM'),
                  isDark: isDark,
                  theme: theme,
                ),
              ),
              Spacing.s16.w,
              Expanded(
                child: _buildTimeDropdown(
                  label: 'Shift End Time',
                  value: _workingHoursEnd,
                  onChanged: (val) => setState(() => _workingHoursEnd = val ?? '06:00 PM'),
                  isDark: isDark,
                  theme: theme,
                ),
              ),
            ],
          ),
          Spacing.s16.h,
          Text(
            'Available Consultation Shifts & Durations',
            style: r14.copyWith(fontWeight: FontWeight.w700, color: theme.textTheme.headlineMedium?.color),
          ),
          Spacing.s8.h,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shifts', style: r12.copyWith(color: theme.textTheme.bodySmall?.color)),
                    Spacing.s4.h,
                    Wrap(
                      spacing: 6.w,
                      children: _shiftsList.map((shift) {
                        final isSel = _selectedShifts.contains(shift);
                        return ChoiceChip(
                          label: Text(shift),
                          selected: isSel,
                          onSelected: (sel) {
                            setState(() {
                              if (sel) {
                                _selectedShifts.add(shift);
                              } else {
                                _selectedShifts.remove(shift);
                              }
                            });
                          },
                          selectedColor: primary.withValues(alpha: 0.2),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Session Durations (Min)', style: r12.copyWith(color: theme.textTheme.bodySmall?.color)),
                    Spacing.s4.h,
                    Wrap(
                      spacing: 6.w,
                      children: _durationsList.map((dur) {
                        final isSel = _selectedDurations.contains(dur);
                        return ChoiceChip(
                          label: Text('${dur}m'),
                          selected: isSel,
                          onSelected: (sel) {
                            setState(() {
                              if (sel) {
                                _selectedDurations.add(dur);
                              } else {
                                _selectedDurations.remove(dur);
                              }
                            });
                          },
                          selectedColor: primary.withValues(alpha: 0.2),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDropdown({
    required String label,
    required String value,
    required ValueChanged<String?> onChanged,
    required bool isDark,
    required ThemeData theme,
  }) {
    final times = [
      '07:00 AM', '08:00 AM', '09:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
      '01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM', '05:00 PM', '06:00 PM',
      '07:00 PM', '08:00 PM', '09:00 PM',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: r12.copyWith(fontWeight: FontWeight.w600, color: theme.textTheme.bodyMedium?.color)),
        Spacing.s4.h,
        Container(
          height: 44.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF282926) : const Color(0xFFF9FAF7),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: times.contains(value) ? value : times[2],
              isExpanded: true,
              dropdownColor: isDark ? const Color(0xFF282926) : white,
              items: times.map((t) => DropdownMenuItem(value: t, child: Text(t, style: r14))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // --- BOTTOM ACTIONS ---

  Widget buildBottomActions(BuildContext context, bool isEditing) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _isLoading || _isUploadingImage ? null : () => Navigator.of(context).pop(),
          child: Text('Cancel', style: r14.copyWith(color: theme.textTheme.bodyMedium?.color)),
        ),
        Row(
          children: [
            if (_currentStep > 0) ...[
              OutlinedButton.icon(
                onPressed: _isLoading || _isUploadingImage ? null : _prevStep,
                icon: const Icon(Icons.arrow_back_rounded, size: 16),
                label: const Text('Previous'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
              ),
              Spacing.s12.w,
            ],
            if (_currentStep < 2)
              ElevatedButton.icon(
                onPressed: _isLoading || _isUploadingImage ? null : _nextStep,
                icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
                label: Text('Next Step', style: r14.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  elevation: 0,
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: _isLoading || _isUploadingImage ? null : _submitRegistration,
                icon: _isLoading
                    ? SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.check_circle_rounded, size: 18, color: Colors.white),
                label: Text(
                  isEditing ? 'Save Changes' : 'Register Doctor',
                  style: r14.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  elevation: 0,
                ),
              ),
          ],
        ),
      ],
    );
  }

  // --- AVATAR PICKER ---

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
                      radius: 44.r,
                      imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
                      name: _nameController.text.isNotEmpty ? _nameController.text : 'Dr.',
                    ),
                    if (_isUploadingImage)
                      Container(
                        width: 88.r,
                        height: 88.r,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
          Spacing.s4.h,
          Text(
            _isUploadingImage
                ? 'Uploading photo...'
                : (kIsWeb ? 'Click avatar to upload photo from files' : 'Click avatar to upload photo'),
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
