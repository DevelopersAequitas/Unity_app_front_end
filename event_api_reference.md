# Event API Reference

All routes are prefixed with `/api/v1`. Auth-guarded routes require a **Sanctum Bearer token** (`Authorization: Bearer {token}`).

---

## 1. Public / No-Auth Routes

### GET `/api/v1/events/all`
**Controller:** `EventApiController@allEvents`  
**Auth:** None (public)  
**Query Params:**
| Param | Type | Values |
|---|---|---|
| `circle_id` | uuid (optional) | filter by circle |
| `status` | string (optional) | `all` _(default)_, `today`, `live`, `upcoming` |

**Response `200`:**
```json
{
  "success": true,
  "message": "Circle events fetched successfully.",
  "data": {
    "circle": null,
    "server_now": "2026-09-21T05:30:00+00:00",
    "app_timezone": "Asia/Kolkata",
    "total": 3,
    "today_events": [
      {
        "event_id": "uuid",
        "occurrence_id": "uuid",
        "title": "Morning Business Breakfast",
        "description": "...",
        "event_type": "chapter_event",
        "event_category": "networking",
        "mode": "in_person",
        "start_at": "2026-09-21T09:00:00.000000Z",
        "end_at": "2026-09-21T11:00:00.000000Z",
        "formatted_start_at": "21 Sep 2026 09:00 AM",
        "recurrence": "weekly",
        "status": "scheduled",
        "registered_count": 42,
        "checked_in_count": 10,
        "image_url": "https://example.com/banner.jpg",
        "location": "Hotel Grand, Mumbai",
        "meeting_link": null,
        "circle_id": "uuid",
        "circle_ids": ["uuid"],
        "circles": [
          { "id": "uuid", "name": "Mumbai West", "slug": "mumbai-west", "state_name": "Maharashtra" }
        ],
        "circle": { "id": "uuid", "name": "Mumbai West", "slug": "mumbai-west", "state_name": "Maharashtra" },
        "group_status": "today"
      }
    ],
    "live_events": [
      { "...(same shape as above)...", "group_status": "live" }
    ],
    "upcoming_events": [
      { "...(same shape as above)...", "group_status": "upcoming" }
    ]
  }
}
```

---

### GET `/api/v1/events/checkin/qr/{qr_token}`
**Controller:** `EventController@checkinQr`  
**Auth:** None  

**Response `200`:**
```json
{
  "success": true,
  "message": "QR token resolved successfully.",
  "data": {
    "qr_token": "abc123xyz"
  }
}
```

---

### GET `/api/v1/public/events/{event_id}/occurrences/{occurrence_id}`
**Controller:** `EventController@publicOccurrence`  
**Auth:** None | Rate limit: 60/min  

**Response `200`:**
```json
{
  "success": true,
  "message": "Public event fetched successfully.",
  "data": {
    "event_id": "uuid",
    "occurrence_id": "uuid",
    "title": "Global Summit 2026",
    "description": "Annual networking summit for business leaders.",
    "start_at": "2026-10-01T09:00:00.000000Z",
    "end_at": "2026-10-01T18:00:00.000000Z",
    "location_text": "NSCI Dome, Mumbai",
    "mode": "in_person",
    "online_meeting_url": null,
    "is_paid": true,
    "ticket_price": "1500.00",
    "currency": "INR",
    "visitor_registration_enabled": true
  }
}
```

**Error `403`:**
```json
{
  "success": false,
  "message": "Event is not available for public registration."
}
```

---

### GET `/api/v1/public/events/{event_id}/occurrences/{occurrence_id}/registration-form`
**Controller:** `EventController@publicRegistrationForm`  
**Auth:** None | Rate limit: 60/min  

