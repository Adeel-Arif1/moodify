import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String caption;
  final String uploaderId;
  final String uploaderName;
  final String mood;
  final int likes;
  final List<String> likedBy;
  final DateTime uploadedAt;

  VideoModel({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.caption,
    required this.uploaderId,
    required this.uploaderName,
    required this.mood,
    required this.likes,
    required this.likedBy,
    required this.uploadedAt,
  });

  factory VideoModel.fromJson(String id, Map<String, dynamic> json) {
    return VideoModel(
      id: id,
      videoUrl: json['videoUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      caption: json['caption'] ?? '',
      uploaderId: json['uploaderId'] ?? '',
      uploaderName: json['uploaderName'] ?? '',
      mood: json['mood'] ?? 'General',
      likes: json['likes'] ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
      uploadedAt: (json['uploadedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  VideoModel copyWith({
    String? id,
    String? videoUrl,
    String? thumbnailUrl,
    String? caption,
    String? uploaderId,
    String? uploaderName,
    String? mood,
    int? likes,
    List<String>? likedBy,
    DateTime? uploadedAt,
  }) {
    return VideoModel(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      caption: caption ?? this.caption,
      uploaderId: uploaderId ?? this.uploaderId,
      uploaderName: uploaderName ?? this.uploaderName,
      mood: mood ?? this.mood,
      likes: likes ?? this.likes,
      likedBy: likedBy ?? this.likedBy,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}