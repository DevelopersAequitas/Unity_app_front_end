import 'package:equatable/equatable.dart';
import 'testimonial_media_entity.dart';

class TestimonialEntity extends Equatable {
  final String id;
  final String content;
  final String? fromUserId;
  final String? toUserId;
  final String peerName;
  final String? peerPhotoUrl;
  final String? peerDesignation;
  final String? peerCompany;
  final String? peerLocation;
  final String? city;
  final String? category;
  final int? lifeImpactedCount;
  final bool isPro;
  final String? createdAt;
  final double? rating;
  final List<TestimonialMediaEntity> media;
  final int? coinsEarned;
  final int? impactEarned;

  const TestimonialEntity({
    required this.id,
    required this.content,
    this.fromUserId,
    this.toUserId,
    required this.peerName,
    this.peerPhotoUrl,
    this.peerDesignation,
    this.peerCompany,
    this.peerLocation,
    this.city,
    this.category,
    this.lifeImpactedCount,
    this.isPro = false,
    this.createdAt,
    this.rating,
    this.media = const [],
    this.coinsEarned,
    this.impactEarned,
  });

  String get subtitle {
    final des = peerDesignation?.trim() ?? '';
    final comp = peerCompany?.trim() ?? '';
    if (des.isNotEmpty && comp.isNotEmpty) {
      return '$des at $comp';
    } else if (des.isNotEmpty) {
      return des;
    } else if (comp.isNotEmpty) {
      return comp;
    }
    return '';
  }

  String get locationSubtitle {
    final loc = (city ?? peerLocation)?.trim() ?? '';
    if (loc.isNotEmpty) {
      return loc;
    }
    return '';
  }

  @override
  List<Object?> get props => [
        id,
        content,
        fromUserId,
        toUserId,
        peerName,
        peerPhotoUrl,
        peerDesignation,
        peerCompany,
        peerLocation,
        city,
        category,
        lifeImpactedCount,
        isPro,
        createdAt,
        rating,
        media,
        coinsEarned,
        impactEarned,
      ];
}
