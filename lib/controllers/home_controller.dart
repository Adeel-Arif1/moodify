// Add to pubspec.yaml:
// video_player: ^2.8.2
// chewie: ^1.7.5

// home_controller.dart (Updated)
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:zee_palm_task/models/video_model.dart';
import 'package:zee_palm_task/packages/packages.dart';
import 'package:zee_palm_task/presentation/upload_video.dart';

class HomeController extends GetxController {
  RxList<VideoModel> videos = <VideoModel>[].obs;
  RxBool isLoading = true.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;

  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  /// Fetch videos from zee_palm_videos collection
  Future<void> fetchVideos() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('zee_palm_videos')
          .orderBy('uploadedAt', descending: true)
          .get();

      List<VideoModel> fetchedVideos = querySnapshot.docs
          .map((doc) => VideoModel.fromFirestore(doc))
          .toList();

      videos.value = fetchedVideos;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
      print('Error fetching videos: $e');
    }
  }

  /// Toggle like for video
  Future<void> toggleLike(String videoId, bool isLiked) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final videoDoc =
          FirebaseFirestore.instance.collection('zee_palm_videos').doc(videoId);

      if (isLiked) {
        // Remove like
        await videoDoc.update({
          'likes': FieldValue.increment(-1),
          'likedBy': FieldValue.arrayRemove([currentUser.uid]),
        });
      } else {
        // Add like
        await videoDoc.update({
          'likes': FieldValue.increment(1),
          'likedBy': FieldValue.arrayUnion([currentUser.uid]),
        });
      }

      // Update local video data
      final videoIndex = videos.indexWhere((v) => v.id == videoId);
      if (videoIndex != -1) {
        final video = videos[videoIndex];
        videos[videoIndex] = VideoModel(
          id: video.id,
          caption: video.caption,
          videoUrl: video.videoUrl,
          thumbnailUrl: video.thumbnailUrl,
          uploaderName: video.uploaderName,
          uploaderEmail: video.uploaderEmail,
          uploadedAt: video.uploadedAt,
          views: video.views,
          likes: isLiked ? video.likes - 1 : video.likes + 1,
          likedBy: isLiked
              ? video.likedBy.where((id) => id != currentUser.uid).toList()
              : [...video.likedBy, currentUser.uid],
        );
      }
    } catch (e) {
      print('Error toggling like: $e');
      Get.snackbar(
        'Error',
        'Failed to update like',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    }
  }

  /// Refresh videos
  Future<void> refreshVideos() async {
    await fetchVideos();
  }

  /// Navigate to upload page
  void navigateToUpload() {
    Get.to(() => UploadVideoPage());
  }
}
