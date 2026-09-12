import 'package:equatable/equatable.dart';

class RegisterParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String countryCode;
  final String companyName;
  final int? mainBusinessCategoryId;
  final String? mainBusinessCategoryName;
  final int? businessCategoryId;
  final String? businessCategoryName;
  final int? level1CategoryId;
  final int? level2CategoryId;
  final int? level3CategoryId;
  final int? level4CategoryId;
  final bool isOtherCategory;
  final String? otherCategoryName;
  final String? cityId;
  final String city;
  final String companyAddress;
  final String dob;
  final String? referralCode;
  final String? profilePhotoId;
  final double? latitude;
  final double? longitude;

  const RegisterParams({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.countryCode = '+91',
    this.companyName = '',
    this.mainBusinessCategoryId,
    this.mainBusinessCategoryName,
    this.businessCategoryId,
    this.businessCategoryName,
    this.level1CategoryId,
    this.level2CategoryId,
    this.level3CategoryId,
    this.level4CategoryId,
    this.isOtherCategory = false,
    this.otherCategoryName,
    this.cityId,
    this.city = '',
    this.companyAddress = '',
    this.dob = '',
    this.referralCode,
    this.profilePhotoId,
    this.latitude,
    this.longitude,
  });

  RegisterParams copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? countryCode,
    String? companyName,
    int? mainBusinessCategoryId,
    String? mainBusinessCategoryName,
    int? businessCategoryId,
    String? businessCategoryName,
    int? level1CategoryId,
    int? level2CategoryId,
    int? level3CategoryId,
    int? level4CategoryId,
    bool? isOtherCategory,
    String? otherCategoryName,
    String? cityId,
    String? city,
    String? companyAddress,
    String? dob,
    String? referralCode,
    String? profilePhotoId,
    double? latitude,
    double? longitude,
  }) {
    return RegisterParams(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      companyName: companyName ?? this.companyName,
      mainBusinessCategoryId:
          mainBusinessCategoryId ?? this.mainBusinessCategoryId,
      mainBusinessCategoryName:
          mainBusinessCategoryName ?? this.mainBusinessCategoryName,
      businessCategoryId: businessCategoryId ?? this.businessCategoryId,
      businessCategoryName: businessCategoryName ?? this.businessCategoryName,
      level1CategoryId: level1CategoryId ?? this.level1CategoryId,
      level2CategoryId: level2CategoryId ?? this.level2CategoryId,
      level3CategoryId: level3CategoryId ?? this.level3CategoryId,
      level4CategoryId: level4CategoryId ?? this.level4CategoryId,
      isOtherCategory: isOtherCategory ?? this.isOtherCategory,
      otherCategoryName: otherCategoryName ?? this.otherCategoryName,
      cityId: cityId ?? this.cityId,
      city: city ?? this.city,
      companyAddress: companyAddress ?? this.companyAddress,
      dob: dob ?? this.dob,
      referralCode: referralCode ?? this.referralCode,
      profilePhotoId: profilePhotoId ?? this.profilePhotoId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toCacheMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'countryCode': countryCode,
      'companyName': companyName,
      'mainBusinessCategoryId': mainBusinessCategoryId,
      'mainBusinessCategoryName': mainBusinessCategoryName,
      'businessCategoryId': businessCategoryId,
      'businessCategoryName': businessCategoryName,
      'level1CategoryId': level1CategoryId,
      'level2CategoryId': level2CategoryId,
      'level3CategoryId': level3CategoryId,
      'level4CategoryId': level4CategoryId,
      'isOtherCategory': isOtherCategory,
      'otherCategoryName': otherCategoryName,
      'cityId': cityId,
      'city': city,
      'companyAddress': companyAddress,
      'dob': dob,
      'referralCode': referralCode,
      'profilePhotoId': profilePhotoId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory RegisterParams.fromCacheMap(Map<String, dynamic> map) {
    return RegisterParams(
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      countryCode: map['countryCode'] as String? ?? '+91',
      companyName: map['companyName'] as String? ?? '',
      mainBusinessCategoryId: map['mainBusinessCategoryId'] as int?,
      mainBusinessCategoryName: map['mainBusinessCategoryName'] as String?,
      businessCategoryId: map['businessCategoryId'] as int?,
      businessCategoryName: map['businessCategoryName'] as String?,
      level1CategoryId: map['level1CategoryId'] as int?,
      level2CategoryId: map['level2CategoryId'] as int?,
      level3CategoryId: map['level3CategoryId'] as int?,
      level4CategoryId: map['level4CategoryId'] as int?,
      isOtherCategory: map['isOtherCategory'] as bool? ?? false,
      otherCategoryName: map['otherCategoryName'] as String?,
      cityId: map['cityId'] as String?,
      city: map['city'] as String? ?? '',
      companyAddress: map['companyAddress'] as String? ?? '',
      dob: map['dob'] as String? ?? '',
      referralCode: map['referralCode'] as String?,
      profilePhotoId: map['profilePhotoId'] as String?,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    phone,
    countryCode,
    companyName,
    mainBusinessCategoryId,
    mainBusinessCategoryName,
    businessCategoryId,
    businessCategoryName,
    level1CategoryId,
    level2CategoryId,
    level3CategoryId,
    level4CategoryId,
    isOtherCategory,
    otherCategoryName,
    cityId,
    city,
    companyAddress,
    dob,
    referralCode,
    profilePhotoId,
    latitude,
    longitude,
  ];
}
