import '../constants/api_endpoints.dart';
import '../models/city_entity.dart';
import '../models/country_entity.dart';
import '../network/dio_client.dart';

abstract class LocationRemoteDataSource {
  Future<List<CountryEntity>> getCountries({
    String? search,
    int page = 1,
    int perPage = 20,
  });
  Future<List<CityEntity>> getCities({
    String? search,
    String? state,
    int page = 1,
    int perPage = 20,
  });
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final DioClient dioClient;

  const LocationRemoteDataSourceImpl({required this.dioClient});

  static const List<CountryEntity> _fallbackCountries = [
    CountryEntity(name: 'India', code: 'IN', dialCode: '+91', flag: '🇮🇳'),
    CountryEntity(
      name: 'United States',
      code: 'US',
      dialCode: '+1',
      flag: '🇺🇸',
    ),
    CountryEntity(
      name: 'United Kingdom',
      code: 'GB',
      dialCode: '+44',
      flag: '🇬🇧',
    ),
    CountryEntity(
      name: 'United Arab Emirates',
      code: 'AE',
      dialCode: '+971',
      flag: '🇦🇪',
    ),
    CountryEntity(name: 'Canada', code: 'CA', dialCode: '+1', flag: '🇨🇦'),
    CountryEntity(name: 'Australia', code: 'AU', dialCode: '+61', flag: '🇦🇺'),
    CountryEntity(name: 'Singapore', code: 'SG', dialCode: '+65', flag: '🇸🇬'),
    CountryEntity(name: 'Germany', code: 'DE', dialCode: '+49', flag: '🇩🇪'),
  ];

  static const List<CityEntity> _fallbackCities = [
    CityEntity(
      id: '9e5c46da-559d-4340-8438-bb41e975a5e3',
      name: 'Surat',
      state: 'Gujarat',
      stateCode: 'GJ',
      country: 'India',
      countryCode: 'IN',
      formattedLocation: 'Surat, GJ, IN',
      displayName: 'Surat, GJ, IN',
    ),
    CityEntity(
      id: '8a3d12bc-661e-4120-9118-cc51f864a1a2',
      name: 'Ahmedabad',
      state: 'Gujarat',
      stateCode: 'GJ',
      country: 'India',
      countryCode: 'IN',
      formattedLocation: 'Ahmedabad, GJ, IN',
      displayName: 'Ahmedabad, GJ, IN',
    ),
    CityEntity(
      id: '7b2c98ef-112a-4339-aa01-dd9988776655',
      name: 'Mumbai',
      state: 'Maharashtra',
      stateCode: 'MH',
      country: 'India',
      countryCode: 'IN',
      formattedLocation: 'Mumbai, MH, IN',
      displayName: 'Mumbai, MH, IN',
    ),
    CityEntity(
      id: '6c1a87de-223b-5440-bb12-ee8877665544',
      name: 'Bengaluru',
      state: 'Karnataka',
      stateCode: 'KA',
      country: 'India',
      countryCode: 'IN',
      formattedLocation: 'Bengaluru, KA, IN',
      displayName: 'Bengaluru, KA, IN',
    ),
    CityEntity(
      id: '5d0976cd-334c-6551-cc23-ff7766554433',
      name: 'Delhi',
      state: 'Delhi',
      stateCode: 'DL',
      country: 'India',
      countryCode: 'IN',
      formattedLocation: 'Delhi, DL, IN',
      displayName: 'Delhi, DL, IN',
    ),
  ];

  @override
  Future<List<CountryEntity>> getCountries({
    String? search,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final query = <String, dynamic>{'page': page, 'per_page': perPage};
      if (search != null && search.trim().isNotEmpty) {
        query['search'] = search.trim();
      }
      final response = await dioClient.dio.get(
        ApiEndpoints.countries,
        queryParameters: query,
      );
      if (response.data is Map<String, dynamic>) {
        final rawData = response.data['data'];
        List? itemsList;
        if (rawData is List) {
          itemsList = rawData;
        } else if (rawData is Map<String, dynamic>) {
          if (rawData['items'] is List) {
            itemsList = rawData['items'] as List;
          } else if (rawData['data'] is List) {
            itemsList = rawData['data'] as List;
          } else if (rawData['countries'] is List) {
            itemsList = rawData['countries'] as List;
          }
        }
        if (itemsList != null) {
          return itemsList
              .whereType<Map<String, dynamic>>()
              .map((e) => CountryEntity.fromJson(e))
              .where((c) => c.dialCode.isNotEmpty)
              .toList();
        }
      }
      return page == 1 ? _filterFallbackCountries(search) : const [];
    } catch (_) {
      return page == 1 ? _filterFallbackCountries(search) : const [];
    }
  }

  List<CountryEntity> _filterFallbackCountries(String? search) {
    if (search != null && search.trim().isNotEmpty) {
      final q = search.trim().toLowerCase();
      return _fallbackCountries
          .where(
            (c) =>
                c.name.toLowerCase().contains(q) ||
                c.dialCode.contains(q) ||
                c.code.toLowerCase().contains(q),
          )
          .toList();
    }
    return _fallbackCountries;
  }

  @override
  Future<List<CityEntity>> getCities({
    String? search,
    String? state,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final query = <String, dynamic>{'page': page, 'per_page': perPage};
      if (search != null && search.trim().isNotEmpty) {
        query['search'] = search.trim();
      }
      if (state != null && state.trim().isNotEmpty) {
        query['state'] = state.trim();
      }

      final response = await dioClient.dio.get(
        ApiEndpoints.cities,
        queryParameters: query,
      );
      if (response.data is Map<String, dynamic>) {
        final rawData = response.data['data'];
        List? itemsList;
        if (rawData is List) {
          itemsList = rawData;
        } else if (rawData is Map<String, dynamic>) {
          if (rawData['items'] is List) {
            itemsList = rawData['items'] as List;
          } else if (rawData['data'] is List) {
            itemsList = rawData['data'] as List;
          } else if (rawData['cities'] is List) {
            itemsList = rawData['cities'] as List;
          } else if (rawData['rows'] is List) {
            itemsList = rawData['rows'] as List;
          }
        }
        if (itemsList != null) {
          return itemsList
              .whereType<Map<String, dynamic>>()
              .map((e) => CityEntity.fromJson(e))
              .toList();
        }
      }
      return page == 1 ? _filterFallbackCities(search, state) : const [];
    } catch (_) {
      return page == 1 ? _filterFallbackCities(search, state) : const [];
    }
  }

  List<CityEntity> _filterFallbackCities(String? search, String? state) {
    var list = _fallbackCities;
    if (search != null && search.trim().isNotEmpty) {
      final q = search.trim().toLowerCase();
      list = list
          .where(
            (c) =>
                c.name.toLowerCase().contains(q) ||
                c.formattedLocation.toLowerCase().contains(q) ||
                c.displayName.toLowerCase().contains(q),
          )
          .toList();
    }
    if (state != null && state.trim().isNotEmpty) {
      final s = state.trim().toLowerCase();
      list = list
          .where(
            (c) =>
                c.state.toLowerCase().contains(s) ||
                c.stateCode.toLowerCase().contains(s),
          )
          .toList();
    }
    return list;
  }
}
