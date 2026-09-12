import 'package:flutter/material.dart';
import '../../../../core/cache/hive_cache_store.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/data/datasources/auth_remote_datasource.dart';
import '../../../auth/domain/entities/category_item_entity.dart';
import '../../../auth/presentation/widgets/category_picker_sheet.dart';

class CategorySelectionResult {
  final int? mainCategoryId;
  final String? mainCategoryName;
  final dynamic subCategoryId;
  final String? subCategoryName;
  final bool isOther;
  final String? otherCategoryName;

  const CategorySelectionResult({
    this.mainCategoryId,
    this.mainCategoryName,
    this.subCategoryId,
    this.subCategoryName,
    this.isOther = false,
    this.otherCategoryName,
  });
}

class BusinessCategorySelector extends StatefulWidget {
  final int? initialMainCategoryId;
  final String? initialMainCategory;
  final dynamic initialSubCategoryId;
  final String? initialSubCategory;
  final String? initialOtherCategory;
  final bool isInitialOther;
  final ValueChanged<CategorySelectionResult> onChanged;

  const BusinessCategorySelector({
    super.key,
    this.initialMainCategoryId,
    this.initialMainCategory,
    this.initialSubCategoryId,
    this.initialSubCategory,
    this.initialOtherCategory,
    this.isInitialOther = false,
    required this.onChanged,
  });

  @override
  State<BusinessCategorySelector> createState() => _BusinessCategorySelectorState();
}

class _BusinessCategorySelectorState extends State<BusinessCategorySelector> {
  late final AuthRemoteDataSource _authDataSource;
  List<CategoryItemEntity> _mainCategories = [];
  List<CategoryItemEntity> _subCategories = [];

  int? _mainCategoryId;
  String? _mainCategoryName;
  dynamic _subCategoryId;
  String? _subCategoryName;
  bool _isOther = false;
  bool _isLoadingSubs = false;
  late TextEditingController _otherController;

  @override
  void initState() {
    super.initState();
    _authDataSource = AuthRemoteDataSourceImpl(
      dioClient: DioClient(cacheStore: HiveCacheStore()),
    );

    _mainCategoryId = widget.initialMainCategoryId;
    _mainCategoryName = widget.initialMainCategory;
    _subCategoryId = widget.initialSubCategoryId;
    _subCategoryName = widget.initialSubCategory;
    _isOther = widget.isInitialOther;

    final hasOtherText = widget.initialOtherCategory != null &&
        widget.initialOtherCategory!.trim().isNotEmpty;
    _otherController = TextEditingController(
      text: hasOtherText
          ? widget.initialOtherCategory
          : (widget.isInitialOther ? (widget.initialSubCategory ?? '') : ''),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadInitialCategories();
    });
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  String _normalize(String s) {
    return s
        .replaceAll('&amp;', '&')
        .replaceAll(' and ', ' & ')
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .toLowerCase();
  }

