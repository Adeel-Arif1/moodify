import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zee_palm_task/controllers/home_controller.dart';
import 'package:zee_palm_task/controllers/mood_controller.dart';
import 'package:zee_palm_task/models/video_model.dart';
import 'package:zee_palm_task/packages/packages.dart';
import 'package:zee_palm_task/widgets/video_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final MoodController moodController = Get.find<MoodController>();
    final AuthController authController = Get.find<AuthController>();
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 800;
    final ScrollController scrollController = ScrollController();

    // State for pagination
    final RxList<VideoModel> userVideos = <VideoModel>[].obs;
    final RxBool isLoading = false.obs;
    final RxBool hasMore = true.obs;
    DocumentSnapshot? lastDocument;
    const int pageSize = 10;

    // Fetch user's videos with pagination
    Future<void> fetchUserVideos({bool isRefresh = false}) async {
      if (!hasMore.value && !isRefresh) return;
      try {
        isLoading.value = true;
        if (isRefresh) {
          userVideos.clear();
          lastDocument = null;
          hasMore.value = true;
        }

        final userId = FirebaseAuth.instance.currentUser?.uid;
        Query<Map<String, dynamic>> query = FirebaseFirestore.instance
            .collection('zee_palm_videos')
            .where('uploaderId', isEqualTo: userId)
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
          userVideos.addAll(newVideos);
          hasMore.value = snapshot.docs.length == pageSize;
        }
      } catch (e) {
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

    // Load more videos on scroll
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoading.value &&
          hasMore.value) {
        fetchUserVideos();
      }
    });

    // Initial fetch
    fetchUserVideos();

    // Fetch mood statistics
    Future<Map<String, int>> fetchMoodStats() async {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection('zee_palm_videos')
          .where('uploaderId', isEqualTo: userId)
          .get();
      final Map<String, int> stats = {
        for (var mood in moodController.moods.where((m) => m != 'All')) mood: 0
      };
      for (var doc in snapshot.docs) {
        final mood = doc.data()['mood'] as String? ?? 'General';
        stats[mood] = (stats[mood] ?? 0) + 1;
      }
      return stats;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1F2937),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: isWeb ? 24 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFD1D5DB)),
        actions: [
          IconButton(
            onPressed: () => authController.signOut(),
            icon: const Icon(Icons.logout),
            color: const Color(0xFFF87171),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => fetchUserVideos(isRefresh: true),
          color: const Color(0xFF6366F1),
          backgroundColor: const Color(0xFF1F2937),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.all(isWeb ? 24 : 16),
            child: Center(
              child: Container(
                width: isWeb ? 600 : double.infinity,
                constraints: BoxConstraints(maxWidth: isWeb ? 600 : double.infinity),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        padding: EdgeInsets.all(isWeb ? 32 : 24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF6366F1),
                              Color(0xFFA78BFA),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2), // Updated from withOpacity
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ZoomIn(
                              duration: const Duration(milliseconds: 500),
                              child: CircleAvatar(
                                radius: isWeb ? 60 : 50,
                                backgroundColor: Colors.white,
                                child: Text(
                                  FirebaseAuth.instance.currentUser?.email?[0].toUpperCase() ?? 'U',
                                  style: GoogleFonts.poppins(
                                    fontSize: isWeb ? 40 : 32,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF6366F1),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              authController.userName.value.isNotEmpty
                                  ? authController.userName.value
                                  : 'User',
                              style: GoogleFonts.poppins(
                                fontSize: isWeb ? 22 : 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              FirebaseAuth.instance.currentUser?.email ?? 'No email',
                              style: GoogleFonts.poppins(
                                fontSize: isWeb ? 16 : 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Get.snackbar(
                                      'Info',
                                      'Edit Profile feature coming soon!',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: const Color(0xFFA78BFA),
                                      colorText: Colors.white,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF6366F1),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                  child: Text(
                                    'Edit Profile',
                                    style: GoogleFonts.poppins(
                                      fontSize: isWeb ? 16 : 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton(
                                  onPressed: () {
                                    Get.snackbar(
                                      'Info',
                                      'Share Profile feature coming soon!',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: const Color(0xFFA78BFA),
                                      colorText: Colors.white,
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.white),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                  child: Text(
                                    'Share Profile',
                                    style: GoogleFonts.poppins(
                                      fontSize: isWeb ? 16 : 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Mood Statistics
                    Text(
                      'Your Mood Stats',
                      style: GoogleFonts.poppins(
                        fontSize: isWeb ? 20 : 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FutureBuilder<Map<String, int>>(
                      future: fetchMoodStats(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: SpinKitThreeBounce(
                              color: Color(0xFF6366F1),
                              size: 30,
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text(
                            'Error loading stats',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFFF87171),
                            ),
                          );
                        }
                        final stats = snapshot.data ?? {};
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: moodController.moods
                                .where((mood) => mood != 'All')
                                .map((mood) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: _getMoodColor(mood).withValues(alpha: 0.9), // Updated from withOpacity
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: _getMoodColor(mood).withValues(alpha: 0.3), // Updated from withOpacity
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          '$mood: ${stats[mood] ?? 0}',
                                          style: GoogleFonts.poppins(
                                            fontSize: isWeb ? 14 : 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // User's Videos
                    Text(
                      'Your Videos',
                      style: GoogleFonts.poppins(
                        fontSize: isWeb ? 20 : 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      if (isLoading.value && userVideos.isEmpty) {
                        return const Center(
                          child: SpinKitThreeBounce(
                            color: Color(0xFF6366F1),
                            size: 30,
                          ),
                        );
                      }
                      if (userVideos.isEmpty && !hasMore.value) {
                        return Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.video_library_outlined,
                                size: 64,
                                color: Color(0xFF6B7280),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No videos uploaded yet',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Share your first video!',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => Get.toNamed('/upload'),
                                child: Text(
                                  'Upload Now',
                                  style: GoogleFonts.poppins(
                                    fontSize: isWeb ? 16 : 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isWeb ? 3 : 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.7,
                            ),
                            itemCount: userVideos.length,
                            itemBuilder: (context, index) {
                              final video = userVideos[index];
                              return ZoomIn(
                                duration: const Duration(milliseconds: 300),
                                child: TikTokVideoCard(
                                  video: video,
                                  isWeb: isWeb,
                                  onLikeToggle: (videoId, isLiked) => homeController.toggleLike(videoId),
                                ),
                              );
                            },
                          ),
                          if (isLoading.value)
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: SpinKitThreeBounce(
                                color: Color(0xFF6366F1),
                                size: 30,
                              ),
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Mood-specific colors for stats badges
  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Happy':
        return const Color(0xFF10B981);
      case 'Sad':
        return const Color(0xFF3B82F6);
      case 'Stressed':
        return const Color(0xFFEF4444);
      case 'Relaxed':
        return const Color(0xFF06B6D4);
      case 'Motivated':
        return const Color(0xFFF59E0B);
      case 'Calm':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFFA78BFA);
    }
  }
}