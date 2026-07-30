import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';
import '../../../infrastructure/theme/theme.dart';
import '../controllers/home.controller.dart';

class CrisisSupportScreen extends StatefulWidget {
  const CrisisSupportScreen({super.key});

  @override
  State<CrisisSupportScreen> createState() => _CrisisSupportScreenState();
}

class _CrisisSupportScreenState extends State<CrisisSupportScreen> {
  final HomeController _homeController = Get.find<HomeController>();
  
  // Local state for hotline region selection
  String selectedRegion = 'USA & Canada';
  final List<String> regions = ['USA & Canada', 'UK', 'India', 'International'];

  // Input controllers for trusted contact
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  final Map<String, List<Map<String, String>>> hotlines = {
    'USA & Canada': [
      {'name': '988 Suicide & Crisis Lifeline', 'number': '988'},
      {'name': 'Crisis Text Line', 'number': 'Text HOME to 741741'},
      {'name': 'The Trevor Project (LGBTQ+)', 'number': '1-866-488-7386'},
    ],
    'UK': [
      {'name': 'NHS Mental Health services', 'number': '111'},
      {'name': 'Samaritans Helpline', 'number': '116 123'},
      {'name': 'Shout Crisis Text Line', 'number': 'Text SHOUT to 85258'},
    ],
    'India': [
      {'name': 'KIRAN Mental Health Helpline', 'number': '1800-599-0019'},
      {'name': 'AASRA suicide prevention', 'number': '91-9820466726'},
      {'name': 'Vandrevala Foundation', 'number': '9999 666 555'},
    ],
    'International': [
      {'name': 'Befrienders Worldwide', 'number': 'befrienders.org'},
      {'name': 'IASP Helpline Directory', 'number': 'iasp.info/resources'},
    ],
  };

  // Safe variables for trusted contact stored inside HomeController
  String get contactName => _homeController.trustedContactName.value;
  String get contactPhone => _homeController.trustedContactPhone.value;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: contactName);
    _phoneController = TextEditingController(text: contactPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveContact() {
    _homeController.updateTrustedContact(_nameController.text, _phoneController.text);
    Get.snackbar(
      "Saved", 
      "Trusted contact information updated.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: primary.withValues(alpha: 0.9),
      colorText: Colors.white,
      margin: EdgeInsets.all(16.w),
      borderRadius: 12.r,
    );
  }

  void _simulateCall(String name, String number) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Text(
                '\u{f095}', // phone icon
                style: TextStyle(fontFamily: 'FontAwesomeSolid', color: primary, fontSize: 16.sp),
              ),
            ),
            Spacing.s12.w,
            Text("Simulating Call", style: r18.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          "Connecting you to $name at $number...\n\nIn a production build, this would launch your device's dialer.",
          style: r14,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("End Call", style: r14.copyWith(color: dangerColor, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  void _simulateMessage(String name, String number) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Text(
                '\u{f4ad}', // comment icon
                style: TextStyle(fontFamily: 'FontAwesomeSolid', color: primary, fontSize: 16.sp),
              ),
            ),
            Spacing.s12.w,
            Text("Simulating Message", style: r18.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          "Sending a crisis help message to $name ($number):\n\n\"Hi, I am feeling overwhelmed right now and wanted to reach out. Please check in on me when you can.\"",
          style: r14,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Close", style: r14.copyWith(color: primary, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.primaryColorLight,
      appBar: AppBar(
        backgroundColor: theme.primaryColorLight,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Crisis Support",
          style: h2.copyWith(fontWeight: FontWeight.w600, color: theme.textTheme.bodyLarge!.color),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s16.symmetric.horizontal,
          vertical: Spacing.s8.symmetric.horizontal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calming exercise
            Text(
              "Immediate Grounding Exercise",
              style: r18.copyWith(fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge!.color),
            ),
            Spacing.s8.h,
            Text(
              "Take a moment to sync your breath with the circle below. Slow breathing calms the nervous system.",
              style: r14.copyWith(color: theme.textTheme.bodySmall!.color),
            ),
            Spacing.s16.h,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primary.withValues(alpha: 0.12),
                    primary.withValues(alpha: 0.03),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: primary.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: const CalmingBreathingCircle(),
            ),
            
            Spacing.s24.h,
            Divider(color: isDark ? slate[700] : slate[200]),
            Spacing.s16.h,

            // Localized Hotlines
            Text(
              "Crisis Hotlines",
              style: r18.copyWith(fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge!.color),
            ),
            Spacing.s8.h,
            // Segment selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: regions.map((region) {
                  final isSelected = selectedRegion == region;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => selectedRegion = region);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected ? primary : (isDark ? slate[800] : Colors.white),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: isSelected ? primary : Colors.grey.shade300,
                            width: 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: primary.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Text(
                          region,
                          style: r12.copyWith(
                            color: isSelected ? Colors.white : theme.textTheme.bodyMedium!.color,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Spacing.s12.h,
            Column(
              children: hotlines[selectedRegion]!.map((item) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: theme.cardTheme.color,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isDark ? slate[700]! : Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '\u{f1cd}', // Life ring icon
                            style: TextStyle(
                              fontFamily: 'FontAwesomeSolid',
                              fontSize: 16.sp,
                              color: primary,
                            ),
                          ),
                        ),
                        Spacing.s16.w,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name']!,
                                style: r14.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.textTheme.bodyLarge!.color,
                                ),
                              ),
                              Spacing.s4.h,
                              Text(
                                item['number']!,
                                style: r12.copyWith(
                                  color: theme.textTheme.bodySmall!.color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30.r),
                            onTap: () => _simulateCall(item['name']!, item['number']!),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '\u{f095}', // phone icon
                                    style: TextStyle(
                                      fontFamily: 'FontAwesomeSolid',
                                      fontSize: 12.sp,
                                      color: primary,
                                    ),
                                  ),
                                  Spacing.s4.w,
                                  Text(
                                    "Call",
                                    style: r12.copyWith(
                                      color: primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            Spacing.s24.h,
            Divider(color: isDark ? slate[700] : slate[200]),
            Spacing.s16.h,

            // Trusted Contact Section
            Text(
              "Trusted Contact",
              style: r18.copyWith(fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge!.color),
            ),
            Spacing.s8.h,
            Text(
              "Save a friend or family member's contact info for quick access.",
              style: r14.copyWith(color: theme.textTheme.bodySmall!.color),
            ),
            Spacing.s16.h,
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isDark ? slate[700]! : Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    style: r14.copyWith(color: theme.textTheme.bodyLarge!.color),
                    decoration: InputDecoration(
                      labelText: "Contact Name",
                      labelStyle: r12.copyWith(color: slate[500]),
                      prefixIcon: Icon(Icons.person_outline, color: primary),
                      filled: true,
                      fillColor: isDark ? slate[900]!.withValues(alpha: 0.4) : Colors.grey.shade50,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: primary, width: 1.5),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    ),
                  ),
                  Spacing.s12.h,
                  TextField(
                    controller: _phoneController,
                    style: r14.copyWith(color: theme.textTheme.bodyLarge!.color),
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      labelStyle: r12.copyWith(color: slate[500]),
                      prefixIcon: Icon(Icons.phone_outlined, color: primary),
                      filled: true,
                      fillColor: isDark ? slate[900]!.withValues(alpha: 0.4) : Colors.grey.shade50,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: primary, width: 1.5),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    ),
                  ),
                  Spacing.s16.h,
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveContact,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                            elevation: 0,
                          ),
                          child: Text(
                            "Save Details",
                            style: r14.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Spacing.s12.w,
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30.r),
                          onTap: () => _simulateCall(_nameController.text, _phoneController.text),
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '\u{f095}', // phone icon
                              style: TextStyle(
                                fontFamily: 'FontAwesomeSolid',
                                fontSize: 16.sp,
                                color: primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacing.s8.w,
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30.r),
                          onTap: () => _simulateMessage(_nameController.text, _phoneController.text),
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '\u{f4ad}', // comment icon
                              style: TextStyle(
                                fontFamily: 'FontAwesomeSolid',
                                fontSize: 16.sp,
                                color: primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacing.s32.h,
          ],
        ),
      ),
    );
  }
}

