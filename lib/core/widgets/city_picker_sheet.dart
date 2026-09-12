import 'dart:async';
import 'package:flutter/material.dart';
import '../datasources/location_remote_datasource.dart';
import '../models/city_entity.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';
import 'app_text_field.dart';

class CityPickerSheet extends StatefulWidget {
  final LocationRemoteDataSource dataSource;
  final String? selectedCityId;
  final ValueChanged<CityEntity> onSelect;

  const CityPickerSheet({
    super.key,
    required this.dataSource,
    this.selectedCityId,
    required this.onSelect,
  });

  static Future<CityEntity?> show(
    BuildContext context, {
    required LocationRemoteDataSource dataSource,
    String? selectedCityId,
  }) {
    return showModalBottomSheet<CityEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CityPickerSheet(
        dataSource: dataSource,
        selectedCityId: selectedCityId,
        onSelect: (city) => Navigator.of(ctx).pop(city),
      ),
    );
  }

  @override
  State<CityPickerSheet> createState() => _CityPickerSheetState();
}

class _CityPickerSheetState extends State<CityPickerSheet> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounceTimer;

  List<CityEntity> _cities = [];
  int _currentPage = 1;
  static const int _perPage = 20;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchInputChanged);
    _fetchInitialCities();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchInputChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      _fetchInitialCities(query: _searchController.text.trim());
    });
  }

  Future<void> _fetchInitialCities({String? query}) async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _hasMore = true;
    });

    final results = await widget.dataSource.getCities(
      search: query,
      page: 1,
      perPage: _perPage,
    );

    if (mounted) {
      setState(() {
        _cities = results;
        _isLoading = false;
        _hasMore = results.isNotEmpty;
      });
    }
  }

  Future<void> _loadMoreCities() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;

    setState(() => _isLoadingMore = true);
    final nextPage = _currentPage + 1;
    final results = await widget.dataSource.getCities(
      search: _searchController.text.trim(),
      page: nextPage,
      perPage: _perPage,
    );

    if (mounted) {
      setState(() {
        _isLoadingMore = false;
        if (results.isEmpty) {
          _hasMore = false;
        } else {
          _currentPage = nextPage;
          _cities.addAll(results);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final border = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final primaryTextColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;

    return Material(
      color: surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.78,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: secondaryTextColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    Text(
                      'Select City',
                      style: AppTypography.titleMedium.copyWith(
                        color: primaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: AppTextField(
                  controller: _searchController,
                  hintText: 'Search city...',
                  prefixIcon: const Icon(
                    Icons.location_city,
                    size: 20,
                    color: AppColor.lightTextSecondary,
                  ),
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _cities.isEmpty
                    ? Center(
                        child: Text(
                          _searchController.text.trim().isNotEmpty
                              ? 'No cities matching "${_searchController.text.trim()}"'
                              : 'No cities found',
                          style: AppTypography.bodyMedium.copyWith(
                            color: secondaryTextColor,
                          ),
                        ),
                      )
                    : NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (!_isLoading && !_isLoadingMore && _hasMore) {
                            if (scrollInfo.metrics.pixels >=
                                scrollInfo.metrics.maxScrollExtent - 250) {
                              _loadMoreCities();
                            }
                          }
                          return false;
                        },
                        child: ListView.separated(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _cities.length + (_isLoadingMore ? 1 : 0),
                          separatorBuilder: (_, _) =>
                              Divider(height: 1, color: border),
                          itemBuilder: (context, index) {
                            if (index == _cities.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final city = _cities[index];
                            final isSelected = widget.selectedCityId == city.id;
                            return Material(
                              color: Colors.transparent,
                              child: ListTile(
                                title: Text(
                                  city.label,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: primaryTextColor,
                                    fontWeight: isSelected
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                  ),
                                ),
                                subtitle: city.state.isNotEmpty
                                    ? Text(
                                        city.country.isNotEmpty
                                            ? '${city.state}, ${city.country}'
                                            : city.state,
                                        style: AppTypography.bodySmall.copyWith(
                                          color: secondaryTextColor,
                                        ),
                                      )
                                    : null,
                                trailing: isSelected
                                    ? const Icon(
                                        Icons.check_circle_rounded,
                                        size: 20,
                                        color: AppColor.primaryBlue,
                                      )
                                    : null,
                                onTap: () => widget.onSelect(city),
                              ),
                            );
                          },
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
