import 'package:equatable/equatable.dart';
import '../../domain/entities/circle_category_entity.dart';
import '../../domain/entities/circle_join_request_entity.dart';

enum CircleJoinStatus { initial, submitting, success, error }

class CircleJoinState extends Equatable {
  final CircleJoinStatus status;
  final CircleCategoryEntity? selectedSubcategory;
  final bool isOtherSelected;
  final CircleJoinRequestEntity? submittedRequest;
  final String? errorMessage;

  const CircleJoinState({
    this.status = CircleJoinStatus.initial,
    this.selectedSubcategory,
    this.isOtherSelected = false,
    this.submittedRequest,
    this.errorMessage,
  });

  bool get hasValidSelection => selectedSubcategory != null || isOtherSelected;

  CircleJoinState copyWith({
    CircleJoinStatus? status,
    CircleCategoryEntity? selectedSubcategory,
    bool? isOtherSelected,
    CircleJoinRequestEntity? submittedRequest,
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
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedSubcategory,
        isOtherSelected,
        submittedRequest,
        errorMessage,
      ];
}
