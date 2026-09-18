import '../../domain/entities/vyapaar_jagat_story_status_entity.dart';

class VyapaarJagatStoryStatusModel extends VyapaarJagatStoryStatusEntity {
  const VyapaarJagatStoryStatusModel({
    super.status,
    super.storyLink,
    super.message,
    super.isSubmitted = false,
  });

  factory VyapaarJagatStoryStatusModel.fromJson(Map<String, dynamic> json) {
    final statusVal = (json['status'] ?? json['data']?['status'])?.toString();
    final linkVal = (json['story_link'] ?? json['data']?['story_link'])?.toString();
    final msgVal = (json['message'] ?? json['data']?['message'])?.toString();
    final isSub = json['success'] == true || statusVal != null;

    return VyapaarJagatStoryStatusModel(
      status: statusVal,
      storyLink: linkVal,
      message: msgVal,
      isSubmitted: isSub,
    );
  }
}
