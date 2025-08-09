// upload_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:zee_palm_task/packages/packages.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class UploadController extends GetxController {
  Rx<TextEditingController> captionController = TextEditingController().obs;

  // Upload state
  RxBool isUploading = false.obs;
  RxDouble uploadProgress = 0.0.obs;
  RxString uploadStatus = ''.obs;

  // Selected video
  Rx<File?> selectedVideo = Rx<File?>(null);
  RxString selectedVideoName = ''.obs;
  RxString selectedVideoSize = ''.obs;

  final AuthController authController = Get.find<AuthController>();

  /// Pick video file
  Future<void> pickVideo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        selectedVideo.value = File(result.files.single.path!);
        selectedVideoName.value = result.files.single.name;
        selectedVideoSize.value = _formatFileSize(result.files.single.size);

        Get.snackbar(
          'Success',
          'Video selected successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick video: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    }
  }

  /// Upload video to Firebase
  Future<void> uploadVideo() async {
    if (!_validateForm()) return;

    try {
      isUploading.value = true;
      uploadProgress.value = 0.0;
      uploadStatus.value = 'Preparing upload...';

      // Get current user
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Create unique filename
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${selectedVideoName.value}';
      final storageRef =
          FirebaseStorage.instance.ref().child('videos').child(fileName);

      uploadStatus.value = 'Uploading video...';

      // Upload file
      final uploadTask = storageRef.putFile(selectedVideo.value!);

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        uploadProgress.value = snapshot.bytesTransferred / snapshot.totalBytes;
      });

      // Wait for upload completion
      await uploadTask;

      uploadStatus.value = 'Getting download URL...';

      // Get download URL
      final downloadURL = await storageRef.getDownloadURL();

      uploadStatus.value = 'Saving video data...';

      // Get user data
      final userDoc = await FirebaseFirestore.instance
          .collection('zee_palm_users')
          .doc(currentUser.uid)
          .get();

      final userData = userDoc.data();
      final userName = userData?['name'] ?? 'Unknown User';

      // Save video data to Firestore
      await FirebaseFirestore.instance.collection('zee_palm_videos').add({
        'caption': captionController.value.text.trim(),
        'videoUrl': downloadURL,
        'uploaderName': userName,
        'uploaderEmail': currentUser.email,
        'uploaderId': currentUser.uid,
        'uploadedAt': FieldValue.serverTimestamp(),
        'views': 0,
        'likes': 0,
        'fileName': fileName,
        'fileSize': selectedVideo.value!.lengthSync(),
      });

      uploadStatus.value = 'Upload completed!';
      isUploading.value = false;

      Get.snackbar(
        'Success',
        'Video uploaded successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Clear form and navigate back
      _clearForm();
      Get.back();
    } catch (e) {
      isUploading.value = false;
      uploadProgress.value = 0.0;
      uploadStatus.value = '';

      Get.snackbar(
        'Error',
        'Upload failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    }
  }

  /// Validate form
  bool _validateForm() {
    if (selectedVideo.value == null) {
      Get.snackbar(
        'Error',
        'Please select a video file',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
      return false;
    }

    if (captionController.value.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a caption',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white);
      return false;
    }

    return true;
  }

  /// Clear form
  void _clearForm() {
    captionController.value.clear();
    selectedVideo.value = null;
    selectedVideoName.value = '';
    selectedVideoSize.value = '';
    uploadProgress.value = 0.0;
    uploadStatus.value = '';
  }

  /// Format file size
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  void onClose() {
    captionController.value.dispose();
    super.onClose();
  }
}
