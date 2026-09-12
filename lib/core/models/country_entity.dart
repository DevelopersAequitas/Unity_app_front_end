class CountryEntity {
  final String name;
  final String code;
  final String dialCode;
  final String flag;

  const CountryEntity({
    required this.name,
    required this.code,
    required this.dialCode,
    required this.flag,
  });

  factory CountryEntity.fromJson(Map<String, dynamic> json) {
    return CountryEntity(
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      dialCode: json['dial_code'] as String? ?? '',
      flag: json['flag'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'code': code,
    'dial_code': dialCode,
    'flag': flag,
  };
}
