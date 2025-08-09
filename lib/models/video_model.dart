// video_model.dart (Updated)
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String id;

  final String caption;
  final String videoUrl;
  final String thumbnailUrl;
  final String uploaderName;
  final String uploaderEmail;
  final DateTime uploadedAt;
  final int views;
  final int likes;
  final List<String> likedBy;

  VideoModel({
    required this.id,
    required this.caption,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.uploaderName,
    required this.uploaderEmail,
    required this.uploadedAt,
    this.views = 0,
    this.likes = 0,
    this.likedBy = const [],
  });

  factory VideoModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return VideoModel(
      id: doc.id,
      caption: data['caption'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      uploaderName: data['uploaderName'] ?? '',
      uploaderEmail: data['uploaderEmail'] ?? '',
      uploadedAt:
          (data['uploadedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      views: data['views'] ?? 0,
      likes: data['likes'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
    );
  }
}
