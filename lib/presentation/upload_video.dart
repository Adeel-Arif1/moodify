// upload_video_page.dart
import 'package:zee_palm_task/controllers/upload_controler.dart';
import 'package:zee_palm_task/packages/packages.dart';

class UploadVideoPage extends StatelessWidget {
  const UploadVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UploadController controller = Get.put(UploadController());
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Upload Video',
          style: GoogleFonts.poppins(
            fontSize: isWeb ? 24 : 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1F2937)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isWeb ? 24 : 16),
          child: Center(
            child: Container(
              width: isWeb ? 600 : double.infinity,
              constraints: BoxConstraints(
                maxWidth: isWeb ? 600 : double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video Selection Card
                  _buildVideoSelectionCard(controller, isWeb),

                  const SizedBox(height: 24),

                  // Video Details Form
                  _buildVideoDetailsForm(controller, isWeb),

                  const SizedBox(height: 32),

                  // Upload Button
                  Obx(() => _buildUploadButton(controller, isWeb)),

                  // Upload Progress
                  Obx(() => controller.isUploading.value
                      ? _buildUploadProgress(controller, isWeb)
                      : const SizedBox.shrink()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoSelectionCard(UploadController controller, bool isWeb) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWeb ? 32 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() => controller.selectedVideo.value == null
          ? _buildVideoSelector(controller, isWeb)
          : _buildSelectedVideoInfo(controller, isWeb)),
    );
  }

  Widget _buildVideoSelector(UploadController controller, bool isWeb) {
    return Column(
      children: [
        Container(
          width: isWeb ? 120 : 80,
          height: isWeb ? 120 : 80,
          decoration: BoxDecoration(
            color: const Color(0xFF667eea).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.video_library_outlined,
            size: isWeb ? 48 : 32,
            color: const Color(0xFF667eea),
          ),
        ),
        SizedBox(height: isWeb ? 24 : 16),
        Text(
          'Select Video File',
          style: GoogleFonts.poppins(
            fontSize: isWeb ? 20 : 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose a video file from your device',
          style: GoogleFonts.poppins(
            fontSize: isWeb ? 14 : 12,
            color: const Color(0xFF6B7280),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isWeb ? 24 : 16),
        ElevatedButton.icon(
          onPressed: controller.pickVideo,
          icon: const Icon(Icons.folder_open),
          label: Text(
            'Browse Files',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF667eea),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? 32 : 24,
              vertical: isWeb ? 16 : 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedVideoInfo(UploadController controller, bool isWeb) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: isWeb ? 60 : 48,
              height: isWeb ? 60 : 48,
              decoration: BoxDecoration(
                color: const Color(0xFF667eea),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.video_file,
                color: Colors.white,
                size: isWeb ? 28 : 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.selectedVideoName.value,
                    style: GoogleFonts.poppins(
                      fontSize: isWeb ? 16 : 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Size: ${controller.selectedVideoSize.value}',
                    style: GoogleFonts.poppins(
                      fontSize: isWeb ? 14 : 12,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                controller.selectedVideo.value = null;
                controller.selectedVideoName.value = '';
                controller.selectedVideoSize.value = '';
              },
              icon: const Icon(
                Icons.close,
                color: Color(0xFFEF4444),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: controller.pickVideo,
          icon: const Icon(Icons.refresh),
          label: Text(
            'Change Video',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF667eea),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoDetailsForm(UploadController controller, bool isWeb) {
    return Container(
      padding: EdgeInsets.all(isWeb ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Video Details',
            style: GoogleFonts.poppins(
              fontSize: isWeb ? 20 : 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),

          const SizedBox(height: 20),

          // Description Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Caption',
                style: GoogleFonts.poppins(
                  fontSize: isWeb ? 14 : 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.captionController.value,
                maxLines: 4,
                style: GoogleFonts.poppins(
                  fontSize: isWeb ? 16 : 14,
                  color: const Color(0xFF1F2937),
                ),
                decoration: InputDecoration(
                  hintText: 'Enter video description...',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: isWeb ? 16 : 14,
                    color: const Color(0xFF9CA3AF),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF667eea),
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: isWeb ? 18 : 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(UploadController controller, bool isWeb) {
    return CustomButton(
      text: controller.isUploading.value ? 'Uploading...' : 'Upload Video',
      isLoading: controller.isUploading.value,
      onPressed: controller.isUploading.value ? null : controller.uploadVideo,
      backgroundColor: const Color(0xFF667eea),
      width: double.infinity,
      height: isWeb ? 54 : 48,
    );
  }

  Widget _buildUploadProgress(UploadController controller, bool isWeb) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: EdgeInsets.all(isWeb ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const SpinKitThreeBounce(
                color: Color(0xFF667eea),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  controller.uploadStatus.value,
                  style: GoogleFonts.poppins(
                    fontSize: isWeb ? 16 : 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: controller.uploadProgress.value,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
            minHeight: 6,
          ),
          const SizedBox(height: 8),
          Text(
            '${(controller.uploadProgress.value * 100).toInt()}% Complete',
            style: GoogleFonts.poppins(
              fontSize: isWeb ? 14 : 12,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
