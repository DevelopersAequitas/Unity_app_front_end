import 'package:equatable/equatable.dart';
import '../../domain/entities/register_params.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterDraftLoadRequested extends RegisterEvent {
  const RegisterDraftLoadRequested();
}

class RegisterDraftSaveRequested extends RegisterEvent {
  final RegisterParams params;
  const RegisterDraftSaveRequested(this.params);

  @override
  List<Object?> get props => [params];
}

class RegisterMainCategoriesRequested extends RegisterEvent {
  const RegisterMainCategoriesRequested();
}

class RegisterSubcategoriesRequested extends RegisterEvent {
  final dynamic parentId;
  const RegisterSubcategoriesRequested(this.parentId);

  @override
  List<Object?> get props => [parentId];
}

class RegisterStep1Submitted extends RegisterEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String countryCode;
  final String dob;
  final String? profilePhotoId;
  final String? cityId;
  final String city;

  const RegisterStep1Submitted({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.countryCode,
    required this.dob,
    this.profilePhotoId,
    this.cityId,
    required this.city,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    phone,
    countryCode,
    dob,
    profilePhotoId,
    cityId,
    city,
  ];
}

class RegisterStep2Submitted extends RegisterEvent {
  final String companyName;
  final int? mainCategoryId;
  final String? mainCategoryName;
  final int? categoryId;
  final String? categoryName;
  final int? level1Id;
  final int? level2Id;
  final int? level3Id;
  final int? level4Id;
  final bool isOtherCategory;
  final String? otherCategoryName;
  final String companyAddress;
  final String? referralCode;
  final double? latitude;
  final double? longitude;

  const RegisterStep2Submitted({
    required this.companyName,
    this.mainCategoryId,
    this.mainCategoryName,
    this.categoryId,
    this.categoryName,
    this.level1Id,
    this.level2Id,
    this.level3Id,
    this.level4Id,
    this.isOtherCategory = false,
    this.otherCategoryName,
    required this.companyAddress,
    this.referralCode,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
    companyName,
    mainCategoryId,
    mainCategoryName,
    categoryId,
    categoryName,
    level1Id,
    level2Id,
    level3Id,
    level4Id,
    isOtherCategory,
    otherCategoryName,
    companyAddress,
    referralCode,
    latitude,
    longitude,
  ];
}

class RegisterPreviousStepRequested extends RegisterEvent {
  const RegisterPreviousStepRequested();
}

class RegisterResetState extends RegisterEvent {
  const RegisterResetState();
}