  Future<void> _loadInitialCategories() async {
    try {
      final items = await _authDataSource.getMainBusinessCategories();
      if (!mounted) return;
      final mainCategories = items.map((e) => e.toEntity()).toList();
      setState(() => _mainCategories = mainCategories);

      CategoryItemEntity? matchedMain;

      // Step 1: Match main category by ID
      if (widget.initialMainCategoryId != null) {
        matchedMain = mainCategories.cast<CategoryItemEntity?>().firstWhere(
              (c) =>
                  c?.id == widget.initialMainCategoryId ||
                  c?.id?.toString() == widget.initialMainCategoryId.toString(),
              orElse: () => null,
            );
      }

      // Step 2: Match main category by normalized name
      if (matchedMain == null &&
          widget.initialMainCategory != null &&
          widget.initialMainCategory!.trim().isNotEmpty) {
        final normMain = _normalize(widget.initialMainCategory!);
        matchedMain = mainCategories.cast<CategoryItemEntity?>().firstWhere(
              (c) => c != null && _normalize(c.name) == normMain,
              orElse: () => null,
            );
      }

      // Step 3: Reverse Subcategory Lookup if main is still not matched
      final initialSubName = widget.initialSubCategory?.trim() ??
          widget.initialOtherCategory?.trim();
      final initialSubId = widget.initialSubCategoryId;

      if (matchedMain == null &&
          (initialSubId != null || (initialSubName != null && initialSubName.isNotEmpty))) {
        final normSub = initialSubName != null ? _normalize(initialSubName) : null;

        for (final mainCat in mainCategories) {
          final mainCatId = mainCat.id is int
              ? mainCat.id as int
              : int.tryParse(mainCat.id.toString());
          if (mainCatId == null) continue;

          final subs = await _authDataSource.getSubcategories(mainCatId);
          if (!mounted) return;

          final subEntities = subs.map((e) => e.toEntity()).toList();
          final foundSub = subEntities.cast<CategoryItemEntity?>().firstWhere(
                (s) =>
                    s != null &&
                    !s.isOther &&
                    s.name.trim().toLowerCase() != 'other' &&
                    s.name.trim().toLowerCase() != 'others' &&
                    ((initialSubId != null &&
                            s.id.toString() == initialSubId.toString()) ||
                        (normSub != null && _normalize(s.name) == normSub)),
                orElse: () => null,
              );

          if (foundSub != null) {
            matchedMain = mainCat;
            setState(() {
              _mainCategoryId = mainCatId;
              _mainCategoryName = mainCat.name;
              _subCategories = subEntities;
              _subCategoryId = foundSub.id;
              _subCategoryName = foundSub.name;
              _isOther = false;
              _otherController.clear();
            });
            _notify();
            break;
          }
        }
      }

      // If matched in Step 1 or Step 2, load subcategories now
      if (matchedMain != null && _subCategories.isEmpty) {
        final mainCatId = matchedMain.id is int
            ? matchedMain.id as int
            : int.tryParse(matchedMain.id.toString());

        setState(() {
          _mainCategoryId = mainCatId;
          _mainCategoryName = matchedMain!.name;
          _isLoadingSubs = true;
        });

        if (mainCatId != null) {
          final subs = await _authDataSource.getSubcategories(mainCatId);
          if (!mounted) return;
          final subEntities = subs.map((e) => e.toEntity()).toList();

          setState(() {
            _subCategories = subEntities;
            _isLoadingSubs = false;
          });

          // Match subcategory
          if (initialSubId != null ||
              (initialSubName != null && initialSubName.isNotEmpty)) {
            final normSub =
                initialSubName != null ? _normalize(initialSubName) : null;
            final matchedSub =
                subEntities.cast<CategoryItemEntity?>().firstWhere(
                      (s) =>
                          s != null &&
                          !s.isOther &&
                          s.name.trim().toLowerCase() != 'other' &&
                          s.name.trim().toLowerCase() != 'others' &&
                          ((initialSubId != null &&
                                  s.id.toString() == initialSubId.toString()) ||
                              (normSub != null &&
                                  _normalize(s.name) == normSub)),
                      orElse: () => null,
                    );

            if (matchedSub != null) {
              setState(() {
                _subCategoryId = matchedSub.id;
                _subCategoryName = matchedSub.name;
                _isOther = false;
                _otherController.clear();
              });
              _notify();
            } else if (widget.isInitialOther ||
                initialSubName?.toLowerCase() == 'other') {
              setState(() {
                _isOther = true;
                _subCategoryId = 'other';
                _subCategoryName = 'Other';
              });
              _notify();
            }
          }
        } else {
          setState(() => _isLoadingSubs = false);
        }
      }
    } catch (_) {}
  }

