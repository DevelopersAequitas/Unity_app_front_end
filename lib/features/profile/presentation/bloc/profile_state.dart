import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_entity.dart';
import '../utils/profile_completeness_calculator.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileEntity? profile;
  final ProfileCompletenessResult completeness;
  final String? errorMessage;
  final bool isRefreshing;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.completeness = const ProfileCompletenessResult(
      overallPercentage: 0,
      personalPercentage: 0,
      businessPercentage: 0,
      professionalPercentage: 0,
      interestsPercentage: 0,
      socialPercentage: 0,
      mediaPercentage: 0,
      circlePercentage: 0,
      additionalPercentage: 0,
    ),
    this.errorMessage,
    this.isRefreshing = false,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profile,
    ProfileCompletenessResult? completeness,
    String? errorMessage,
    bool? isRefreshing,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      completeness: completeness ?? this.completeness,
      errorMessage: errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [status, profile, completeness, errorMessage, isRefreshing];
}
