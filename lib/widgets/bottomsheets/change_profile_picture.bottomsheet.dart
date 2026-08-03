import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'custom_bottomsheet.widget.dart';

class ChangeProfilePictureBottomsheet extends StatelessWidget {
  final VoidCallback onTakePhoto;
  final VoidCallback onChooseFromGallery;
  final bool showRemoveOption;
  final VoidCallback onRemovePhoto;

  const ChangeProfilePictureBottomsheet({
    super.key,
    required this.onTakePhoto,
    required this.onChooseFromGallery,
    required this.showRemoveOption,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBottomsheet(
      title: "Profile Photo",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.photo_camera, color: primary),
            title: Text(
              "Take Photo",
              style: r14.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            onTap: () {
              Get.back();
              onTakePhoto();
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library, color: primary),
            title: Text(
              "Choose from Gallery",
              style: r14.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            onTap: () {
              Get.back();
              onChooseFromGallery();
            },
          ),
          if (showRemoveOption) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(
                "Remove Photo",
                style: r14.copyWith(color: Colors.red),
              ),
              onTap: () {
                Get.back();
                onRemovePhoto();
              },
            ),
          ],
        ],
      ),
    );
  }
}
