import 'package:equatable/equatable.dart';

class PostReportReasonEntity extends Equatable {
  final int id;
  final String title;
  final int? sortOrder;

  const PostReportReasonEntity({
    required this.id,
    required this.title,
    this.sortOrder,
  });

  factory PostReportReasonEntity.fromJson(Map<String, dynamic> json) {
    return PostReportReasonEntity(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? '',
      sortOrder: json['sort_order'] is int
          ? json['sort_order'] as int
          : int.tryParse(json['sort_order']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (sortOrder != null) 'sort_order': sortOrder,
    };
  }

  @override
  List<Object?> get props => [id, title, sortOrder];
}