**Response `200`:**
```json
{
  "success": true,
  "message": "Public event registration form fetched successfully.",
  "data": {
    "event": {
      "id": "uuid",
      "title": "Global Summit 2026",
      "name": "Global Summit 2026",
      "description": "...",
      "basic_details": {
        "event_type": "global_event",
        "event_category": "summit",
        "mode": "in_person",
        "circle": { "id": "uuid", "name": "Mumbai West" }
      },
      "start_at": "2026-10-01T09:00:00.000000Z",
      "end_at": "2026-10-01T18:00:00.000000Z",
      "location_text": "NSCI Dome, Mumbai",
      "mode": "in_person",
      "online_meeting_url": null,
      "is_paid": true,
      "ticket_price": "1500.00",
      "currency": "INR",
      "visitor_registration_enabled": true
    },
    "occurrence": {
      "id": "uuid",
      "event_id": "uuid",
      "occurrence_date": "2026-10-01",
      "start_at": "2026-10-01T09:00:00.000000Z",
      "end_at": "2026-10-01T18:00:00.000000Z",
      "status": "scheduled",
      "sequence": 1,
      "registration_limit": 200,
      "registered_count": 42,
      "metadata": null
    },
    "categories": {
      "main": [
        { "id": "uuid", "name": "IT & Technology" },
        { "id": "uuid", "name": "Healthcare" }
      ],
      "sub": [
        { "id": "uuid", "name": "Software Development" }
      ]
    },
    "submit_url": "https://example.com/api/v1/public/events/uuid/occurrences/uuid/register",
    "web_form_url": "https://example.com/events/uuid/occurrences/uuid/visitor-register"
  }
}
```

---

### POST `/api/v1/public/events/{event_id}/occurrences/{occurrence_id}/register`
**Controller:** `EventController@publicRegister`  
**Auth:** None | Rate limit: 60/min  
**Body:** *(same as visitor-register below)*

**Response `201`:** *(same as payment response payload — see Visitor Register section)*

---

## 2. Auth-Optional Routes

### GET `/api/v1/event-qrcodes/{eventId}/{filename}`
**Controller:** `EventQrCodeController@show`  
Serves the actual QR code image file.

---

## 3. Auth-Required Routes (`auth:sanctum`)

### POST `/api/v1/events/checkin/scan`
**Controller:** `EventController@scan`  
**Body:**
```json
{
  "qr_token": "abc123xyz",
  "force": false,
  "device_info": { "device_model": "Pixel 7", "os_version": "Android 14" }
}
```

**Response (member scan) `200`:**
```json
{
  "success": true,
  "message": "Attendance marked successfully.",
  "data": {
    "id": "uuid",
    "event_id": "uuid",
    "occurrence_id": "uuid",
    "user_id": "uuid",
    "status": "confirmed",
    "checkin_status": "checked_in",
    "checked_in_at": "2026-09-21T10:00:00.000000Z",
    "qr_code_url": "https://...",
    "payment_status": "paid"
  }
}
```

**Error `401`:**
```json
{ "success": false, "message": "Unauthenticated." }
```

---

### POST `/api/v1/events/{event}/occurrences/{occurrence}/register`
**Controller:** `EventController@register`  
**Middleware:** `unity.user`  
**Body:**
```json
{
  "source": "app",
  "coupon_code": "SAVE500"
}
```

**Response `201` (free / no payment):**
```json
{
  "success": true,
  "message": "Event registration successful.",
  "data": {
    "registration_id": "uuid",
    "status": "confirmed",
    "payment_required": false,
    "payment_status": null,
    "payment_gateway": null,
    "payment_url": null,
    "checkout_url": null,
    "razorpay_order_id": null,
    "qr_code_url": "https://example.com/api/v1/event-qrcodes/uuid/qr.png",
    "qr_token": "tokenValue",
    "requires_payment": false
  }
}
```

**Response `201` (paid event):**
```json
{
  "success": true,
  "message": "Payment required. Please complete payment.",
  "data": {
    "registration_id": "uuid",
    "status": "pending_payment",
    "payment_required": true,
    "payment_status": "pending",
    "payment_gateway": "zoho_billing_payment_link",
    "payment_url": "https://payments.zoho.in/...",
    "checkout_url": "https://payments.zoho.in/...",
    "razorpay_order_id": null,
    "qr_code_url": null,
    "qr_token": null,
    "requires_payment": true
  }
}
```

**Error `403` (cross-circle, no request):**
```json
{
  "success": false,
  "message": "You are not a member of this event circle. Please submit a registration request for admin approval.",
  "data": {
    "request_required": true,
    "request_status": "not_requested"
  }
}
```

