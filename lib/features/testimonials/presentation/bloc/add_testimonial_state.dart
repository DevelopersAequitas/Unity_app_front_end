import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../peers/domain/entities/peer_entity.dart';
import '../../domain/entities/testimonial_entity.dart';

enum AddTestimonialStatus {
  initial,
  submitting,
  success,
  requiresPro,
  failure,
}

class AddTestimonialState extends Equatable {
  final AddTestimonialStatus status;
  final PeerEntity? selectedPeer;
  final List<PeerEntity> peerSearchResults;
  final bool isSearchingPeers;
  final String message;
  final int rating;
  final File? selectedImage;
  final String? uploadedMediaId;
  final TestimonialEntity? createdTestimonial;
  final String? errorMessage;

  const AddTestimonialState({
    this.status = AddTestimonialStatus.initial,
    this.selectedPeer,
    this.peerSearchResults = const [],
    this.isSearchingPeers = false,
    this.message = '',
    this.rating = 0,
    this.selectedImage,
    this.uploadedMediaId,
    this.createdTestimonial,
    this.errorMessage,
  });

  bool get isValid => selectedPeer != null && message.trim().isNotEmpty;

  AddTestimonialState copyWith({
    AddTestimonialStatus? status,
    PeerEntity? selectedPeer,
    bool clearPeer = false,
    List<PeerEntity>? peerSearchResults,
    bool? isSearchingPeers,
    String? message,
    int? rating,
    File? selectedImage,
    bool clearImage = false,
    String? uploadedMediaId,
    TestimonialEntity? createdTestimonial,
    String? errorMessage,
  }) {
    return AddTestimonialState(
      status: status ?? this.status,
      selectedPeer: clearPeer ? null : (selectedPeer ?? this.selectedPeer),
      peerSearchResults: peerSearchResults ?? this.peerSearchResults,
      isSearchingPeers: isSearchingPeers ?? this.isSearchingPeers,
      message: message ?? this.message,
      rating: rating ?? this.rating,
      selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
      uploadedMediaId: clearImage ? null : (uploadedMediaId ?? this.uploadedMediaId),
      createdTestimonial: createdTestimonial ?? this.createdTestimonial,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedPeer,
        peerSearchResults,
        isSearchingPeers,
        message,
        rating,
        selectedImage,
        uploadedMediaId,
        createdTestimonial,
        errorMessage,
      ];
}
