// tiktok_video_card.dart
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:zee_palm_task/models/video_model.dart';
import 'package:zee_palm_task/packages/packages.dart';

class TikTokVideoCard extends StatefulWidget {
  final VideoModel video;
  final bool isWeb;
  final Function(String videoId, bool isLiked) onLikeToggle;

  const TikTokVideoCard({
    super.key,
    required this.video,
    required this.isWeb,
    required this.onLikeToggle,
  });

  @override
  State<TikTokVideoCard> createState() => _TikTokVideoCardState();
}

class _TikTokVideoCardState extends State<TikTokVideoCard> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      if (widget.video.videoUrl.isNotEmpty) {
        _videoController = VideoPlayerController.networkUrl(
          Uri.parse(widget.video.videoUrl),
        );

        await _videoController!.initialize();

        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: false,
          looping: true,
          showControls: true,
          allowFullScreen: true,
          allowMuting: true,
          showControlsOnInitialize: false,
          aspectRatio: _videoController!.value.aspectRatio,
        );

        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      print('Video initialization error: $e');
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isLiked =
        currentUser != null && widget.video.likedBy.contains(currentUser.uid);

    return Container(
      margin: EdgeInsets.only(bottom: widget.isWeb ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Video Player Section with TikTok-style overlay
          Container(
            width: double.infinity,
            height: widget.isWeb ? 400 : 600,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  // Video Player
                  if (_isInitialized && _chewieController != null)
                    Positioned.fill(
                      child: Chewie(controller: _chewieController!),
                    )
                  else if (_hasError)
                    _buildErrorPlayer()
                  else
                    _buildLoadingPlayer(),

                  // TikTok-style Right Side Actions
                  Positioned(
                    right: 12,
                    bottom: 20,
                    child: Column(
                      children: [
                        // Like Button
                        _buildActionButton(
                          icon:
                              isLiked ? Icons.favorite : Icons.favorite_border,
                          iconColor: isLiked ? Colors.red : Colors.white,
                          label: '${widget.video.likes}',
                          onTap: () =>
                              widget.onLikeToggle(widget.video.id, isLiked),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  Positioned(
                    left: 12,
                    right: 80,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Uploader Info
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: const Color(0xFF667eea),
                              child: Text(
                                widget.video.uploaderName.isNotEmpty
                                    ? widget.video.uploaderName[0].toUpperCase()
                                    : 'U',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.video.uploaderName,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    _formatDate(widget.video.uploadedAt),
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Video Title
                        Text(
                          widget.video.caption,
                          style: GoogleFonts.poppins(
                            fontSize: widget.isWeb ? 16 : 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingPlayer() {
    return Container(
      color: const Color(0xFF1F2937),
      child: const Center(
        child: SpinKitThreeBounce(
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildErrorPlayer() {
    return Container(
      color: const Color(0xFF1F2937),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white54,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'Failed to load video',
              style: GoogleFonts.poppins(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
