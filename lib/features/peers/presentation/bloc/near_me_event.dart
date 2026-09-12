import 'package:equatable/equatable.dart';

abstract class NearMeEvent extends Equatable {
  const NearMeEvent();

  @override
  List<Object?> get props => [];
}

class NearMeFetchRequested extends NearMeEvent {
  final bool refresh;
  const NearMeFetchRequested({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class NearMeLoadMoreRequested extends NearMeEvent {
  const NearMeLoadMoreRequested();
}

class NearMeRadiusChanged extends NearMeEvent {
  final double radiusKm;
  const NearMeRadiusChanged(this.radiusKm);

  @override
  List<Object?> get props => [radiusKm];
}

class NearMeLocationUpdated extends NearMeEvent {
  final double latitude;
  final double longitude;
  const NearMeLocationUpdated({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}
