import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/event_registration_entity.dart';

class EventRegistrationModel extends EventRegistrationEntity {
  const EventRegistrationModel({
    required super.registrationId,
    super.eventId,
    super.occurrenceId,
    super.eventTitle,
    super.startAt,
    super.endAt,
    super.location,
    super.status = 'confirmed',
    super.paymentRequired = false,
    super.paymentStatus,
    super.paymentGateway,
    super.paymentUrl,
    super.checkoutUrl,
    super.razorpayOrderId,
    super.qrCodeUrl,
    super.qrToken,
    super.attendeeName,
    super.attendeeEmail,
    super.attendeePhone,
    super.attendeeCompany,
    super.attendeeDesignation,
    super.ticketPrice,
    super.currency,
    super.zohoInvoiceNumber,
    super.invoicePdfUrl,
  });

  factory EventRegistrationModel.fromJson(Map<String, dynamic> json) {
    final registrationId = (json['registration_id'] ?? json['id'] ?? '').toString();
    final eventId = json['event_id']?.toString();
    final occurrenceId = json['occurrence_id']?.toString();
    final eventTitle = json['event_title']?.toString() ?? json['title']?.toString();

    final startAt = AppDateFormatter.parseUtc(json['start_at'] ?? json['start_date']);
    final endAt = AppDateFormatter.parseUtc(json['end_at'] ?? json['end_date']);
    final location = json['location']?.toString() ?? json['location_text']?.toString();

    final isPaidFlag = json['is_paid'] == true ||
        json['is_paid'] == 1 ||
        json['paid'] == true ||
        json['payment_status']?.toString().toLowerCase() == 'paid' ||
        json['payment_status']?.toString().toLowerCase() == 'success' ||
        json['status']?.toString().toLowerCase() == 'paid';

    final effectivePaymentStatus = isPaidFlag ? 'paid' : json['payment_status']?.toString();
    final paymentGateway = json['payment_gateway']?.toString();
    final paymentUrl = json['payment_url']?.toString() ??
        json['checkout_url']?.toString() ??
        json['zoho_checkout_url']?.toString() ??
        json['zoho_payment_link_url']?.toString();
    final checkoutUrl = json['checkout_url']?.toString() ??
        json['payment_url']?.toString() ??
        json['zoho_payment_link_url']?.toString() ??
        json['zoho_checkout_url']?.toString();
    final razorpayOrderId = json['razorpay_order_id']?.toString();

    final paymentRequired = !isPaidFlag &&
        (json['payment_required'] == true ||
            json['requires_payment'] == true ||
            effectivePaymentStatus == 'pending' ||
            (checkoutUrl != null &&
                checkoutUrl.isNotEmpty &&
                effectivePaymentStatus != 'paid' &&
                effectivePaymentStatus != 'not_required'));

    final rawStatus = json['status'];
    String status;
    if (isPaidFlag) {
      status = 'confirmed';
    } else if (paymentRequired && (effectivePaymentStatus == 'pending' || effectivePaymentStatus != 'paid') && checkoutUrl != null && checkoutUrl.isNotEmpty) {
      status = 'pending_payment';
    } else if (rawStatus is bool) {
      status = rawStatus ? 'confirmed' : 'pending_approval';
    } else if (rawStatus is String) {
      final s = rawStatus.toLowerCase();
      if (s == 'true' || s == 'confirmed' || s == 'registered' || s == 'attended' || s == 'completed' || s == 'paid') {
        status = paymentRequired && effectivePaymentStatus != 'paid' ? 'pending_payment' : 'confirmed';
      } else if (s == 'false' || s == 'pending' || s == 'pending_approval' || s == 'requested') {
        status = 'pending_approval';
      } else {
        status = s;
      }
    } else {
      final requestStatus = json['request_status']?.toString();
      final isRequestRequired = json['request_required'] == true;
      status = (requestStatus != null && requestStatus != 'not_requested')
          ? 'pending_approval'
          : (isRequestRequired ? 'pending_approval' : (paymentRequired ? 'pending_payment' : 'confirmed'));
    }

    final qrCodeUrl = json['qr_code_url']?.toString();
    final qrToken = json['qr_token']?.toString();

    final attendeeName = json['attendee_name']?.toString() ??
        json['visitor_name']?.toString() ??
        json['user_name']?.toString();
    final attendeeEmail = json['email']?.toString() ?? json['visitor_email']?.toString();
    final attendeePhone = json['phone']?.toString() ?? json['visitor_phone']?.toString();
    final attendeeCompany = json['visitor_company']?.toString() ?? json['company_name']?.toString();
    final attendeeDesignation = json['visitor_designation']?.toString() ?? json['designation']?.toString();

    final ticketPrice = json['amount']?.toString() ?? json['ticket_price']?.toString();
    final currency = json['currency']?.toString() ?? 'INR';

    final zohoInvoiceNumber = json['zoho_invoice_number']?.toString();
    final invoicePdfUrl = json['zoho_invoice_pdf_url']?.toString() ?? json['invoice_pdf_url']?.toString();

    return EventRegistrationModel(
      registrationId: registrationId,
      eventId: eventId,
      occurrenceId: occurrenceId,
      eventTitle: eventTitle,
      startAt: startAt,
      endAt: endAt,
      location: location,
      status: status,
      paymentRequired: paymentRequired,
      paymentStatus: effectivePaymentStatus,
      paymentGateway: paymentGateway,
      paymentUrl: paymentUrl,
      checkoutUrl: checkoutUrl,
      razorpayOrderId: razorpayOrderId,
      qrCodeUrl: qrCodeUrl,
      qrToken: qrToken,
      attendeeName: attendeeName,
      attendeeEmail: attendeeEmail,
      attendeePhone: attendeePhone,
      attendeeCompany: attendeeCompany,
      attendeeDesignation: attendeeDesignation,
      ticketPrice: ticketPrice,
      currency: currency,
      zohoInvoiceNumber: zohoInvoiceNumber,
      invoicePdfUrl: invoicePdfUrl,
    );
  }
}
