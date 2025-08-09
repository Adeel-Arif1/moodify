import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String caption;
  final String uploaderId;
  final String uploaderName;
  final String uploaderEmail;
  final String mood;
  final int likes;
  final List<String> likedBy;
  final int views;
  final DateTime uploadedAt;

  VideoModel({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.caption,
    required this.uploaderId,
    required this.uploaderName,
    required this.uploaderEmail,
    required this.mood,
    required this.likes,
    required this.likedBy,
    required this.views,
    required this.uploadedAt,
  });

  factory VideoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VideoModel(
      id: doc.id,
      videoUrl: data['videoUrl'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      caption: data['caption'] ?? '',
      uploaderId: data['uploaderId'] ?? '',
      uploaderName: data['uploaderName'] ?? '',
      uploaderEmail: data['uploaderEmail'] ?? '',
      mood: data['mood'] ?? 'General',
      likes: data['likes'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      views: data['views'] ?? 0,
      uploadedAt: (data['uploadedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  VideoModel copyWith({
    String? id,
    String? videoUrl,
    String? thumbnailUrl,
    String? caption,
    String? uploaderId,
    String? uploaderName,
    String? uploaderEmail,
    String? mood,
    int? likes,
    List<String>? likedBy,
    int? views,
    DateTime? uploadedAt,
  }) {
    return VideoModel(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      caption: caption ?? this.caption,
      uploaderId: uploaderId ?? this.uploaderId,
      uploaderName: uploaderName ?? this.uploaderName,
      uploaderEmail: uploaderEmail ?? this.uploaderEmail,
      mood: mood ?? this.mood,
      likes: likes ?? this.likes,
      likedBy: likedBy ?? this.likedBy,
      views: views ?? this.views,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}