class CalmingBreathingCircle extends StatefulWidget {
  const CalmingBreathingCircle({super.key});

  @override
  State<CalmingBreathingCircle> createState() => _CalmingBreathingCircleState();
}

class _CalmingBreathingCircleState extends State<CalmingBreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _breathText = "Inhale...";
  String _breathSubText = "Slowly expand your chest";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16), // Box Breathing: 4s inhale, 4s hold, 4s exhale, 4s hold
    )..repeat();

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.6).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25.0, // Inhale
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.6),
        weight: 25.0, // Hold
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.6, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25.0, // Exhale
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 25.0, // Hold
      ),
    ]).animate(_controller);

    _controller.addListener(() {
      final value = _controller.value;
      if (value < 0.25) {
        if (_breathText != "Inhale...") {
          setState(() {
            _breathText = "Inhale...";
            _breathSubText = "Slowly expand your chest";
          });
        }
      } else if (value < 0.50) {
        if (_breathText != "Hold...") {
          setState(() {
            _breathText = "Hold...";
            _breathSubText = "Quiet your thoughts";
          });
        }
      } else if (value < 0.75) {
        if (_breathText != "Exhale...") {
          setState(() {
            _breathText = "Exhale...";
            _breathSubText = "Let go of all tension";
          });
        }
      } else {
        if (_breathText != "Hold...") {
          setState(() {
            _breathText = "Hold...";
            _breathSubText = "Be fully present";
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: 120.w * _animation.value,
                height: 120.w * _animation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withValues(alpha: 0.15),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.25),
                      blurRadius: 25 * _animation.value,
                      spreadRadius: 3 * _animation.value,
                    ),
                  ],
                  border: Border.all(
                    color: primary.withValues(alpha: 0.4),
                    width: 2.5,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 90.w * _animation.value,
                    height: 90.w * _animation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          primary.withValues(alpha: 0.5),
                          primary.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Spacing.s24.h,
          Text(
            _breathText,
            style: h2.copyWith(
              color: primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          Spacing.s4.h,
          Text(
            _breathSubText,
            style: r14.copyWith(
              color: theme.textTheme.bodySmall!.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