**Error `403` (pending request):**
```json
{
  "success": false,
  "message": "Your registration request is pending admin approval.",
  "data": {
    "request_required": true,
    "request_status": "pending",
    "request_id": "uuid"
  }
}
```

**Error `422` (invalid coupon):**
```json
{
  "success": false,
  "message": "Invalid or expired coupon code"
}
```

---

### POST `/api/v1/events/{event_id}/occurrences/{occurrence_id}/visitor-register`
**Controller:** `EventController@visitorRegister`  
**Body:**
```json
{
  "visitor_name": "John Doe",
  "visitor_email": "john@example.com",
  "visitor_phone": "+919876543210",
  "visitor_company": "Acme Corp",
  "visitor_designation": "CEO",
  "visitor_business_category_id": "uuid",
  "visitor_business_category_main_id": "uuid",
  "visitor_business_category_sub_id": "uuid",
  "visitor_business_website": "https://acme.com",
  "visitor_business_brief": "We build SaaS products.",
  "invited_by_type": "member",
  "invited_by_user_id": "uuid",
  "source": "visitor_app"
}
```

**Response `201`:**
```json
{
  "success": true,
  "message": "Visitor registered successfully.",
  "data": {
    "registration_id": "uuid",
    "status": "confirmed",
    "payment_required": false,
    "payment_status": null,
    "payment_gateway": null,
    "payment_url": null,
    "checkout_url": null,
    "qr_code_url": "https://...",
    "qr_token": "abc123",
    "requires_payment": false
  }
}
```

**Response `201` (paid event):**
```json
{
  "success": true,
  "message": "Payment required. Please complete payment.",
  "data": {
    "registration_id": "uuid",
    "status": "pending_payment",
    "payment_required": true,
    "payment_status": "pending",
    "payment_gateway": "zoho_billing_payment_link",
    "payment_url": "https://payments.zoho.in/...",
    "checkout_url": "https://payments.zoho.in/...",
    "qr_code_url": null,
    "qr_token": null,
    "requires_payment": true
  }
}
```

---

### GET `/api/v1/events/registrations/{registration_id}/payment-status`
**Controller:** `EventController@paymentStatus`  
**Auth:** Required  

**Response `200`:**
```json
{
  "success": true,
  "message": "Payment status fetched successfully.",
  "data": {
    "registration_id": "uuid",
    "payment_required": true,
    "payment_gateway": "zoho_billing_payment_link",
    "payment_status": "paid",
    "status": "confirmed",
    "payment_completed_at": "2026-09-21T09:00:00.000000Z",
    "visitor_registration_form_url": "https://example.com/events/uuid/occurrences/uuid/visitor-register",
    "form_url": "https://example.com/events/uuid/occurrences/uuid/visitor-register",
    "qr_token": "abc123",
    "qr_code_url": "https://example.com/api/v1/event-qrcodes/uuid/qr.png",
    "qr_code_svg": null,
    "zoho_invoice_id": "INV-001",
    "zoho_invoice_number": "INV-2026-001",
    "zoho_invoice_url": "https://books.zoho.in/...",
    "zoho_invoice_pdf_url": "https://books.zoho.in/.../pdf",
    "zoho_invoice_status": "paid",
    "zoho_payment_status": "paid",
    "zoho_payment_id": "pay_001",
    "invoice_sync_error": null,
    "invoice": {
      "registration_id": "uuid",
      "zoho_invoice_id": "INV-001",
      "zoho_invoice_number": "INV-2026-001",
      "invoice_url": "https://...",
      "invoice_pdf_url": "https://...",
      "zoho_invoice_status": "paid",
      "invoice_balance": 0,
      "amount_paid": 1500,
      "payment_applied": 1500,
      "invoice_sync_error": null
    }
  }
}
```

---

### POST `/api/v1/events/registrations/{registration_id}/razorpay/verify`
**Controller:** `EventController@verifyRazorpay`  
**Body:**
```json
{
  "razorpay_order_id": "order_abc123",
  "razorpay_payment_id": "pay_xyz789",
  "razorpay_signature": "signatureHash"
}
```

