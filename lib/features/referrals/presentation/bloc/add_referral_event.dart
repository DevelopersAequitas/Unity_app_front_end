import 'package:equatable/equatable.dart';
import '../../../peers/domain/entities/peer_entity.dart';

abstract class AddReferralEvent extends Equatable {
  const AddReferralEvent();

  @override
  List<Object?> get props => [];
}

class AddReferralPeerSelected extends AddReferralEvent {
  final PeerEntity? peer;
  const AddReferralPeerSelected(this.peer);

  @override
  List<Object?> get props => [peer];
}

class AddReferralTypeChanged extends AddReferralEvent {
  final String referralType;
  const AddReferralTypeChanged(this.referralType);

  @override
  List<Object?> get props => [referralType];
}

class AddReferralDateChanged extends AddReferralEvent {
  final String referralDate;
  const AddReferralDateChanged(this.referralDate);

  @override
  List<Object?> get props => [referralDate];
}

class AddReferralOfChanged extends AddReferralEvent {
  final String referralOf;
  const AddReferralOfChanged(this.referralOf);

  @override
  List<Object?> get props => [referralOf];
}

class AddReferralPhoneChanged extends AddReferralEvent {
  final String phone;
  const AddReferralPhoneChanged(this.phone);

  @override
  List<Object?> get props => [phone];
}

class AddReferralEmailChanged extends AddReferralEvent {
  final String email;
  const AddReferralEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class AddReferralAddressChanged extends AddReferralEvent {
  final String address;
  const AddReferralAddressChanged(this.address);

  @override
  List<Object?> get props => [address];
}

class AddReferralHotValueChanged extends AddReferralEvent {
  final int hotValue;
  const AddReferralHotValueChanged(this.hotValue);

  @override
  List<Object?> get props => [hotValue];
}

class AddReferralRemarksChanged extends AddReferralEvent {
  final String remarks;
  const AddReferralRemarksChanged(this.remarks);

  @override
  List<Object?> get props => [remarks];
}

class AddReferralSubmitted extends AddReferralEvent {
  const AddReferralSubmitted();
}

class AddReferralReset extends AddReferralEvent {
  const AddReferralReset();
}
