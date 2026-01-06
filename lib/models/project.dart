import 'dart:io';

class Project {
  String id;
  String title;
  String imageUrl;
  double progress;
  String description;
  double budget;
  String category;

  Project({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.progress,
    required this.description,
    required this.budget,
    this.category = '3D',
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    String rawImageUrl = json['image_url'] ?? json['image'] ?? '';
    // Handle relative Laravel paths
    String finalImageUrl = rawImageUrl;
    if (rawImageUrl.isNotEmpty &&
        !rawImageUrl.startsWith('http') &&
        !rawImageUrl.startsWith('/')) {
      final String baseSrv = Platform.isAndroid
          ? '10.0.2.2:8000'
          : '127.0.0.1:8000';
      finalImageUrl = 'http://$baseSrv/storage/$rawImageUrl';
    }

    return Project(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      imageUrl: finalImageUrl,
      progress: 0.0, // Progress removed from UI
      description: json['description'] ?? '',
      budget: parseDouble(json['price'] ?? json['budget']),
      category: json['category'] ?? '3D',
    );
  }

  Map<String, String> toMap() {
    return {
      'title': title,
      'progress': progress.toString(),
      'description': description,
      'price': budget.toInt().toString(),
      'category': category,
    };
  }
}
