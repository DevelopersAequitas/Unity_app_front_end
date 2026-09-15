import 'package:equatable/equatable.dart';

class CheckoutSessionEntity extends Equatable {
  final String hostedPageId;
  final String checkoutUrl;

  const CheckoutSessionEntity({
    required this.hostedPageId,
    required this.checkoutUrl,
  });

  @override
  List<Object?> get props => [hostedPageId, checkoutUrl];
}
