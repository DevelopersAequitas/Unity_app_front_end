import 'package:equatable/equatable.dart';
import '../../domain/entities/circle_category_entity.dart';
import '../../domain/entities/circle_join_request_entity.dart';
import '../../domain/entities/circle_package_entity.dart';

enum CircleJoinStatus { initial, submitting, success, error }

class CircleJoinState extends Equatable {
  final CircleJoinStatus status;
  final CircleCategoryEntity? selectedSubcategory;
  final bool isOtherSelected;
  final CircleJoinRequestEntity? submittedRequest;
  final CirclePackageEntity? packageInfo;
  final bool isPackageLoading;
  final String? errorMessage;

  const CircleJoinState({
    this.status = CircleJoinStatus.initial,
    this.selectedSubcategory,
    this.isOtherSelected = false,
    this.submittedRequest,
    this.packageInfo,
    this.isPackageLoading = false,
    this.errorMessage,
  });

  bool get hasValidSelection => selectedSubcategory != null || isOtherSelected;

  CircleJoinState copyWith({
    CircleJoinStatus? status,
    CircleCategoryEntity? selectedSubcategory,
    bool? isOtherSelected,
    CircleJoinRequestEntity? submittedRequest,
    CirclePackageEntity? packageInfo,
    bool? isPackageLoading,
    String? errorMessage,
    bool clearSelected = false,
  }) {
    return CircleJoinState(
      status: status ?? this.status,
      selectedSubcategory: clearSelected
          ? null
          : (selectedSubcategory ?? this.selectedSubcategory),
      isOtherSelected: isOtherSelected ?? this.isOtherSelected,
      submittedRequest: submittedRequest ?? this.submittedRequest,
      packageInfo: packageInfo ?? this.packageInfo,
      isPackageLoading: isPackageLoading ?? this.isPackageLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedSubcategory,
        isOtherSelected,
        submittedRequest,
        packageInfo,
        isPackageLoading,
        errorMessage,
      ];
}
