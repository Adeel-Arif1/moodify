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

class _TikTokVideoCardState extends State<TikTokVideoCard> with TickerProviderStateMixin {
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
          materialProgressColors: ChewieProgressColors(
            playedColor: const Color(0xFF6366F1),
            handleColor: Colors.white,
            backgroundColor: const Color(0xFF4B5563),
            bufferedColor: const Color(0xFF6B7280),
          ),
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

    return GestureDetector(
      onTap: _isInitialized ? null : _initializeVideo,
      child: Container(
        margin: EdgeInsets.only(bottom: widget.isWeb ? 20 : 16),
        decoration: BoxDecoration(
          color: const Color(0xFF374151), // Dark gray card
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player Section
            Container(
              width: double.infinity,
              height: widget.isWeb ? 400 : 500,
              decoration: const BoxDecoration(
                color: Color(0xFF111827), // Darker video background
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Stack(
                  children: [
                    // Thumbnail or Video Player
                    if (_isInitialized && _chewieController != null)
                      Positioned.fill(
                        child: Chewie(controller: _chewieController!),
                      )
                    else if (_hasError)
                      _buildErrorPlayer()
                    else if (widget.video.thumbnailUrl.isNotEmpty)
                      _buildThumbnail()
                    else
                      _buildLoadingPlayer(),
                    // Gradient Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              const Color(0xFF111827).withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Play Button Overlay
                    if (!_isInitialized && widget.video.thumbnailUrl.isNotEmpty)
                      Center(
                        child: ZoomIn(
                          duration: const Duration(milliseconds: 300),
                          child: IconButton(
                            icon: const Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                              size: 60,
                            ),
                            onPressed: _initializeVideo,
                          ),
                        ),
                      ),
                    // Mood Indicator
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA78BFA).withOpacity(0.9), // Purple badge
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFA78BFA).withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Text(
                          widget.video.mood,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // Right Side Actions
                    Positioned(
                      right: 12,
                      bottom: 20,
                      child: Column(
                        children: [
                          _buildActionButton(
                            icon: isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            iconColor: isLiked
                                ? const Color(0xFFF87171)
                                : Colors.white,
                            label: '${widget.video.likes}',
                            onTap: () =>
                                widget.onLikeToggle(widget.video.id, isLiked),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    // Bottom Info
                    Positioned(
                      left: 12,
                      right: 80,
                      bottom: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: const Color(0xFF6366F1),
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
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
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
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(
          parent: ModalRoute.of(context)!.animation ??
              AnimationController(vsync: this, duration: const Duration(milliseconds: 300)),
          curve: Curves.easeInOut,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF111827).withOpacity(0.5),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
              ),
            ],
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
      ),
    );
  }

  Widget _buildLoadingPlayer() {
    return Container(
      color: const Color(0xFF111827),
      child: const Center(
        child: SpinKitThreeBounce(
          color: Color(0xFF6366F1),
          size: 30,
        ),
      ),
    );
  }

  Widget _buildErrorPlayer() {
    return Container(
      color: const Color(0xFF111827),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Color(0xFF6B7280),
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'Failed to load video',
              style: GoogleFonts.poppins(
                color: const Color(0xFF6B7280),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF6366F1).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Image.network(
              widget.video.thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildErrorPlayer(),
            ),
          ),
        ),
      ],
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