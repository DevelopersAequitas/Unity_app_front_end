class CityEntity {
  final String id;
  final String name;
  final String state;
  final String stateCode;
  final String country;
  final String countryCode;
  final String formattedLocation;
  final String displayName;

  const CityEntity({
    required this.id,
    required this.name,
    this.state = '',
    this.stateCode = '',
    this.country = '',
    this.countryCode = '',
    this.formattedLocation = '',
    this.displayName = '',
  });

  String get label => displayName.isNotEmpty
      ? displayName
      : (formattedLocation.isNotEmpty ? formattedLocation : name);

  factory CityEntity.fromJson(Map<String, dynamic> json) {
    return CityEntity(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      state: (json['state'] ?? '').toString(),
      stateCode: (json['state_code'] ?? '').toString(),
      country: (json['country'] ?? '').toString(),
      countryCode: (json['country_code'] ?? '').toString(),
      formattedLocation: (json['formatted_location'] ?? '').toString(),
      displayName: (json['display_name'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'state': state,
    'state_code': stateCode,
    'country': country,
    'country_code': countryCode,
    'formatted_location': formattedLocation,
    'display_name': displayName,
  };
}
