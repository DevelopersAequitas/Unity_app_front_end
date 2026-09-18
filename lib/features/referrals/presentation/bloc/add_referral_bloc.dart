import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/create_referral_params.dart';
import '../../domain/usecases/create_referral_usecase.dart';
import 'add_referral_event.dart';
import 'add_referral_state.dart';

class AddReferralBloc extends Bloc<AddReferralEvent, AddReferralState> {
  final CreateReferralUseCase createReferralUseCase;

  AddReferralBloc({
    required this.createReferralUseCase,
  }) : super(AddReferralState()) {
    on<AddReferralPeerSelected>((event, emit) {
      emit(state.copyWith(
        selectedPeer: event.peer,
        clearPeer: event.peer == null,
      ));
    });

    on<AddReferralTypeChanged>((event, emit) {
      emit(state.copyWith(referralType: event.referralType));
    });

    on<AddReferralDateChanged>((event, emit) {
      emit(state.copyWith(referralDate: event.referralDate));
    });

    on<AddReferralOfChanged>((event, emit) {
      emit(state.copyWith(referralOf: event.referralOf));
    });

    on<AddReferralPhoneChanged>((event, emit) {
      emit(state.copyWith(phone: event.phone));
    });

    on<AddReferralEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<AddReferralAddressChanged>((event, emit) {
      emit(state.copyWith(address: event.address));
    });

    on<AddReferralHotValueChanged>((event, emit) {
      emit(state.copyWith(hotValue: event.hotValue));
    });

    on<AddReferralRemarksChanged>((event, emit) {
      emit(state.copyWith(remarks: event.remarks));
    });

    on<AddReferralSubmitted>(_onSubmitted);

    on<AddReferralReset>((event, emit) {
      emit(AddReferralState());
    });
  }

  Future<void> _onSubmitted(
    AddReferralSubmitted event,
    Emitter<AddReferralState> emit,
  ) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: AddReferralStatus.submitting));

    try {
      final params = CreateReferralParams(
        toUserId: state.selectedPeer!.id,
        referralType: state.referralType,
        referralDate: state.referralDate,
        referralOf: state.referralOf,
        phone: state.phone,
        email: state.email,
        address: state.address,
        hotValue: state.hotValue,
        remarks: state.remarks,
      );

      final result = await createReferralUseCase(params);

      emit(state.copyWith(
        status: AddReferralStatus.success,
        createdReferral: result,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AddReferralStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