  Future<void> _pickMainCategory() async {
    final picked = await CategoryPickerSheet.show(
      context,
      title: 'Select Main Business Category',
      categories: _mainCategories,
      selectedId: _mainCategoryId,
    );
    if (picked != null && mounted) {
      final id = picked.id is int
          ? picked.id as int
          : int.tryParse(picked.id.toString());
      setState(() {
        _mainCategoryId = id;
        _mainCategoryName = picked.name;
        _subCategoryId = null;
        _subCategoryName = null;
        _isOther = false;
        _otherController.clear();
        _subCategories = [];
        _isLoadingSubs = true;
      });
      _notify();

      if (id != null) {
        try {
          final subs = await _authDataSource.getSubcategories(id);
          if (mounted) {
            setState(() {
              _subCategories = subs.map((e) => e.toEntity()).toList();
              _isLoadingSubs = false;
            });
          }
        } catch (_) {
          if (mounted) setState(() => _isLoadingSubs = false);
        }
      } else {
        setState(() => _isLoadingSubs = false);
      }
    }
  }

  Future<void> _pickSubCategory() async {
    if (_mainCategoryId == null &&
        (_mainCategoryName == null || _mainCategoryName!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select Main Business Category first'),
        ),
      );
      await _pickMainCategory();
      if (_mainCategoryId == null || !mounted) return;
    }
    if (_isLoadingSubs) return;
    if (!mounted) return;

    final picked = await CategoryPickerSheet.show(
      context,
      title: 'Select Sub Business Category',
      categories: _subCategories,
      selectedId: _isOther ? 'other' : _subCategoryId,
    );
    if (picked != null && mounted) {
      final isOtherChoice = picked.isOther ||
          picked.id == 'other' ||
          picked.id == -1 ||
          picked.name.trim().toLowerCase() == 'other' ||
          picked.name.trim().toLowerCase() == 'others';

      setState(() {
        if (isOtherChoice) {
          _subCategoryId = 'other';
          _subCategoryName = 'Other';
          _isOther = true;
          _otherController.clear();
        } else {
          _subCategoryId = picked.id;
          _subCategoryName = picked.name;
          _isOther = false;
          _otherController.clear();
        }
      });
      _notify();
    }
  }

  void _notify() {
    widget.onChanged(
      CategorySelectionResult(
        mainCategoryId: _mainCategoryId,
        mainCategoryName: _mainCategoryName,
        subCategoryId: _subCategoryId,
        subCategoryName: _isOther
            ? (_otherController.text.trim().isNotEmpty
                ? _otherController.text.trim()
                : 'Other')
            : _subCategoryName,
        isOther: _isOther,
        otherCategoryName: _isOther ? _otherController.text.trim() : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownTile(
          label: 'Main Business Category',
          value: _mainCategoryName,
          icon: Icons.apartment_outlined,
          onTap: _pickMainCategory,
        ),
        const SizedBox(height: 12),
        _buildDropdownTile(
          label: _isLoadingSubs
              ? 'Loading Subcategories...'
              : 'Subcategory / Specialization',
          value: _isOther ? 'Other' : _subCategoryName,
          icon: Icons.local_offer_outlined,
          onTap: _pickSubCategory,
        ),
        if (_isOther) ...[
          const SizedBox(height: 12),
          TextFormField(
            controller: _otherController,
            onChanged: (_) => _notify(),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColor.lightTextPrimary,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColor.white,
              hintText: 'Enter your custom specialization / category',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColor.lightTextDisabled,
              ),
              prefixIcon: const Icon(
                Icons.edit_note_outlined,
                size: 20,
                color: AppColor.lightTextTertiary,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColor.lightBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColor.lightBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColor.primaryBlue),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDropdownTile({
    required String label,
    required String? value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final hasVal = value != null && value.isNotEmpty;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.lightBorder),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColor.lightTextTertiary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hasVal ? value : label,
                style: AppTypography.bodyMedium.copyWith(
                  color: hasVal
                      ? AppColor.lightTextPrimary
                      : AppColor.lightTextDisabled,
                  fontWeight: hasVal ? FontWeight.w500 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: AppColor.lightTextTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
