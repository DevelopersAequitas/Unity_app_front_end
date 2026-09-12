import '../../domain/entities/register_params.dart';

class RegisterRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String companyName;
  final String? cityId;
  final String city;
  final int? mainBusinessCategoryId;
  final int? businessCategoryId;
  final int? level1CategoryId;
  final int? level2CategoryId;
  final int? level3CategoryId;
  final int? level4CategoryId;
  final bool isOtherCategory;
  final String? otherCategoryName;
  final String? customCategoryName;
  final String companyAddress;
  final String dob;
  final String? referralCode;
  final String? profilePhotoId;
  final double? latitude;
  final double? longitude;

  const RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.companyName,
    this.cityId,
    required this.city,
    this.mainBusinessCategoryId,
    this.businessCategoryId,
    this.level1CategoryId,
    this.level2CategoryId,
    this.level3CategoryId,
    this.level4CategoryId,
    this.isOtherCategory = false,
    this.otherCategoryName,
    this.customCategoryName,
    required this.companyAddress,
    required this.dob,
    this.referralCode,
    this.profilePhotoId,
    this.latitude,
    this.longitude,
  });

  factory RegisterRequestModel.fromEntity(RegisterParams params) {
    // Sanitized full phone
    String cleanDigits = params.phone.replaceAll(RegExp(r'\D'), '');
    if (cleanDigits.startsWith('0')) {
      cleanDigits = cleanDigits.replaceFirst(RegExp(r'^0+'), '');
    }
    final fullPhone = params.phone.startsWith('+')
        ? params.phone
        : '${params.countryCode}$cleanDigits';

    final lvl1 = params.mainBusinessCategoryId ?? params.level1CategoryId;
    final lvl4 = params.isOtherCategory
        ? null
        : (params.businessCategoryId ?? params.level4CategoryId);
    final otherName = params.otherCategoryName?.trim();

    final cleanCity = params.city.contains(',')
        ? params.city.split(',').first.trim()
        : params.city.trim();

    return RegisterRequestModel(
      firstName: params.firstName.trim(),
      lastName: params.lastName.trim(),
      email: params.email.trim(),
      phone: fullPhone.trim(),
      companyName: params.companyName.trim(),
      cityId: params.cityId,
      city: cleanCity.isNotEmpty ? cleanCity : params.city.trim(),
      mainBusinessCategoryId: lvl1,
      businessCategoryId: lvl4,
      level1CategoryId: lvl1,
      level2CategoryId: params.level2CategoryId,
      level3CategoryId: params.level3CategoryId,
      level4CategoryId: lvl4,
      isOtherCategory: params.isOtherCategory,
      otherCategoryName: otherName,
      customCategoryName: otherName,
      companyAddress: params.companyAddress.trim(),
      dob: params.dob.trim(),
      referralCode: params.referralCode?.trim(),
      profilePhotoId: params.profilePhotoId?.trim(),
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'company_name': companyName,
      'city': city,
      'company_address': companyAddress,
      'dob': dob,
      'is_other_category': isOtherCategory,
    };

    if (latitude != null && longitude != null) {
      map['latitude'] = latitude;
      map['longitude'] = longitude;
    }

    if (cityId != null && cityId!.isNotEmpty) {
      map['city_id'] = cityId;
    }

    if (mainBusinessCategoryId != null) {
      map['main_business_category_id'] = mainBusinessCategoryId;
      map['level_1_category_id'] = mainBusinessCategoryId;
    }

    if (isOtherCategory) {
      if (otherCategoryName != null && otherCategoryName!.isNotEmpty) {
        map['other_category_name'] = otherCategoryName;
        map['custom_category_name'] = customCategoryName ?? otherCategoryName;
      }
    } else {
      if (level2CategoryId != null) {
        map['level_2_category_id'] = level2CategoryId;
      }
      if (level3CategoryId != null) {
        map['level_3_category_id'] = level3CategoryId;
      }
      if (businessCategoryId != null) {
        map['business_category_id'] = businessCategoryId;
        map['level_4_category_id'] = businessCategoryId;
      }
    }

    if (referralCode != null && referralCode!.isNotEmpty) {
      map['referral_code'] = referralCode;
    }

    final photo = profilePhotoId;
    final isLocalPhoto = photo != null &&
        (photo.startsWith('/') ||
            photo.contains(RegExp(r'^[A-Za-z]:[\\/]')) ||
            photo.contains('cache') ||
            photo.endsWith('.jpg') ||
            photo.endsWith('.png') ||
            photo.endsWith('.jpeg') ||
            photo.endsWith('.webp'));

    if (photo != null && photo.isNotEmpty && !isLocalPhoto) {
      map['profile_photo_id'] = photo;
      map['profile_photo_file_id'] = photo;
    }
    return map;
  }
}
