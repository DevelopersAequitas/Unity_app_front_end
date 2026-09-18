import 'package:equatable/equatable.dart';
import '../../../peers/domain/entities/peer_entity.dart';
import '../../domain/entities/business_deal_entity.dart';

enum AddBusinessDealStatus {
  initial,
  submitting,
  success,
  requiresPro,
  failure,
}

class AddBusinessDealState extends Equatable {
  final AddBusinessDealStatus status;
  final PeerEntity? selectedPeer;
  final String amount;
  final String businessType; // 'new' or 'repeat'
  final String dealDate; // 'YYYY-MM-DD'
  final String comment;
  final String? referralId;
  final BusinessDealEntity? createdDeal;
  final String? errorMessage;

  AddBusinessDealState({
    this.status = AddBusinessDealStatus.initial,
    this.selectedPeer,
    this.amount = '',
    this.businessType = 'new',
    String? dealDate,
    this.comment = '',
    this.referralId,
    this.createdDeal,
    this.errorMessage,
  }) : dealDate = dealDate ?? DateTime.now().toIso8601String().substring(0, 10);

  double get parsedAmount => double.tryParse(amount.replaceAll(',', '').trim()) ?? 0.0;

  bool get isValid =>
      selectedPeer != null &&
      parsedAmount > 0 &&
      dealDate.trim().isNotEmpty &&
      businessType.trim().isNotEmpty;

  AddBusinessDealState copyWith({
    AddBusinessDealStatus? status,
    PeerEntity? selectedPeer,
    bool clearPeer = false,
    String? amount,
    String? businessType,
    String? dealDate,
    String? comment,
    String? referralId,
    bool clearReferralId = false,
    BusinessDealEntity? createdDeal,
    String? errorMessage,
  }) {
    return AddBusinessDealState(
      status: status ?? this.status,
      selectedPeer: clearPeer ? null : (selectedPeer ?? this.selectedPeer),
      amount: amount ?? this.amount,
      businessType: businessType ?? this.businessType,
      dealDate: dealDate ?? this.dealDate,
      comment: comment ?? this.comment,
      referralId: clearReferralId ? null : (referralId ?? this.referralId),
      createdDeal: createdDeal ?? this.createdDeal,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedPeer,
        amount,
        businessType,
        dealDate,
        comment,
        referralId,
        createdDeal,
        errorMessage,
      ];
}
