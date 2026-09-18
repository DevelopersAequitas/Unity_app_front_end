import 'package:equatable/equatable.dart';

class CreateTestimonialParams extends Equatable {
  final String givenToUserId;
  final String message;
  final int? rating;
  final String? mediaId;

  const CreateTestimonialParams({
    required this.givenToUserId,
    required this.message,
    this.rating,
    this.mediaId,
  });

  Map<String, dynamic> toJson() {
    return {
      'given_to_user_id': givenToUserId,
      'message': message,
      'content': message,
      if (rating != null && rating! > 0) 'rating': rating,
      if (mediaId != null && mediaId!.isNotEmpty) 'media_id': mediaId,
    };
  }

  @override
  List<Object?> get props => [givenToUserId, message, rating, mediaId];
}
