import '../../domain/entities/checkout_session_entity.dart';

class CheckoutSessionModel extends CheckoutSessionEntity {
  const CheckoutSessionModel({
    required super.hostedPageId,
    required super.checkoutUrl,
  });

  factory CheckoutSessionModel.fromJson(Map<String, dynamic> json) {
    return CheckoutSessionModel(
      hostedPageId: json['hostedpage_id']?.toString() ??
          json['hosted_page_id']?.toString() ??
          json['id']?.toString() ??
          '',
      checkoutUrl: json['checkout_url']?.toString() ??
          json['url']?.toString() ??
          json['payment_url']?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hostedpage_id': hostedPageId,
      'checkout_url': checkoutUrl,
    };
  }
}
