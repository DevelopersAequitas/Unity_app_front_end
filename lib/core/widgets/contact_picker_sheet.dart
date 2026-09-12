import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/contacts_sync_service.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';
import 'app_snack_bar.dart';

class ContactPickerSheet extends StatefulWidget {
  const ContactPickerSheet({super.key});

  static Future<String?> show(BuildContext context) async {
    final status = await Permission.contacts.request();
    if (!status.isGranted) {
      if (context.mounted) {
        AppSnackBar.showError(
          context,
          'Contacts permission is required to pick a contact.',
        );
      }
      return null;
    }

    // Automatically sync contacts to backend API in background
    ContactsSyncService.instance.syncAddressBookInBackground();

    if (!context.mounted) return null;
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const ContactPickerSheet(),
    );
  }

  @override
  State<ContactPickerSheet> createState() => _ContactPickerSheetState();
}

class _ContactPickerSheetState extends State<ContactPickerSheet> {
  final _searchController = TextEditingController();
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    try {
      final list = await FlutterContacts.getAll(
        properties: {ContactProperty.phone},
      );
      final withPhones = list.where((c) => c.phones.isNotEmpty).toList();
      if (mounted) {
        setState(() {
          _contacts = withPhones;
          _filteredContacts = withPhones;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = _contacts;
      } else {
        _filteredContacts = _contacts.where((c) {
          final name = (c.displayName ?? '').toLowerCase();
          final nameMatch = name.contains(query);
          final phoneMatch = c.phones.any(
            (p) => p.number.replaceAll(RegExp(r'\D'), '').contains(query),
          );
          return nameMatch || phoneMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final primaryTextColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;

    return Material(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: secondaryTextColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Select Contact',
                style: AppTypography.titleMedium.copyWith(
                  color: primaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _searchController,
                style: AppTypography.bodyMedium.copyWith(
                  color: primaryTextColor,
                ),
                decoration: InputDecoration(
                  hintText: 'Search contacts...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  filled: true,
                  fillColor: isDark
                      ? AppColor.darkBackground
                      : AppColor.lightBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredContacts.isEmpty
                    ? Center(
                        child: Text(
                          'No contacts found',
                          style: AppTypography.bodyMedium.copyWith(
                            color: secondaryTextColor,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _filteredContacts.length,
                        separatorBuilder: (ctx, idx) => Divider(
                          height: 1,
                          color: isDark
                              ? AppColor.darkBorder
                              : AppColor.lightBorder,
                        ),
                        itemBuilder: (context, index) {
                          final contact = _filteredContacts[index];
                          final phone = contact.phones.first.number;
                          final name =
                              contact.displayName?.trim().isNotEmpty == true
                              ? contact.displayName!
                              : 'Unknown';
                          return Material(
                            color: Colors.transparent,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: AppColor.primaryBlue
                                    .withValues(alpha: 0.12),
                                child: Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                                  style: const TextStyle(
                                    color: AppColor.primaryBlue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              title: Text(
                                name,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                phone,
                                style: AppTypography.bodySmall.copyWith(
                                  color: secondaryTextColor,
                                ),
                              ),
                              onTap: () {
                                var clean = phone.replaceAll(RegExp(r'\D'), '');
                                clean = clean.replaceFirst(RegExp(r'^0+'), '');
                                Navigator.of(context).pop(clean);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
