class VideoSessionModel {
  final int id;
  final String title;
  final String category;
  final String duration;
  final String imageUrl;
  final String author;
  final String description;
  final String videoUrl;
  final String views;
  bool isFavorite;

  VideoSessionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.imageUrl,
    required this.author,
    required this.description,
    required this.videoUrl,
    required this.views,
    this.isFavorite = false,
  });

  factory VideoSessionModel.fromJson(Map<String, dynamic> json) {
    return VideoSessionModel(
      id: json['id'] as int,
      title: json['title'] as String,
      category: json['category'] as String,
      duration: json['duration'] as String,
      imageUrl: json['imageUrl'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      videoUrl: json['videoUrl'] as String,
      views: json['views'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'duration': duration,
      'imageUrl': imageUrl,
      'author': author,
      'description': description,
      'videoUrl': videoUrl,
      'views': views,
      'isFavorite': isFavorite,
    };
  }
}
