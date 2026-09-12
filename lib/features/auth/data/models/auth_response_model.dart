import 'user_model.dart';

class AuthResponseModel {
  final bool success;
  final String message;
  final UserModel? user;
  final String? token;

  const AuthResponseModel({
    required this.success,
    required this.message,
    this.user,
    this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    UserModel? user;
    String? token;

    final data = json['data'];
    if (data is Map<String, dynamic>) {
      if (data['user'] is Map<String, dynamic>) {
        user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      }
      token = data['token'] as String?;
    }

    return AuthResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      user: user,
      token: token,
    );
  }
}
