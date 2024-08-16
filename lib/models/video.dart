import 'dart:io';

class Video {
  final String image;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final File? video;

  Video({
    required this.image,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.video,
  });

  // Factory method to create a Video instance from JSON
  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      image: json['image'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      video: json['video'] != null ? File(json['video']) : null,
    );
  }

  // Method to convert Video instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'video': video?.path,
    };
  }
}
