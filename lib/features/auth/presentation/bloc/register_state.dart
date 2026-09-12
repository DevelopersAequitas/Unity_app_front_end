import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_token_entity.dart';
import '../../domain/entities/category_item_entity.dart';
import '../../domain/entities/register_params.dart';
import '../../domain/entities/user_entity.dart';

enum RegisterStatus { initial, draftLoaded, stepReady, submitting, success, error }

class RegisterState extends Equatable {
  final int currentStep;
  final RegisterParams params;
  final RegisterStatus status;
  final List<CategoryItemEntity> mainCategories;
  final List<CategoryItemEntity> subCategories;
  final bool isCategoriesLoading;
  final String? errorMessage;
  final String? successMessage;
  final UserEntity? user;
  final AuthTokenEntity? token;

  const RegisterState({
    this.currentStep = 1,
    this.params = const RegisterParams(),
    this.status = RegisterStatus.initial,
    this.mainCategories = const [],
    this.subCategories = const [],
    this.isCategoriesLoading = false,
    this.errorMessage,
    this.successMessage,
    this.user,
    this.token,
  });

  RegisterState copyWith({
    int? currentStep,
    RegisterParams? params,
    RegisterStatus? status,
    List<CategoryItemEntity>? mainCategories,
    List<CategoryItemEntity>? subCategories,
    bool? isCategoriesLoading,
    String? errorMessage,
    String? successMessage,
    UserEntity? user,
    AuthTokenEntity? token,
  }) {
    return RegisterState(
      currentStep: currentStep ?? this.currentStep,
      params: params ?? this.params,
      status: status ?? this.status,
      mainCategories: mainCategories ?? this.mainCategories,
      subCategories: subCategories ?? this.subCategories,
      isCategoriesLoading: isCategoriesLoading ?? this.isCategoriesLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    params,
    status,
    mainCategories,
    subCategories,
    isCategoriesLoading,
    errorMessage,
    successMessage,
    user,
    token,
  ];
}
