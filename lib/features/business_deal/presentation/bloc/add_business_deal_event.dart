import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../peers/domain/entities/peer_entity.dart';

abstract class AddBusinessDealEvent extends Equatable {
  const AddBusinessDealEvent();

  @override
  List<Object?> get props => [];
}

class AddBusinessDealPeerSelected extends AddBusinessDealEvent {
  final PeerEntity? peer;

  const AddBusinessDealPeerSelected(this.peer);

  @override
  List<Object?> get props => [peer];
}

class AddBusinessDealAmountChanged extends AddBusinessDealEvent {
  final String amount;

  const AddBusinessDealAmountChanged(this.amount);

  @override
  List<Object?> get props => [amount];
}

class AddBusinessDealTypeChanged extends AddBusinessDealEvent {
  final String businessType; // 'new' or 'repeat'

  const AddBusinessDealTypeChanged(this.businessType);

  @override
  List<Object?> get props => [businessType];
}

class AddBusinessDealDateChanged extends AddBusinessDealEvent {
  final String dealDate; // 'YYYY-MM-DD'

  const AddBusinessDealDateChanged(this.dealDate);

  @override
  List<Object?> get props => [dealDate];
}

class AddBusinessDealCommentChanged extends AddBusinessDealEvent {
  final String comment;

  const AddBusinessDealCommentChanged(this.comment);

  @override
  List<Object?> get props => [comment];
}

class AddBusinessDealReferralIdChanged extends AddBusinessDealEvent {
  final String? referralId;

  const AddBusinessDealReferralIdChanged(this.referralId);

  @override
  List<Object?> get props => [referralId];
}

class AddBusinessDealSubmitted extends AddBusinessDealEvent {
  final File? creativeImage;
  const AddBusinessDealSubmitted({this.creativeImage});

  @override
  List<Object?> get props => [creativeImage];
}

class AddBusinessDealReset extends AddBusinessDealEvent {
  const AddBusinessDealReset();
}
