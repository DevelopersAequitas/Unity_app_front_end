import 'package:equatable/equatable.dart';
import '../../../peers/domain/entities/peer_entity.dart';
import '../../domain/entities/referral_entity.dart';

enum AddReferralStatus {
  initial,
  submitting,
  success,
  failure,
}

class AddReferralState extends Equatable {
  final AddReferralStatus status;
  final PeerEntity? selectedPeer;
  final String referralType;
  final String referralDate;
  final String referralOf;
  final String phone;
  final String email;
  final String address;
  final int hotValue;
  final String remarks;
  final ReferralEntity? createdReferral;
  final String? errorMessage;

  AddReferralState({
    this.status = AddReferralStatus.initial,
    this.selectedPeer,
    this.referralType = 'b2b_referral',
    String? referralDate,
    this.referralOf = '',
    this.phone = '',
    this.email = '',
    this.address = '',
    this.hotValue = 3,
    this.remarks = '',
    this.createdReferral,
    this.errorMessage,
  }) : referralDate =
            referralDate ?? DateTime.now().toIso8601String().substring(0, 10);

  bool get isValid =>
      selectedPeer != null &&
      referralOf.trim().isNotEmpty &&
      referralDate.trim().isNotEmpty &&
      referralType.trim().isNotEmpty;

  AddReferralState copyWith({
    AddReferralStatus? status,
    PeerEntity? selectedPeer,
    bool clearPeer = false,
    String? referralType,
    String? referralDate,
    String? referralOf,
    String? phone,
    String? email,
    String? address,
    int? hotValue,
    String? remarks,
    ReferralEntity? createdReferral,
    String? errorMessage,
  }) {
    return AddReferralState(
      status: status ?? this.status,
      selectedPeer: clearPeer ? null : (selectedPeer ?? this.selectedPeer),
      referralType: referralType ?? this.referralType,
      referralDate: referralDate ?? this.referralDate,
      referralOf: referralOf ?? this.referralOf,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      hotValue: hotValue ?? this.hotValue,
      remarks: remarks ?? this.remarks,
      createdReferral: createdReferral ?? this.createdReferral,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedPeer,
        referralType,
        referralDate,
        referralOf,
        phone,
        email,
        address,
        hotValue,
        remarks,
        createdReferral,
        errorMessage,
      ];
}
