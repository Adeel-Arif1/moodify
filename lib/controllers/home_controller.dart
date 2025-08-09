import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:zee_palm_task/models/video_model.dart';
import 'package:zee_palm_task/packages/packages.dart';

class HomeController extends GetxController {
  final RxList<VideoModel> videos = <VideoModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxBool hasError = false.obs; // ✅ Added for error state

  DocumentSnapshot? lastDocument;
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  /// Fetch videos from Firestore
  Future<void> fetchVideos({bool isRefresh = false}) async {
    if (!hasMore.value && !isRefresh) return;

    try {
      isLoading.value = true;
      hasError.value = false; // ✅ Reset error on each fetch

      if (isRefresh) {
        videos.clear();
        lastDocument = null;
        hasMore.value = true;
      }

      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection('zee_palm_videos')
          .orderBy('uploadedAt', descending: true)
          .limit(pageSize);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      final snapshot = await query.get();
      if (snapshot.docs.isEmpty) {
        hasMore.value = false;
      } else {
        lastDocument = snapshot.docs.last;
        final newVideos = snapshot.docs
            .map((doc) => VideoModel.fromFirestore(doc))
            .toList();
        videos.addAll(newVideos);
        hasMore.value = snapshot.docs.length == pageSize;
      }
    } catch (e) {
      hasError.value = true; // ✅ Set error state
      Get.snackbar(
        'Error',
        'Failed to load videos: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF87171),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ For RefreshIndicator and refresh button
  Future<void> refreshVideos() async {
    await fetchVideos(isRefresh: true);
  }

  /// ✅ Navigation to Upload Screen
  void navigateToUpload() {
    Get.toNamed('/upload'); // Change '/upload' to your actual route name
  }

  /// ✅ Like toggle matching TikTokVideoCard's expected signature
  Future<void> toggleLikeWithFlag(String videoId, bool isLiked) async {
    await toggleLike(videoId);
  }

  /// Toggle like for a video
  Future<void> toggleLike(String videoId) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        Get.snackbar(
          'Error',
          'Please sign in to like videos',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFF87171),
          colorText: Colors.white,
        );
        return;
      }

      final videoRef =
          FirebaseFirestore.instance.collection('zee_palm_videos').doc(videoId);
      final videoSnapshot = await videoRef.get();
      final videoData = videoSnapshot.data();
      if (videoData == null) return;

      final likedBy = List<String>.from(videoData['likedBy'] ?? []);
      final currentLikes = videoData['likes'] ?? 0;

      if (likedBy.contains(userId)) {
        likedBy.remove(userId);
        await videoRef.update({
          'likes': currentLikes - 1,
          'likedBy': likedBy,
        });
      } else {
        likedBy.add(userId);
        await videoRef.update({
          'likes': currentLikes + 1,
          'likedBy': likedBy,
        });
      }

      // Update local state
      final updatedVideo = videos.firstWhere((video) => video.id == videoId);
      videos[videos.indexOf(updatedVideo)] = updatedVideo.copyWith(
        likes: likedBy.contains(userId)
            ? currentLikes + 1
            : currentLikes - 1,
        likedBy: likedBy,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update like: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF87171),
        colorText: Colors.white,
      );
    }
  }
}
