import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'image_upload_service.dart'; // Import the service
import 'image_uploaded_page.dart'; // Import the ImageUploadedPage

class CropImagePage extends StatefulWidget {
  final XFile imageFile;

  const CropImagePage({Key? key, required this.imageFile}) : super(key: key);

  @override
  _CropImagePageState createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  CroppedFile? _croppedFile;
  bool _isCropping = false;
  bool _isUploading = false;
  final ImageService _imageService = ImageService(); // Initialize the service

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isCropping) {
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    setState(() {
      _isCropping = true;
    });

    final theme = Theme.of(context).colorScheme;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: widget.imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: theme.primary,
          toolbarWidgetColor: theme.onPrimary,
          statusBarColor: theme.primary,
          backgroundColor: theme.background,
          activeControlsWidgetColor: theme.primary,
          dimmedLayerColor: theme.onBackground.withOpacity(0.5),
          cropFrameColor: theme.primary,
          cropGridColor: theme.onBackground,
          cropFrameStrokeWidth: 2,
          cropGridRowCount: 3,
          cropGridColumnCount: 3,
          cropGridStrokeWidth: 1,
          showCropGrid: true,
          lockAspectRatio: false,
          hideBottomControls: false,
          initAspectRatio: CropAspectRatioPreset.original,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.original,
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _croppedFile = croppedFile;
      });

      // Start uploading
      await _uploadCroppedImage();
    }

    setState(() {
      _isCropping = false;
    });
  }

  Future<void> _uploadCroppedImage() async {
    setState(() {
      _isUploading = true; // Show uploading indicator (Lottie)
    });

    // Upload image and get response
    String? responseMessage =
        await _imageService.uploadCroppedImage(File(_croppedFile!.path));

    setState(() {
      _isUploading = false; // Hide uploading indicator
    });

    if (responseMessage != null) {
      // Navigate to the Image Uploaded page with the response message
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ImageUploadedPage(responseMessage: responseMessage),
        ),
      );
    } else {
      // Handle upload error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image')),
      );
      Navigator.pop(context); // Navigate back to TransactionsPage
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Image'),
        backgroundColor: theme.primary,
        foregroundColor: theme.onPrimary,
      ),
      body: Center(
        child: _isCropping
            ? CircularProgressIndicator(color: theme.primary)
            : _isUploading
                ? Lottie.asset('assets/uploading.json', width: 200, height: 200)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_croppedFile != null)
                        Image.file(File(_croppedFile!.path)),
                      SizedBox(height: 20),
                    ],
                  ),
      ),
    );
  }
}