**Response `200`:**
```json
{
  "success": true,
  "message": "Payment verified successfully.",
  "data": {
    "id": "uuid",
    "event_id": "uuid",
    "occurrence_id": "uuid",
    "user_id": "uuid",
    "status": "confirmed",
    "payment_status": "paid",
    "payment_gateway": "razorpay",
    "razorpay_order_id": "order_abc123",
    "razorpay_payment_id": "pay_xyz789",
    "amount": "1500.00",
    "currency": "INR",
    "qr_code_url": "https://..."
  }
}
```

---

### GET `/api/v1/events/registrations/{registration_id}/invoice`
**Controller:** `EventController@invoice`  

**Response `200`:**
```json
{
  "success": true,
  "message": "Invoice fetched successfully.",
  "data": {
    "registration_id": "uuid",
    "zoho_invoice_id": "INV-001",
    "zoho_invoice_number": "INV-2026-001",
    "invoice_url": "https://books.zoho.in/...",
    "invoice_pdf_url": "https://books.zoho.in/.../pdf",
    "zoho_invoice_status": "paid",
    "invoice_balance": 0,
    "amount_paid": 1500,
    "payment_applied": 1500
  }
}
```

---

### GET `/api/v1/events/invoices`
**Controller:** `EventController@invoices`  
**Query Params:** `payment_status`, `event_id`, `occurrence_id`, `user_id`, `visitor_email`, `per_page`

**Response `200`:**
```json
{
  "success": true,
  "message": "Event invoices fetched successfully.",
  "data": {
    "total": 50,
    "items": [
      {
        "registration_id": "uuid",
        "event_id": "uuid",
        "event_title": "Global Summit 2026",
        "occurrence_id": "uuid",
        "attendee_name": "John Doe",
        "email": "john@example.com",
        "phone": "+919876543210",
        "payment_status": "paid",
        "payment_gateway": "zoho_billing_payment_link",
        "zoho_payment_link_id": "pl_001",
        "amount": "1500.00",
        "currency": "INR",
        "zoho_invoice_id": "INV-001",
        "zoho_invoice_number": "INV-2026-001",
        "zoho_invoice_status": "paid",
        "zoho_invoice_url": "https://...",
        "zoho_invoice_pdf_url": "https://...",
        "zoho_invoice_sync_error": null,
        "zoho_payment_id": "pay_001",
        "paid_at": "2026-09-21T09:00:00.000000Z",
        "qr_code_url": "https://...",
        "visitor_designation": "CEO",
        "visitor_business_category_id": "uuid",
        "visitor_business_category": "IT & Technology",
        "visitor_business_category_main_id": "uuid",
        "visitor_business_category_sub_id": "uuid",
        "business_category_main": { "id": "uuid", "name": "IT & Technology" },
        "business_category_sub": { "id": "uuid", "name": "Software Development" },
        "visitor_business_website": "https://acme.com",
        "visitor_business_brief": "We build SaaS products.",
        "invited_by_type": "member",
        "invited_by_user_id": "uuid",
        "invited_by_user": {
          "id": "uuid",
          "display_name": "Jane Smith",
          "first_name": "Jane",
          "last_name": "Smith",
          "company_name": "Smith & Co",
          "designation": "Director",
          "profile_photo_url": "https://..."
        },
        "created_at": "2026-09-21T08:00:00.000000Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "last_page": 3,
      "per_page": 20,
      "total": 50
    }
  }
}
```

---

### GET `/api/v1/events/invoices/{registration_id}`
**Controller:** `EventController@invoiceDetails`  

**Response `200`:** *(same as invoice list item above, plus)*
```json
{
  "success": true,
  "message": "Event invoice fetched successfully.",
  "data": {
    "...all invoice list fields...",
    "event": {
      "title": "Global Summit 2026",
      "location_text": "NSCI Dome, Mumbai",
      "mode": "in_person",
      "start_at": "2026-10-01T09:00:00.000000Z",
      "end_at": "2026-10-01T18:00:00.000000Z"
    },
    "qr_code_url": "https://...",
    "invoice_sync_error": null
  }
}
```

---

## 4. Event Feedback APIs

### GET `/api/v1/event-feedbacks/check-pending`
**Auth:** Required  

**Response `200` (no pending):**
```json
{
  "success": true,
  "message": "No pending feedbacks.",
  "data": null
}
```

