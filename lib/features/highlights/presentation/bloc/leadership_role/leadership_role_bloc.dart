import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/submit_leadership_interest_usecase.dart';
import 'leadership_role_event.dart';
import 'leadership_role_state.dart';

class LeadershipRoleBloc extends Bloc<LeadershipRoleEvent, LeadershipRoleState> {
  final SubmitLeadershipInterestUseCase submitLeadershipInterestUseCase;

  LeadershipRoleBloc({required this.submitLeadershipInterestUseCase})
      : super(const LeadershipRoleState()) {
    on<SubmitLeadershipRoleInterestEvent>(_onSubmitInterest);
  }

  Future<void> _onSubmitInterest(
    SubmitLeadershipRoleInterestEvent event,
    Emitter<LeadershipRoleState> emit,
  ) async {
    emit(state.copyWith(status: LeadershipRoleStatus.submitting));
    try {
      await submitLeadershipInterestUseCase(event.interest);
      emit(state.copyWith(
        status: LeadershipRoleStatus.success,
        successMessage: 'Leadership application submitted successfully!',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LeadershipRoleStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
