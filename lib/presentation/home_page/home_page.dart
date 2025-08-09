import 'package:zee_palm_task/constants/constants.dart';
import 'package:zee_palm_task/controllers/home_controller.dart';
import 'package:zee_palm_task/controllers/mood_controller.dart';
import 'package:zee_palm_task/models/video_model.dart';
import 'package:zee_palm_task/packages/packages.dart';
import 'package:zee_palm_task/widgets/video_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final MoodController moodController = Get.put(MoodController());
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFF1F2937), // Dark gray background
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827), // Darker app bar
        elevation: 0,
        title: Text(
          'Moodify',
          style: GoogleFonts.poppins(
            fontSize: isWeb ? 24 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFFD1D5DB)),
        actions: [
          IconButton(
            onPressed: controller.refreshVideos,
            icon: const Icon(Icons.refresh),
            color: const Color(0xFF6366F1), // Indigo accent
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(controller, isWeb),
      body: Column(
        children: [
          // Mood Selection Chips
          Container(
            padding: EdgeInsets.symmetric(horizontal: isWeb ? 16 : 12, vertical: 8),
            color: const Color(0xFF111827), // Darker chip background
            child: Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: moodController.moods.map((mood) {
                      bool isSelected = moodController.selectedMood.value == mood;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            mood,
                            style: GoogleFonts.poppins(
                              fontSize: isWeb ? 14 : 12,
                              color: isSelected ? Colors.white : const Color(0xFFD1D5DB),
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF6366F1), // Indigo for selected
                          backgroundColor: const Color(0xFF374151), // Dark gray
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? const Color(0xFF6366F1)
                                  : const Color(0xFF4B5563),
                            ),
                          ),
                          onSelected: (selected) {
                            if (selected) moodController.setMood(mood);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                )),
          ),
          // Video List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildLoadingState();
              }
              if (controller.hasError.value) {
                return _buildErrorState(controller);
              }
              if (controller.videos.isEmpty) {
                return _buildEmptyState();
              }
              return _buildVideoList(controller, isWeb);
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.navigateToUpload,
        backgroundColor: const Color(0xFF6366F1), // Indigo FAB
        child: const Icon(Icons.upload, color: Colors.white),
      ),
    );
  }

  Widget _buildDrawer(HomeController controller, bool isWeb) {
    final AuthController authController = Get.find<AuthController>();
    return Drawer(
      backgroundColor: const Color(0xFF111827), // Dark drawer
      child: Column(
        children: [
          // Drawer Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isWeb ? 32 : 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6366F1), // Indigo
                  Color(0xFFA78BFA), // Purple
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 500),
                    child: CircleAvatar(
                      radius: isWeb ? 35 : 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: isWeb ? 35 : 30,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      FirebaseAuth.instance.currentUser?.email ?? 'User',
                      style: GoogleFonts.poppins(
                        fontSize: isWeb ? 18 : 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      'Welcome to Moodify!',
                      style: GoogleFonts.poppins(
                        fontSize: isWeb ? 14 : 12,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Drawer Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: isWeb ? 16 : 12),
              children: [
                _buildDrawerItem(
                  icon: Icons.mood,
                  title: 'Select Mood',
                  onTap: () {
                    Get.back(); // Close drawer
                  },
                  isWeb: isWeb,
                ),
                _buildDrawerItem(
                  icon: Icons.upload_rounded,
                  title: 'Upload Video',
                  onTap: controller.navigateToUpload,
                  isWeb: isWeb,
                ),
                _buildDrawerItem(
                  icon: Icons.person,
                  title: 'Profile',
                  onTap: () {
                    Get.snackbar('Profile', 'Profile page coming soon!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFFA78BFA),
                        colorText: Colors.white);
                  },
                  isWeb: isWeb,
                ),
                const Divider(
                  color: Color(0xFF4B5563),
                  height: 32,
                ),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  onTap: () {
                    authService.signOut();
                  },
                  isWeb: isWeb,
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isWeb,
    bool isDestructive = false,
  }) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? const Color(0xFFF87171) : const Color(0xFFD1D5DB),
          size: isWeb ? 24 : 22,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: isWeb ? 16 : 14,
            fontWeight: FontWeight.w500,
            color: isDestructive ? const Color(0xFFF87171) : Colors.white,
          ),
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isWeb ? 24 : 20,
          vertical: 4,
        ),
        hoverColor: const Color(0xFF374151), // Subtle hover effect
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: SpinKitThreeBounce(
        color: Color(0xFF6366F1), // Indigo spinner
        size: 40,
      ),
    );
  }

  Widget _buildErrorState(HomeController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Color(0xFFF87171), // Red for error
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Unable to load videos',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.fetchVideos,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1), // Indigo button
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Try Again',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.video_library_outlined,
              size: 64,
              color: Color(0xFF6B7280),
            ),
            const SizedBox(height: 16),
            Text(
              'No videos yet',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to upload a video!',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoList(HomeController controller, bool isWeb) {
    return RefreshIndicator(
      onRefresh: controller.refreshVideos,
      color: const Color(0xFF6366F1),
      backgroundColor: const Color(0xFF1F2937),
      child: ListView.builder(
        padding: EdgeInsets.all(isWeb ? 16 : 12),
        itemCount: controller.videos.length,
        itemBuilder: (context, index) {
          final video = controller.videos[index];
          return ZoomIn(
            duration: const Duration(milliseconds: 300),
            child: TikTokVideoCard(
              video: video,
              isWeb: isWeb,
              onLikeToggle: controller.toggleLike,
            ),
          );
        },
      ),
    );
  }
}
