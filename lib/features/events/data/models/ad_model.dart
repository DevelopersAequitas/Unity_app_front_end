class AdModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String actionUrl;

  const AdModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.actionUrl,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic value) {
      if (value == null) return '';
      final str = value.toString().trim();
      if (str == 'null') return '';
      return str;
    }

    return AdModel(
      id: parseString(json['id'] ?? json['ad_id']),
      title: parseString(json['title']),
      description: parseString(json['description']),
      imageUrl: parseString(json['image_url'] ?? json['image']),
      actionUrl: parseString(json['action_url'] ?? json['link']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'action_url': actionUrl,
    };
  }
}
