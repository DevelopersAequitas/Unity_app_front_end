import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_partner_with_us_submissions_usecase.dart';
import '../../../domain/usecases/submit_partner_with_us_usecase.dart';
import 'partner_with_us_event.dart';
import 'partner_with_us_state.dart';

class PartnerWithUsBloc extends Bloc<PartnerWithUsEvent, PartnerWithUsState> {
  final SubmitPartnerWithUsUseCase submitPartnerWithUsUseCase;
  final GetPartnerWithUsSubmissionsUseCase getPartnerWithUsSubmissionsUseCase;

  PartnerWithUsBloc({
    required this.submitPartnerWithUsUseCase,
    required this.getPartnerWithUsSubmissionsUseCase,
  }) : super(const PartnerWithUsState()) {
    on<FetchPartnerWithUsHistoryEvent>(_onFetchHistory);
    on<SubmitPartnerWithUsEvent>(_onSubmitApplication);
    on<ResetPartnerWithUsStateEvent>(_onResetState);
  }

  Future<void> _onFetchHistory(
    FetchPartnerWithUsHistoryEvent event,
    Emitter<PartnerWithUsState> emit,
  ) async {
    emit(state.copyWith(status: PartnerWithUsStatus.loading));
    try {
      final list = await getPartnerWithUsSubmissionsUseCase();
      emit(state.copyWith(
        status: PartnerWithUsStatus.success,
        submissions: list,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PartnerWithUsStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onSubmitApplication(
    SubmitPartnerWithUsEvent event,
    Emitter<PartnerWithUsState> emit,
  ) async {
    emit(state.copyWith(status: PartnerWithUsStatus.submitting));
    try {
      final msg = await submitPartnerWithUsUseCase(event.entity);
      emit(state.copyWith(
        status: PartnerWithUsStatus.success,
        successMessage: msg,
      ));
      add(const FetchPartnerWithUsHistoryEvent());
    } catch (e) {
      emit(state.copyWith(
        status: PartnerWithUsStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  void _onResetState(
    ResetPartnerWithUsStateEvent event,
    Emitter<PartnerWithUsState> emit,
  ) {
    emit(state.copyWith(
      status: PartnerWithUsStatus.initial,
      errorMessage: null,
      successMessage: null,
    ));
  }
}
