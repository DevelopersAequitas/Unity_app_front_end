import 'package:equatable/equatable.dart';

class EventRegistrationEntity extends Equatable {
  final String registrationId;
  final String? eventId;
  final String? occurrenceId;
  final String? eventTitle;
  final DateTime? startAt;
  final DateTime? endAt;
  final String? location;
  final String status; // 'confirmed', 'pending_payment', 'pending', 'rejected', 'checked_in'
  final bool paymentRequired;
  final String? paymentStatus; // 'paid', 'pending', 'failed'
  final String? paymentGateway;
  final String? paymentUrl;
  final String? checkoutUrl;
  final String? razorpayOrderId;
  final String? qrCodeUrl;
  final String? qrToken;
  final String? attendeeName;
  final String? attendeeEmail;
  final String? attendeePhone;
  final String? attendeeCompany;
  final String? attendeeDesignation;
  final String? ticketPrice;
  final String? currency;
  final String? zohoInvoiceNumber;
  final String? invoicePdfUrl;

  const EventRegistrationEntity({
    required this.registrationId,
    this.eventId,
    this.occurrenceId,
    this.eventTitle,
    this.startAt,
    this.endAt,
    this.location,
    this.status = 'confirmed',
    this.paymentRequired = false,
    this.paymentStatus,
    this.paymentGateway,
    this.paymentUrl,
    this.checkoutUrl,
    this.razorpayOrderId,
    this.qrCodeUrl,
    this.qrToken,
    this.attendeeName,
    this.attendeeEmail,
    this.attendeePhone,
    this.attendeeCompany,
    this.attendeeDesignation,
    this.ticketPrice,
    this.currency,
    this.zohoInvoiceNumber,
    this.invoicePdfUrl,
  });

  bool get isConfirmed =>
      status == 'confirmed' ||
      status == 'checked_in' ||
      status == 'registered' ||
      status == 'true' ||
      status == 'completed' ||
      status == 'attended';
  bool get isPendingPayment => status == 'pending_payment' || paymentStatus == 'pending';
  bool get isPendingApproval =>
      status == 'pending' ||
      status == 'pending_approval' ||
      status == 'pending_admin_approval' ||
      status == 'requested' ||
      status == 'false' ||
      status == 'pending_request';

  @override
  List<Object?> get props => [
        registrationId,
        eventId,
        occurrenceId,
        eventTitle,
        startAt,
        status,
        paymentRequired,
        paymentStatus,
        paymentUrl,
        qrCodeUrl,
        qrToken,
      ];
}
