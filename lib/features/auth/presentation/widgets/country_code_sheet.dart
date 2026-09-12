import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/datasources/location_remote_datasource.dart';
import '../../../../core/models/country_entity.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';

class CountryCodeSheet extends StatefulWidget {
  final String selectedCode;
  final LocationRemoteDataSource? dataSource;

  const CountryCodeSheet({
    super.key,
    required this.selectedCode,
    this.dataSource,
  });

  static const List<CountryEntity> fallbackCountries = [
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
    CountryEntity(name: 'Singapore', code: 'SG', dialCode: '+65', flag: '🇸🇬'),
    CountryEntity(name: 'Australia', code: 'AU', dialCode: '+61', flag: '🇦🇺'),
    CountryEntity(name: 'Canada', code: 'CA', dialCode: '+1', flag: '🇨🇦'),
    CountryEntity(name: 'Germany', code: 'DE', dialCode: '+49', flag: '🇩🇪'),
  ];

  static Future<CountryEntity?> show(
    BuildContext context,
    String currentCode, [
    LocationRemoteDataSource? dataSource,
  ]) {
    return showModalBottomSheet<CountryEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) =>
          CountryCodeSheet(selectedCode: currentCode, dataSource: dataSource),
    );
  }

  @override
  State<CountryCodeSheet> createState() => _CountryCodeSheetState();
}

class _CountryCodeSheetState extends State<CountryCodeSheet> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  late final LocationRemoteDataSource _dataSource;
  Timer? _debounceTimer;

  List<CountryEntity> _countries = [];
  int _currentPage = 1;
  static const int _perPage = 20;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _dataSource =
        widget.dataSource ??
        LocationRemoteDataSourceImpl(dioClient: DioClient());
    _searchController.addListener(_onSearchInputChanged);
    _fetchInitialCountries();
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
      _fetchInitialCountries(query: _searchController.text.trim());
    });
  }

  Future<void> _fetchInitialCountries({String? query}) async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _hasMore = true;
    });

    final results = await _dataSource.getCountries(
      search: query,
      page: 1,
      perPage: _perPage,
    );

    if (mounted) {
      setState(() {
        _countries = results;
        _isLoading = false;
        _hasMore = results.isNotEmpty;
      });
    }
  }

  Future<void> _loadMoreCountries() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;

    setState(() => _isLoadingMore = true);
    final nextPage = _currentPage + 1;
    final results = await _dataSource.getCountries(
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
          _countries.addAll(results);
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
                      'Select Country Code',
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
                  hintText: 'Search country or code...',
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: AppColor.lightTextSecondary,
                  ),
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _countries.isEmpty
                    ? Center(
                        child: Text(
                          _searchController.text.trim().isNotEmpty
                              ? 'No countries matching "${_searchController.text.trim()}"'
                              : 'No countries found',
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
                              _loadMoreCountries();
                            }
                          }
                          return false;
                        },
                        child: ListView.separated(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount:
                              _countries.length + (_isLoadingMore ? 1 : 0),
                          separatorBuilder: (_, _) =>
                              Divider(height: 1, color: border),
                          itemBuilder: (context, index) {
                            if (index == _countries.length) {
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

                            final item = _countries[index];
                            final isSelected =
                                item.dialCode == widget.selectedCode;
                            return Material(
                              color: Colors.transparent,
                              child: ListTile(
                                leading: Text(
                                  item.flag.isNotEmpty ? item.flag : '🌐',
                                  style: const TextStyle(fontSize: 22),
                                ),
                                title: Text(
                                  item.name,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: primaryTextColor,
                                    fontWeight: isSelected
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item.dialCode,
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: isSelected
                                            ? AppColor.primaryBlue
                                            : secondaryTextColor,
                                        fontWeight: isSelected
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    if (isSelected) ...[
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        size: 18,
                                        color: AppColor.primaryBlue,
                                      ),
                                    ],
                                  ],
                                ),
                                onTap: () => Navigator.of(context).pop(item),
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
