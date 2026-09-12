import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../utils/profile_completeness_calculator.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;

  ProfileBloc({required this.getProfileUseCase}) : super(const ProfileState()) {
    on<ProfileFetchRequested>(_onFetchRequested);
    on<ProfileRefreshRequested>(_onRefreshRequested);
    on<ProfileLocallyUpdated>(_onLocallyUpdated);
  }

  Future<void> _onFetchRequested(
    ProfileFetchRequested event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.profile == null) {
      emit(state.copyWith(status: ProfileStatus.loading));
    }
    try {
      final profile = await getProfileUseCase(forceRefresh: event.forceRefresh);
      final completeness = ProfileCompletenessCalculator.calculate(profile);
      emit(state.copyWith(
        status: ProfileStatus.success,
        profile: profile,
        completeness: completeness,
        errorMessage: null,
      ));
    } catch (e) {
      if (state.profile != null) {
        emit(state.copyWith(errorMessage: e.toString()));
      } else {
        emit(state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  Future<void> _onRefreshRequested(
    ProfileRefreshRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true));
    try {
      final profile = await getProfileUseCase(forceRefresh: true);
      final completeness = ProfileCompletenessCalculator.calculate(profile);
      emit(state.copyWith(
        status: ProfileStatus.success,
        profile: profile,
        completeness: completeness,
        isRefreshing: false,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isRefreshing: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onLocallyUpdated(
    ProfileLocallyUpdated event,
    Emitter<ProfileState> emit,
  ) {
    final completeness = ProfileCompletenessCalculator.calculate(event.updatedProfile);
    emit(state.copyWith(
      status: ProfileStatus.success,
      profile: event.updatedProfile,
      completeness: completeness,
      errorMessage: null,
    ));
  }
}
