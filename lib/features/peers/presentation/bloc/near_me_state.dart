import 'package:equatable/equatable.dart';
import '../../domain/entities/geo_peer_entity.dart';

enum NearMeStatus { initial, loading, success, failure, permissionDenied }

class NearMeState extends Equatable {
  final NearMeStatus status;
  final List<GeoPeerEntity> nearbyPeers;
  final double? selectedRadiusKm;
  final double? userLatitude;
  final double? userLongitude;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final String? errorMessage;

  const NearMeState({
    this.status = NearMeStatus.initial,
    this.nearbyPeers = const [],
    this.selectedRadiusKm,
    this.userLatitude,
    this.userLongitude,
    this.page = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  NearMeState copyWith({
    NearMeStatus? status,
    List<GeoPeerEntity>? nearbyPeers,
    double? selectedRadiusKm,
    double? userLatitude,
    double? userLongitude,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return NearMeState(
      status: status ?? this.status,
      nearbyPeers: nearbyPeers ?? this.nearbyPeers,
      selectedRadiusKm: selectedRadiusKm ?? this.selectedRadiusKm,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        nearbyPeers,
        selectedRadiusKm,
        userLatitude,
        userLongitude,
        page,
        hasMore,
        isLoadingMore,
        errorMessage,
      ];
}