**Response `200` (pending found):**
```json
{
  "success": true,
  "message": "Pending event feedback found.",
  "data": {
    "event": {
      "id": "uuid",
      "title": "Morning Business Breakfast",
      "start_at": "2026-09-20T09:00:00.000000Z",
      "end_at": "2026-09-20T11:00:00.000000Z",
      "location_text": "Hotel Grand, Mumbai"
    }
  }
}
```

---

### POST `/api/v1/event-feedbacks`
**Auth:** Required  
**Body:**
```json
{
  "event_id": "uuid",
  "overall_rating": 5,
  "content_rating": 4,
  "venue_rating": 5,
  "networking_rating": 4,
  "would_recommend": true,
  "what_worked": "Great speakers and venue.",
  "what_to_improve": "Start on time.",
  "additional_comments": "Loved it!"
}
```

**Response `201`:**
```json
{
  "success": true,
  "message": "Feedback submitted successfully.",
  "data": {
    "id": "uuid",
    "event_id": "uuid",
    "respondent_user_id": "uuid",
    "respondent_name": "John Doe",
    "overall_rating": 5,
    "content_rating": 4,
    "venue_rating": 5,
    "networking_rating": 4,
    "would_recommend": true,
    "what_worked": "Great speakers and venue.",
    "what_to_improve": "Start on time.",
    "additional_comments": "Loved it!",
    "submitted_at": "2026-09-21T10:00:00.000000Z"
  }
}
```

