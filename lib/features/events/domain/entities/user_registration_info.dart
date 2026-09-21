import 'package:equatable/equatable.dart';
import '../../../../core/utils/app_date_formatter.dart';

class UserRegistrationInfo extends Equatable {
  final bool isRegistered;
  final String? registrationId;
  final String? status; // 'registered', 'pending_payment', 'requested', 'approved', 'rejected'
  final String? checkinStatus; // 'pending', 'checked_in'
  final String? paymentStatus; // 'paid', 'pending', 'not_required'
  final String? checkoutUrl; // Zoho/Razorpay payment link
  final String? qrCodeUrl; // S3 or backend QR URL
  final String? qrCodeSvg; // SVG string for instant offline rendering
  final String? qrToken; // Raw unique token for QR generation
  final String? eventId;
  final String? occurrenceId;
  final String? attendeeName;
  final String? attendeeEmail;
  final String? attendeePhone;
  final String? ticketPrice;
  final String? currency;
  final DateTime? startAt;
  final String? location;
  final String? eventTitle;

  const UserRegistrationInfo({
    required this.isRegistered,
    this.registrationId,
    this.status,
    this.checkinStatus,
    this.paymentStatus,
    this.checkoutUrl,
    this.qrCodeUrl,
    this.qrCodeSvg,
    this.qrToken,
    this.eventId,
    this.occurrenceId,
    this.attendeeName,
    this.attendeeEmail,
    this.attendeePhone,
    this.ticketPrice,
    this.currency,
    this.startAt,
    this.location,
    this.eventTitle,
  });

  factory UserRegistrationInfo.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status']?.toString();
    final paymentStatus = json['payment_status']?.toString();
    final checkoutUrl = (json['checkout_url'] ??
            json['payment_url'] ??
            json['zoho_payment_link_url'] ??
            json['zoho_checkout_url'])
        ?.toString();

    final isPaymentPending = json['payment_required'] == true ||
        json['requires_payment'] == true ||
        paymentStatus == 'pending' ||
        (checkoutUrl != null && checkoutUrl.isNotEmpty && paymentStatus != 'paid' && paymentStatus != 'not_required');

    final status = (isPaymentPending && paymentStatus != 'paid')
        ? 'pending_payment'
        : rawStatus;

    final isConfirmed = !isPaymentPending &&
        (json['is_registered'] == true ||
            status == 'registered' ||
            status == 'attended' ||
            status == 'confirmed' ||
            paymentStatus == 'paid');

    return UserRegistrationInfo(
      isRegistered: isConfirmed,
      registrationId: (json['registration_id'] ?? json['request_id'] ?? json['id'])?.toString(),
      status: status,
      checkinStatus: json['checkin_status']?.toString(),
      paymentStatus: paymentStatus,
      checkoutUrl: checkoutUrl,
      qrCodeUrl: json['qr_code_url']?.toString(),
      qrCodeSvg: json['qr_code_svg']?.toString(),
      qrToken: json['qr_token']?.toString(),
      eventId: json['event_id']?.toString(),
      occurrenceId: json['occurrence_id']?.toString(),
      attendeeName: (json['attendee_name'] ?? json['visitor_name'] ?? json['user_name'])?.toString(),
      attendeeEmail: (json['email'] ?? json['visitor_email'])?.toString(),
      attendeePhone: (json['phone'] ?? json['visitor_phone'])?.toString(),
      ticketPrice: (json['amount'] ?? json['ticket_price'])?.toString(),
      currency: json['currency']?.toString() ?? 'INR',
      location: (json['location'] ?? json['location_text'])?.toString(),
      eventTitle: (json['event_title'] ?? json['title'])?.toString(),
      startAt: json['start_at'] != null ? AppDateFormatter.parseUtc(json['start_at']) : null,
    );
  }

  UserRegistrationInfo copyWith({
    bool? isRegistered,
    String? registrationId,
    String? status,
    String? checkinStatus,
    String? paymentStatus,
    String? checkoutUrl,
    String? qrCodeUrl,
    String? qrCodeSvg,
    String? qrToken,
    String? eventId,
    String? occurrenceId,
    String? attendeeName,
    String? attendeeEmail,
    String? attendeePhone,
    String? ticketPrice,
    String? currency,
    DateTime? startAt,
    String? location,
    String? eventTitle,
  }) {
    return UserRegistrationInfo(
      isRegistered: isRegistered ?? this.isRegistered,
      registrationId: registrationId ?? this.registrationId,
      status: status ?? this.status,
      checkinStatus: checkinStatus ?? this.checkinStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      checkoutUrl: checkoutUrl ?? this.checkoutUrl,
      qrCodeUrl: qrCodeUrl ?? this.qrCodeUrl,
      qrCodeSvg: qrCodeSvg ?? this.qrCodeSvg,
      qrToken: qrToken ?? this.qrToken,
      eventId: eventId ?? this.eventId,
      occurrenceId: occurrenceId ?? this.occurrenceId,
      attendeeName: attendeeName ?? this.attendeeName,
      attendeeEmail: attendeeEmail ?? this.attendeeEmail,
      attendeePhone: attendeePhone ?? this.attendeePhone,
      ticketPrice: ticketPrice ?? this.ticketPrice,
      currency: currency ?? this.currency,
      startAt: startAt ?? this.startAt,
      location: location ?? this.location,
      eventTitle: eventTitle ?? this.eventTitle,
    );
  }

  @override
  List<Object?> get props => [
        isRegistered,
        registrationId,
        status,
        checkinStatus,
        paymentStatus,
        checkoutUrl,
        qrCodeUrl,
        qrCodeSvg,
        qrToken,
        eventId,
        occurrenceId,
      ];
}
