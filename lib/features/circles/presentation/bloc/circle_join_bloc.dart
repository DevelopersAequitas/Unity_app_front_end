import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/circle_category_entity.dart';
import '../../domain/usecases/submit_circle_join_usecase.dart';
import 'circle_join_event.dart';
import 'circle_join_state.dart';

class CircleJoinBloc extends Bloc<CircleJoinEvent, CircleJoinState> {
  final SubmitCircleJoinUseCase submitCircleJoinUseCase;

  CircleJoinBloc({
    required this.submitCircleJoinUseCase,
    CircleCategoryEntity? initialCategory,
    bool initialIsOther = false,
  }) : super(CircleJoinState(
          selectedSubcategory: initialCategory,
          isOtherSelected: initialIsOther,
        )) {
    on<CircleJoinSubcategoryUpdated>(_onSubcategoryUpdated);
    on<CircleJoinSubmitted>(_onJoinSubmitted);
  }

  void _onSubcategoryUpdated(
    CircleJoinSubcategoryUpdated event,
    Emitter<CircleJoinState> emit,
  ) {
    emit(state.copyWith(
      selectedSubcategory: event.subcategory,
      isOtherSelected: event.isOther,
      clearSelected: event.isOther,
    ));
  }

  Future<void> _onJoinSubmitted(
    CircleJoinSubmitted event,
    Emitter<CircleJoinState> emit,
  ) async {
    emit(state.copyWith(status: CircleJoinStatus.submitting));
    try {
      final req = await submitCircleJoinUseCase(
        circleId: event.circleId,
        reason: event.reason,
        categoryId: event.defaultSectorId,
        level4CategoryId:
            state.isOtherSelected ? null : state.selectedSubcategory?.id,
        customCategoryName: event.customCategoryName,
      );

      emit(state.copyWith(
        status: CircleJoinStatus.success,
        submittedRequest: req,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CircleJoinStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }
}
