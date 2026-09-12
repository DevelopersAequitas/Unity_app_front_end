import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';
import 'app_text_field.dart';
import 'primary_pill_button.dart';

class LocationPickerResult {
  final String address;
  final double latitude;
  final double longitude;
  final String? pincode;

  const LocationPickerResult({
    required this.address,
    required this.latitude,
    required this.longitude,
    this.pincode,
  });
}

class LocationPickerSheet extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final String? initialAddress;

  const LocationPickerSheet({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    this.initialAddress,
  });

  static Future<LocationPickerResult?> show(
    BuildContext context, {
    double? initialLatitude,
    double? initialLongitude,
    String? initialAddress,
  }) {
    return showModalBottomSheet<LocationPickerResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => LocationPickerSheet(
        initialLatitude: initialLatitude,
        initialLongitude: initialLongitude,
        initialAddress: initialAddress,
      ),
    );
  }

  @override
  State<LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<LocationPickerSheet> {
  late final MapController _mapController;
  final _searchController = TextEditingController();
  final _dio = Dio();

  LatLng _currentCenter = const LatLng(28.6139, 77.2090); // Default to New Delhi
  String _currentAddress = 'Fetching address...';
  String? _currentPincode;
  bool _isGeocoding = false;
  bool _isLocating = false;
  Timer? _geocodeDebounce;
  Timer? _searchDebounce;

  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _currentCenter = LatLng(
        widget.initialLatitude!,
        widget.initialLongitude!,
      );
      if (widget.initialAddress != null && widget.initialAddress!.isNotEmpty) {
        _currentAddress = widget.initialAddress!;
      } else {
        _reverseGeocode(_currentCenter);
      }
    } else {
      _determineInitialPosition();
    }
  }

  @override
  void dispose() {
    _geocodeDebounce?.cancel();
    _searchDebounce?.cancel();
    _searchController.dispose();
    _mapController.dispose();
    _dio.close();
    super.dispose();
  }

  Future<void> _determineInitialPosition() async {
    setState(() => _isLocating = true);
    try {
      final status = await Permission.location.request();
      if (status.isGranted) {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 8),
          ),
        );
        final newCenter = LatLng(pos.latitude, pos.longitude);
        if (mounted) {
          setState(() {
            _currentCenter = newCenter;
            _isLocating = false;
          });
          _mapController.move(newCenter, 16);
          _reverseGeocode(newCenter);
          return;
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() => _isLocating = false);
      _reverseGeocode(_currentCenter);
    }
  }

  Future<void> _goToCurrentLocation() async {
    setState(() => _isLocating = true);
    try {
      final status = await Permission.location.request();
      if (status.isGranted) {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 8),
          ),
        );
        final target = LatLng(pos.latitude, pos.longitude);
        if (mounted) {
          setState(() {
            _currentCenter = target;
            _isLocating = false;
          });
          _mapController.move(target, 16);
          _reverseGeocode(target);
        }
      } else {
        if (mounted) {
          setState(() => _isLocating = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission is required to detect GPS position.'),
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLocating = false);
      }
    }
  }

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    if (hasGesture) {
      setState(() {
        _currentCenter = camera.center;
      });
      _geocodeDebounce?.cancel();
      _geocodeDebounce = Timer(const Duration(milliseconds: 600), () {
        _reverseGeocode(_currentCenter);
      });
    }
  }

  Future<void> _reverseGeocode(LatLng point) async {
    setState(() => _isGeocoding = true);
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'lat': point.latitude,
          'lon': point.longitude,
          'format': 'json',
          'addressdetails': 1,
        },
        options: Options(
          headers: {'User-Agent': 'PeersUnityApp/1.0 (support@peersunity.com)'},
        ),
      );

      if (response.statusCode == 200 && response.data is Map) {
        final displayName = response.data['display_name'] as String?;
        final addressDetails = response.data['address'] as Map<String, dynamic>?;
        final postcode = addressDetails?['postcode']?.toString();
        if (displayName != null && displayName.isNotEmpty && mounted) {
          setState(() {
            _currentAddress = displayName;
            _currentPincode = postcode;
            _isGeocoding = false;
          });
          return;
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _currentAddress =
            'Selected Location (${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)})';
        _isGeocoding = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    if (query.trim().length < 3) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 400), () async {
      setState(() => _isSearching = true);
      try {
        final response = await _dio.get(
          'https://nominatim.openstreetmap.org/search',
          queryParameters: {
            'q': query.trim(),
            'format': 'json',
            'limit': 5,
            'addressdetails': 1,
          },
          options: Options(
            headers: {'User-Agent': 'PeersUnityApp/1.0 (support@peersunity.com)'},
          ),
        );

        if (response.statusCode == 200 && response.data is List && mounted) {
          setState(() {
            _searchResults = List<Map<String, dynamic>>.from(response.data);
            _isSearching = false;
          });
        }
      } catch (_) {
        if (mounted) {
          setState(() => _isSearching = false);
        }
      }
    });
  }

  void _selectSearchResult(Map<String, dynamic> item) {
    final lat = double.tryParse(item['lat']?.toString() ?? '');
    final lon = double.tryParse(item['lon']?.toString() ?? '');
    final name = item['display_name'] as String? ?? '';

    if (lat != null && lon != null) {
      final target = LatLng(lat, lon);
      final addressDetails = item['address'] as Map<String, dynamic>?;
      final postcode = addressDetails?['postcode']?.toString();
      setState(() {
        _currentCenter = target;
        _currentAddress = name;
        _currentPincode = postcode;
        _searchResults = [];
      });
      FocusScope.of(context).unfocus();
      _mapController.move(target, 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final primaryTextColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;

    return Material(
      color: surfaceColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.88,
        child: SafeArea(
          top: false,
          child: Stack(
            children: [
              // Map Layer
              Positioned.fill(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentCenter,
                    initialZoom: 15.5,
                    minZoom: 3,
                    maxZoom: 19,
                    onPositionChanged: _onPositionChanged,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.peersglobal.unity_app',
                    ),
                  ],
                ),
              ),

              // Fixed Center Marker Pin
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 36),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryBlue,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Company Location',
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Icon(
                        Icons.location_on_rounded,
                        size: 42,
                        color: AppColor.primaryBlue,
                      ),
                    ],
                  ),
                ),
              ),

              // Top Search Bar & Header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                  decoration: BoxDecoration(
                    color: surfaceColor.withValues(alpha: 0.95),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 36,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: secondaryTextColor.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Pick Company Location on Map',
                              style: AppTypography.titleMedium.copyWith(
                                color: primaryTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      AppTextField(
                        controller: _searchController,
                        hintText: 'Search landmark, area or street...',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: AppColor.primaryBlue,
                        ),
                        suffixIcon: _isSearching
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                              )
                            : null,
                        onChanged: _onSearchChanged,
                      ),
                    ],
                  ),
                ),
              ),

              // Autocomplete Search Results Overlay
              if (_searchResults.isNotEmpty)
                Positioned(
                  top: 125,
                  left: 16,
                  right: 16,
                  child: Material(
                    color: surfaceColor,
                    elevation: 6,
                    borderRadius: BorderRadius.circular(14),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 220),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        separatorBuilder: (_, _) => Divider(
                          height: 1,
                          color: isDark
                              ? AppColor.darkBorder
                              : AppColor.lightBorder,
                        ),
                        itemBuilder: (context, index) {
                          final item = _searchResults[index];
                          final name = item['display_name'] as String? ?? '';
                          return ListTile(
                            dense: true,
                            leading: const Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: AppColor.primaryBlue,
                            ),
                            title: Text(
                              name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(
                                color: primaryTextColor,
                              ),
                            ),
                            onTap: () => _selectSearchResult(item),
                          );
                        },
                      ),
                    ),
                  ),
                ),

              // GPS "My Location" Floating Button
              Positioned(
                bottom: 230,
                right: 16,
                child: FloatingActionButton.small(
                  backgroundColor: surfaceColor,
                  foregroundColor: AppColor.primaryBlue,
                  elevation: 4,
                  onPressed: _isLocating ? null : _goToCurrentLocation,
                  child: _isLocating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location_rounded, size: 20),
                ),
              ),

              // Bottom Selected Location Card & Confirm Button
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.business_outlined,
                            size: 18,
                            color: AppColor.primaryBlue,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Selected Company Address',
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 14,
                              color: primaryTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          if (_isGeocoding)
                            const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _currentAddress,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          color: secondaryTextColor,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Coordinate Pills
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryBlue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColor.primaryBlue.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.gps_fixed_rounded,
                              size: 14,
                              color: AppColor.primaryBlue,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Lat: ${_currentCenter.latitude.toStringAsFixed(5)}, Lon: ${_currentCenter.longitude.toStringAsFixed(5)}',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColor.primaryBlue,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      PrimaryPillButton(
                        label: 'Confirm Company Location',
                        onPressed: () {
                          String? pincode = _currentPincode?.trim();
                          if (pincode == null || pincode.isEmpty) {
                            final pinMatch = RegExp(r'\b([1-9][0-9]{5})\b').firstMatch(_currentAddress);
                            if (pinMatch != null) {
                              pincode = pinMatch.group(1);
                            }
                          }

                          Navigator.of(context).pop(
                            LocationPickerResult(
                              address: _currentAddress,
                              latitude: _currentCenter.latitude,
                              longitude: _currentCenter.longitude,
                              pincode: pincode,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
