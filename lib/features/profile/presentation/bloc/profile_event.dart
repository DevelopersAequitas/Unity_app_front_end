import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_entity.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileFetchRequested extends ProfileEvent {
  final bool forceRefresh;

  const ProfileFetchRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class ProfileRefreshRequested extends ProfileEvent {
  const ProfileRefreshRequested();
}

class ProfileLocallyUpdated extends ProfileEvent {
  final ProfileEntity updatedProfile;

  const ProfileLocallyUpdated(this.updatedProfile);

  @override
  List<Object?> get props => [updatedProfile];
}
