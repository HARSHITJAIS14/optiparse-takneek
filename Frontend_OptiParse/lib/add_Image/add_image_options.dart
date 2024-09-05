import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:optiparse/add_Image/crop_image.dart';

class AddImageOptions extends StatelessWidget {
  const AddImageOptions({Key? key}) : super(key: key);

  // Method to pick an image
  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // Navigate to CropImagePage with the selected image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CropImagePage(imageFile: pickedFile),
        ),
      );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scroll Indicator
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Option 1: Scan an Image (Camera)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                Icon(Icons.camera_alt,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Text(
                  'Scan an Image',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            onTap: () => _pickImage(context, ImageSource.camera),
          ),
          const SizedBox(height: 10),

          // Option 2: Upload from Gallery
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                Icon(Icons.photo_library,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Text(
                  'Upload from Gallery',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            onTap: () => _pickImage(context, ImageSource.gallery),
          ),
        ],
      ),
    );
  }
}
