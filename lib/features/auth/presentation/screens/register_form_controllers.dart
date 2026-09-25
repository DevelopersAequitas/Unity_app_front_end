import 'package:flutter/material.dart';
import '../../../../core/datasources/location_remote_datasource.dart';
import '../../../../core/models/city_entity.dart';
import '../../../../core/widgets/app_date_picker_dialog.dart';
import '../../../../core/widgets/city_picker_sheet.dart';
import '../../domain/entities/category_item_entity.dart';
import '../../domain/entities/register_params.dart';
import '../widgets/category_picker_sheet.dart';

class RegisterFormControllers {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final companyName = TextEditingController();
  final companyAddress = TextEditingController();
  final otherCategory = TextEditingController();
  final referral = TextEditingController();
  String countryCode = '+91';

  void populateFromDraft(RegisterParams draft) {
    if (draft.firstName.isNotEmpty) {
      firstName.text = draft.firstName;
    }
    if (draft.lastName.isNotEmpty) {
      lastName.text = draft.lastName;
    }
    if (draft.email.isNotEmpty) {
      email.text = draft.email;
    }
    if (draft.phone.isNotEmpty) {
      phone.text = draft.phone;
    }
    if (draft.countryCode.isNotEmpty) {
      countryCode = draft.countryCode;
    }
    if (draft.companyName.isNotEmpty) {
      companyName.text = draft.companyName;
    }
    if (draft.companyAddress.isNotEmpty) {
      companyAddress.text = draft.companyAddress;
    }
    if (draft.otherCategoryName != null && draft.otherCategoryName!.isNotEmpty) {
      otherCategory.text = draft.otherCategoryName!;
    }
    if (draft.referralCode != null) {
      referral.text = draft.referralCode!;
    }
  }

  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    phone.dispose();
    companyName.dispose();
    companyAddress.dispose();
    otherCategory.dispose();
    referral.dispose();
  }

  static Future<CategoryItemEntity?> pickCategory(
    BuildContext context, {
    required String title,
    required List<CategoryItemEntity> categories,
    dynamic selectedId,
  }) {
    return CategoryPickerSheet.show(
      context,
      title: title,
      categories: categories,
      selectedId: selectedId,
    );
  }

  static Future<CityEntity?> pickCity(
    BuildContext context, {
    required LocationRemoteDataSource dataSource,
    String? selectedCityId,
  }) {
    return CityPickerSheet.show(
      context,
      dataSource: dataSource,
      selectedCityId: selectedCityId,
    );
  }

  static Future<String?> pickDateOfBirth(
    BuildContext context, {
    DateTime? initialDate,
  }) async {
    final now = DateTime.now();
    final picked = await AppDatePickerDialog.show(
      context,
      title: 'Select Date of Birth',
      initialDate: initialDate ?? DateTime(now.year - 25, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime(now.year - 16, 12, 31),
    );
    if (picked != null) {
      return '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
    return null;
  }
}
