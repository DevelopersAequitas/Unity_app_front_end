import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/usecases/get_nearby_peers_usecase.dart';
import 'near_me_event.dart';
import 'near_me_state.dart';

class NearMeBloc extends Bloc<NearMeEvent, NearMeState> {
  final GetNearbyPeersUseCase getNearbyPeersUseCase;

  NearMeBloc({required this.getNearbyPeersUseCase})
      : super(const NearMeState()) {
    on<NearMeFetchRequested>(_onFetch);
    on<NearMeLoadMoreRequested>(_onLoadMore);
    on<NearMeRadiusChanged>(_onRadiusChanged);
    on<NearMeLocationUpdated>(_onLocationUpdated);
  }

  Future<void> _onFetch(
    NearMeFetchRequested event,
    Emitter<NearMeState> emit,
  ) async {
    emit(state.copyWith(
      status: NearMeStatus.loading,
      page: 1,
      hasMore: true,
      isLoadingMore: false,
    ));
    try {
      double? lat = state.userLatitude;
      double? lng = state.userLongitude;

      if (lat == null || lng == null) {
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
          var permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }
          if (permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always) {
            final pos = await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.medium,
                timeLimit: Duration(seconds: 5),
              ),
            );
            lat = pos.latitude;
            lng = pos.longitude;
          }
        }
      }

      final peers = await getNearbyPeersUseCase(
        page: 1,
        limit: 20,
        radiusKm: state.selectedRadiusKm,
        latitude: lat,
        longitude: lng,
      );

      emit(state.copyWith(
        status: NearMeStatus.success,
        nearbyPeers: peers,
        page: 1,
        hasMore: peers.length >= 20,
        userLatitude: lat,
        userLongitude: lng,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NearMeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMore(
    NearMeLoadMoreRequested event,
    Emitter<NearMeState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore || state.status == NearMeStatus.loading) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.page + 1;
      final morePeers = await getNearbyPeersUseCase(
        page: nextPage,
        limit: 20,
        radiusKm: state.selectedRadiusKm,
        latitude: state.userLatitude,
        longitude: state.userLongitude,
      );

      final existingIds = state.nearbyPeers.map((p) => p.id).toSet();
      final newPeers = morePeers.where((p) => !existingIds.contains(p.id)).toList();
      final updatedList = [...state.nearbyPeers, ...newPeers];

      emit(state.copyWith(
        nearbyPeers: updatedList,
        page: nextPage,
        hasMore: morePeers.length >= 20,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRadiusChanged(
    NearMeRadiusChanged event,
    Emitter<NearMeState> emit,
  ) async {
    emit(state.copyWith(
      selectedRadiusKm: event.radiusKm,
      status: NearMeStatus.loading,
      page: 1,
      hasMore: true,
      isLoadingMore: false,
    ));
    try {
      final peers = await getNearbyPeersUseCase(
        page: 1,
        limit: 20,
        radiusKm: event.radiusKm,
        latitude: state.userLatitude,
        longitude: state.userLongitude,
      );
      emit(state.copyWith(
        status: NearMeStatus.success,
        nearbyPeers: peers,
        page: 1,
        hasMore: peers.length >= 20,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NearMeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onLocationUpdated(
    NearMeLocationUpdated event,
    Emitter<NearMeState> emit,
  ) {
    emit(state.copyWith(
      userLatitude: event.latitude,
      userLongitude: event.longitude,
    ));
    add(const NearMeFetchRequested());
  }
}