**Error `403` (didn't attend):**
```json
{ "success": false, "message": "You must attend the event to submit feedback." }
```

**Error `400` (duplicate):**
```json
{ "success": false, "message": "You have already submitted feedback for this event." }
```

---

### GET `/api/v1/event-feedbacks/my`
**Auth:** Required  
**Query Params:** `per_page` (default 20)

**Response `200`:**
```json
{
  "success": true,
  "message": "My feedbacks fetched successfully.",
  "data": {
    "total": 3,
    "current_page": 1,
    "per_page": 20,
    "last_page": 1,
    "items": [
      {
        "id": "uuid",
        "event_id": "uuid",
        "respondent_user_id": "uuid",
        "overall_rating": 5,
        "content_rating": 4,
        "venue_rating": 5,
        "networking_rating": 4,
        "would_recommend": true,
        "what_worked": "Great speakers.",
        "what_to_improve": null,
        "additional_comments": null,
        "submitted_at": "2026-09-21T10:00:00.000000Z",
        "event": {
          "id": "uuid",
          "title": "Morning Business Breakfast",
          "start_at": "2026-09-21T09:00:00.000000Z",
          "end_at": "2026-09-21T11:00:00.000000Z",
          "location_text": "Hotel Grand, Mumbai"
        }
      }
    ]
  }
}
```

---

### GET `/api/v1/event-feedbacks/event/{eventId}`
**Auth:** Required  
**Query Params:** `per_page` (default 20)

**Response `200`:**
```json
{
  "success": true,
  "message": "Event feedbacks fetched successfully.",
  "data": {
    "stats": {
      "total_reviews": 15,
      "avg_overall": 4.5,
      "avg_content": 4.2,
      "avg_venue": 4.8,
      "avg_networking": 4.0,
      "recommend_percentage": 87
    },
    "pagination": {
      "total": 15,
      "current_page": 1,
      "per_page": 20,
      "last_page": 1
    },
    "items": [
      {
        "id": "uuid",
        "event_id": "uuid",
        "respondent_user_id": "uuid",
        "respondent_name": "John Doe",
        "overall_rating": 5,
        "content_rating": 4,
        "venue_rating": 5,
        "networking_rating": 4,
        "would_recommend": true,
        "what_worked": "Great speakers.",
        "what_to_improve": null,
        "additional_comments": "Loved it!",
        "submitted_at": "2026-09-21T10:00:00.000000Z"
      }
    ]
  }
}
```

---

## 5. Admin Event APIs (`/api/v1/admin/events`)

> All require `auth:sanctum` + admin role.

### GET `/api/v1/admin/events`
**Controller:** `EventAdminController@index`

**Response `200`:** Paginated list of events (admin view, all fields).

---

### POST `/api/v1/admin/events`
**Controller:** `EventAdminController@store`

---

### GET `/api/v1/admin/events/{id}`
**Controller:** `EventAdminController@show`

---

### PUT `/api/v1/admin/events/{id}`
**Controller:** `EventAdminController@update`

---

### DELETE `/api/v1/admin/events/{id}`
**Controller:** `EventAdminController@destroy`

---

### GET `/api/v1/admin/events/{id}/registrations`
**Controller:** `AdminOpsController@eventRegistrations`

---

### GET `/api/v1/admin/events/{id}/attendees`
**Controller:** `AdminOpsController@eventAttendees`

---

### POST `/api/v1/admin/events/{id}/speakers`
**Controller:** `AdminOpsController@eventSpeakerStore`

---

### PUT `/api/v1/admin/events/{id}/speakers/{speakerId}`
**Controller:** `AdminOpsController@eventSpeakerUpdate`

---

### DELETE `/api/v1/admin/events/{id}/speakers/{speakerId}`
**Controller:** `AdminOpsController@eventSpeakerDelete`

---

### POST `/api/v1/admin/events/{id}/expenses`
**Controller:** `AdminOpsController@eventExpenseStore`

---

### GET `/api/v1/admin/events/{id}/expenses`
**Controller:** `AdminOpsController@eventExpenses`

---

### POST `/api/v1/admin/events/{id}/sponsorships`
**Controller:** `AdminOpsController@eventSponsorshipStore`

---

### GET `/api/v1/admin/events/{id}/pnl`
**Controller:** `AdminOpsController@eventPnl`

---

### PATCH `/api/v1/admin/events/{id}/approve`
**Controller:** `AdminOpsController@eventApprove`

**Response `200`:**
```json
{
  "success": true,
  "message": "Event approved successfully.",
  "data": { "id": "uuid", "status": "approved" }
}
```

---

### PATCH `/api/v1/admin/events/{id}/reject`
**Controller:** `AdminOpsController@eventReject`

---

## 6. Scan App Event APIs

> Requires Scan App auth token.

### GET `/api/v1/scan-app/events`
**Controller:** `ScanAppEventController@index`

**Response `200`:**
```json
{
  "success": true,
  "message": "Events fetched.",
  "data": [
    {
      "event_id": "uuid",
      "occurrence_id": "uuid",
      "title": "Chapter Meeting",
      "start_at": "2026-09-21T09:00:00.000000Z",
      "end_at": "2026-09-21T11:00:00.000000Z"
    }
  ]
}
```

---

### POST `/api/v1/scan-app/scan`
**Controller:** `ScanAppEventController@scanAny`  
Scans a QR token for any event.

---

### POST `/api/v1/scan-app/events/{event_id}/scan`
**Controller:** `ScanAppEventController@scan`  
Scans QR for a specific event.

---

### GET `/api/v1/scan-app/events/{event}/attendance-history`
**Controller:** `ScanAppEventController@attendanceHistory`

---

## 7. My Events with QR

### GET `/api/v1/my/events-with-qr`
**Controller:** `MyEventQrController@index`  
**Auth:** `auth:sanctum` + `unity.user`

**Response `200`:**
```json
{
  "success": true,
  "message": "Events with QR fetched successfully.",
  "data": {
    "items": [
      {
        "registration_id": "uuid",
        "event_id": "uuid",
        "occurrence_id": "uuid",
        "title": "Chapter Meeting",
        "start_at": "2026-09-21T09:00:00.000000Z",
        "end_at": "2026-09-21T11:00:00.000000Z",
        "qr_code_url": "https://...",
        "qr_token": "abc123",
        "status": "confirmed",
        "checkin_status": null
      }
    ]
  }
}
```

---

## Common Error Responses

| HTTP | Shape |
|---|---|
| `401` | `{ "success": false, "message": "Unauthenticated." }` |
| `403` | `{ "success": false, "message": "..." }` |
| `404` | `{ "success": false, "message": "Event not found." }` |
| `422` | `{ "success": false, "message": "...", "errors": { "field": ["..."] } }` |
| `500` | `{ "success": false, "message": "Something went wrong while fetching events.", "error": "..." }` |
