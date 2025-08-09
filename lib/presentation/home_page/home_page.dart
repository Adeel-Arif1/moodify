// home_page.dart (Same as your current file, only _buildVideoList updated)
import 'package:zee_palm_task/constants/constants.dart';
import 'package:zee_palm_task/controllers/home_controller.dart';
import 'package:zee_palm_task/models/video_model.dart';
import 'package:zee_palm_task/packages/packages.dart';
import 'package:zee_palm_task/widgets/video_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Moodify ',
          style: GoogleFonts.poppins(
            fontSize: isWeb ? 24 : 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFF1F2937)),
        actions: [
          IconButton(
            onPressed: controller.refreshVideos,
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(controller, isWeb),
      body: Obx(() {
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
    );
  }

  Widget _buildDrawer(HomeController controller, bool isWeb) {
    return Drawer(
      backgroundColor: Colors.white,
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
                  Color(0xFF667eea),
                  Color(0xFF764ba2),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: isWeb ? 35 : 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: isWeb ? 35 : 30,
                      color: const Color(0xFF667eea),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 4),
                  Text(
                    'Welcome back!',
                    style: GoogleFonts.poppins(
                      fontSize: isWeb ? 14 : 12,
                      color: Colors.white70,
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
                  icon: Icons.upload_rounded,
                  title: 'Upload Video',
                  onTap: controller.navigateToUpload,
                  isWeb: isWeb,
                ),
                const Divider(height: 32),
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
    return ListTile(
      leading: Icon(
        icon,
        color:
            isDestructive ? const Color(0xFFEF4444) : const Color(0xFF6B7280),
        size: isWeb ? 24 : 22,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: isWeb ? 16 : 14,
          fontWeight: FontWeight.w500,
          color:
              isDestructive ? const Color(0xFFEF4444) : const Color(0xFF1F2937),
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: isWeb ? 24 : 20,
        vertical: 4,
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: SpinKitThreeBounce(
        color: Color(0xFF667eea),
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
              color: Color(0xFFEF4444),
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
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
                backgroundColor: const Color(0xFF667eea),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
              color: Color(0xFF9CA3AF),
            ),
            const SizedBox(height: 16),
            Text(
              'No videos yet',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
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
      color: const Color(0xFF667eea),
      child: ListView.builder(
        padding: EdgeInsets.all(isWeb ? 16 : 12),
        itemCount: controller.videos.length,
        itemBuilder: (context, index) {
          final video = controller.videos[index];
          return TikTokVideoCard(
            video: video,
            isWeb: isWeb,
            onLikeToggle: controller.toggleLike,
          );
        },
      ),
    );
  }
}
