import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../peers/domain/entities/peer_entity.dart';

abstract class AddTestimonialEvent extends Equatable {
  const AddTestimonialEvent();

  @override
  List<Object?> get props => [];
}

class AddTestimonialPeerSearchRequested extends AddTestimonialEvent {
  final String query;

  const AddTestimonialPeerSearchRequested(this.query);

  @override
  List<Object?> get props => [query];
}

class AddTestimonialPeerSelected extends AddTestimonialEvent {
  final PeerEntity? peer;

  const AddTestimonialPeerSelected(this.peer);

  @override
  List<Object?> get props => [peer];
}

class AddTestimonialMessageChanged extends AddTestimonialEvent {
  final String message;

  const AddTestimonialMessageChanged(this.message);

  @override
  List<Object?> get props => [message];
}

class AddTestimonialRatingChanged extends AddTestimonialEvent {
  final int rating;

  const AddTestimonialRatingChanged(this.rating);

  @override
  List<Object?> get props => [rating];
}

class AddTestimonialImageSelected extends AddTestimonialEvent {
  final File? imageFile;

  const AddTestimonialImageSelected(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

class AddTestimonialSubmitted extends AddTestimonialEvent {
  const AddTestimonialSubmitted();
}

class AddTestimonialReset extends AddTestimonialEvent {
  const AddTestimonialReset();
}
