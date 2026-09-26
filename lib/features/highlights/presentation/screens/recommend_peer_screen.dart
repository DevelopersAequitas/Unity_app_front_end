import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cache/hive_cache_store.dart';
import '../../../../core/datasources/location_remote_datasource.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/paywall_gate_helper.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/city_picker_sheet.dart';
import '../../../../core/widgets/contact_picker_sheet.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../auth/data/datasources/auth_remote_datasource.dart';
import '../../../auth/domain/entities/category_item_entity.dart';
import '../../../auth/presentation/widgets/category_picker_sheet.dart';
import '../../domain/entities/peer_recommendation_entity.dart';
import '../bloc/recommend_peer/recommend_peer_bloc.dart';
import '../bloc/recommend_peer/recommend_peer_event.dart';
import '../bloc/recommend_peer/recommend_peer_state.dart';
import '../widgets/certification_info_banner.dart';
import '../widgets/recommend_peer_bottom_nav.dart';
import '../widgets/recommend_peer_form_fields.dart';
import '../widgets/recommend_peer_history_list.dart';
import 'recommend_peer_history_screen.dart';

class RecommendPeerScreen extends StatefulWidget {
  final String? initialCategory;
  final int? initialCategoryId;
  final String? initialCircleId;
  final String? initialCircleName;

  const RecommendPeerScreen({
    super.key,
    this.initialCategory,
    this.initialCategoryId,
    this.initialCircleId,
    this.initialCircleName,
  });

  @override
  State<RecommendPeerScreen> createState() => _RecommendPeerScreenState();
}

class _RecommendPeerScreenState extends State<RecommendPeerScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentIndex = 0;

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _businessController = TextEditingController();
  final _whyController = TextEditingController();
  final _noteController = TextEditingController();
  final _otherCategoryController = TextEditingController();

  late final AuthRemoteDataSource _authDataSource;
  late final LocationRemoteDataSource _locationDataSource;

  List<CategoryItemEntity> _mainCategories = [];
  List<CategoryItemEntity> _subCategories = [];
  int? _mainCategoryId;
  String? _mainCategoryName;
  dynamic _subCategoryId;
  String? _subCategoryName;
  bool _isOtherCategory = false;
  bool _isLoadingSubs = false;
  String _howWellKnown = 'business_associate';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging && mounted) {
        setState(() => _currentIndex = _tabController.index);
      }
    });

    _authDataSource = AuthRemoteDataSourceImpl(
      dioClient: DioClient(cacheStore: HiveCacheStore()),
    );
    _locationDataSource = LocationRemoteDataSourceImpl(
      dioClient: DioClient(),
    );

    _mainCategoryId = widget.initialCategoryId;
    _mainCategoryName = widget.initialCategory;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadCategories();
      context
          .read<RecommendPeerBloc>()
          .add(const FetchPeerRecommendationsHistoryEvent());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _businessController.dispose();
    _whyController.dispose();
    _noteController.dispose();
    _otherCategoryController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final items = await _authDataSource.getMainBusinessCategories();
      if (!mounted) return;
      final mainCategories = items.map((e) => e.toEntity()).toList();
      setState(() => _mainCategories = mainCategories);

      if (_mainCategoryId != null ||
          (_mainCategoryName != null && _mainCategoryName!.isNotEmpty)) {
        final matched = mainCategories.cast<CategoryItemEntity?>().firstWhere(
              (c) =>
                  c?.id == _mainCategoryId ||
                  (c != null &&
                      _mainCategoryName != null &&
                      c.name.trim().toLowerCase() ==
                          _mainCategoryName!.trim().toLowerCase()),
              orElse: () => null,
            );
        if (matched != null) {
          final id = matched.id is int
              ? matched.id as int
              : int.tryParse(matched.id.toString());
          setState(() {
            _mainCategoryId = id;
            _mainCategoryName = matched.name;
          });
          if (id != null) {
            _loadSubcategories(id);
          }
        }
      }
    } catch (_) {}
  }

  Future<void> _loadSubcategories(int mainCatId) async {
    setState(() => _isLoadingSubs = true);
    try {
      final subs = await _authDataSource.getSubcategories(mainCatId);
      if (mounted) {
        setState(() {
          _subCategories = subs.map((e) => e.toEntity()).toList();
          _isLoadingSubs = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingSubs = false);
    }
  }

  Future<void> _pickMainCategory() async {
    final picked = await CategoryPickerSheet.show(
      context,
      title: 'Select Business Category',
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
        _isOtherCategory = false;
        _otherCategoryController.clear();
        _subCategories = [];
      });
      if (id != null) {
        _loadSubcategories(id);
      }
    }
  }

  Future<void> _pickSubCategory() async {
    if (_mainCategoryId == null &&
        (_mainCategoryName == null || _mainCategoryName!.isEmpty)) {
      AppSnackBar.showError(
        context,
        'Please select Main Business Category first',
      );
      await _pickMainCategory();
      if (_mainCategoryId == null || !mounted) return;
    }
    if (_isLoadingSubs) return;
    if (!mounted) return;

    final picked = await CategoryPickerSheet.show(
      context,
      title: 'Select Subcategory / Specialization',
      categories: _subCategories,
      selectedId: _isOtherCategory ? 'other' : _subCategoryId,
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
          _isOtherCategory = true;
          _otherCategoryController.clear();
        } else {
          _subCategoryId = picked.id;
          _subCategoryName = picked.name;
          _isOtherCategory = false;
          _otherCategoryController.clear();
        }
      });
    }
  }

  Future<void> _pickCity() async {
    final picked = await CityPickerSheet.show(
      context,
      dataSource: _locationDataSource,
    );
    if (picked != null && mounted) {
      final cityPart = picked.name.isNotEmpty ? picked.name : picked.label;
      final statePart =
          picked.state.isNotEmpty ? picked.state : picked.stateCode;
      final countryPart =
          picked.country.isNotEmpty ? picked.country : picked.countryCode;
      final fullCity = picked.formattedLocation.isNotEmpty
          ? picked.formattedLocation
          : [
              cityPart,
              statePart,
              countryPart,
            ].where((s) => s.trim().isNotEmpty).join(', ');
      setState(() => _cityController.text = fullCity);
    }
  }

  Future<void> _pickFromContacts() async {
    final contact = await ContactPickerSheet.pickContact(context);
    if (contact != null && mounted) {
      setState(() {
        if (contact.name.isNotEmpty) {
          _nameController.text = contact.name;
        }
        if (contact.phone.isNotEmpty) {
          _mobileController.text = contact.phone;
        }
        if (contact.email?.isNotEmpty == true) {
          _emailController.text = contact.email!;
        }
        if (contact.company?.isNotEmpty == true) {
          _businessController.text = contact.company!;
        }
        if (contact.address?.isNotEmpty == true) {
          _cityController.text = contact.address!;
        }
      });
    }
  }

  void _clearForm() {
    _nameController.clear();
    _mobileController.clear();
    _emailController.clear();
    _cityController.clear();
    _businessController.clear();
    _whyController.clear();
    _noteController.clear();
    _otherCategoryController.clear();
    setState(() {
      _mainCategoryId = null;
      _mainCategoryName = null;
      _subCategoryId = null;
      _subCategoryName = null;
      _isOtherCategory = false;
      _howWellKnown = 'business_associate';
    });
  }

  void _submit(BuildContext context) {
    if (!PaywallGateHelper.checkPro(
      context,
      message: 'Upgrade to Pro to recommend peers.',
    )) {
      return;
    }

    final name = _nameController.text.trim();
    final mobile = _mobileController.text.trim();

    if (name.isEmpty) {
      AppSnackBar.showError(context, 'Please enter the peer full name.');
      return;
    }
    if (mobile.isEmpty) {
      AppSnackBar.showError(context, 'Please enter the peer mobile number.');
      return;
    }

    final digitsOnly = mobile.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 7 || digitsOnly.length > 15) {
      AppSnackBar.showError(
        context,
        'Please enter a valid peer mobile number.',
      );
      return;
    }

    final subCategoryEffective = _isOtherCategory
        ? (_otherCategoryController.text.trim().isNotEmpty
            ? _otherCategoryController.text.trim()
            : 'Other')
        : _subCategoryName;

    final entity = PeerRecommendationEntity(
      peerName: name,
      peerMobile: mobile,
      peerEmail: _emailController.text.trim(),
      peerCityCountry: _cityController.text.trim(),
      peerBusiness: _businessController.text.trim(),
      mainCategoryId: _mainCategoryId,
      mainCategoryName: _mainCategoryName,
      subCategoryId: _subCategoryId,
      subCategoryName: subCategoryEffective,
      peerCategory: _mainCategoryName,
      howWellKnown: _howWellKnown,
      isAware: true,
      whyValuable: _whyController.text.trim(),
      note: _noteController.text.trim(),
      circleId: widget.initialCircleId,
      circleName: widget.initialCircleName,
    );

    context.read<RecommendPeerBloc>().add(
          SubmitPeerRecommendationEvent(entity),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: 'Recommend a Peer',
        showBack: Navigator.canPop(context),
        onBackTap:
            Navigator.canPop(context) ? () => Navigator.pop(context) : null,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.history_rounded,
              color: AppColor.primaryBlue,
              size: 24,
            ),
            tooltip: 'View Past Recommendations',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecommendPeerHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: RecommendPeerBottomNav(
        activeIndex: _currentIndex,
        onIndexChanged: (idx) {
          setState(() => _currentIndex = idx);
          _tabController.animateTo(idx);
        },
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: BlocConsumer<RecommendPeerBloc, RecommendPeerState>(
            listener: (context, state) {
              if (state.status == RecommendPeerStatus.success &&
                  state.successMessage != null) {
                AppSnackBar.showSuccess(context, state.successMessage!);
                _clearForm();
                setState(() => _currentIndex = 1);
                _tabController.animateTo(1);
              } else if (state.errorMessage != null) {
                AppSnackBar.showError(context, state.errorMessage!);
              }
            },
            builder: (context, state) {
              final isSubmitting =
                  state.status == RecommendPeerStatus.submitting;

              return TabBarView(
                controller: _tabController,
                children: [
                  ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    children: [
                      const CertificationInfoBanner(
                        title: 'Recommend High-Caliber Peers',
                        description:
                            'Introduce trusted entrepreneurs, business leaders, and executives into the global network.',
                        icon: Icons.person_add_alt_1_rounded,
                      ),
                      const SizedBox(height: 16),
                      RecommendPeerFormFields(
                        nameController: _nameController,
                        mobileController: _mobileController,
                        emailController: _emailController,
                        cityController: _cityController,
                        businessController: _businessController,
                        whyController: _whyController,
                        noteController: _noteController,
                        otherCategoryController: _otherCategoryController,
                        mainCategoryName: _mainCategoryName,
                        subCategoryName: _subCategoryName,
                        isOtherCategory: _isOtherCategory,
                        isLoadingSubs: _isLoadingSubs,
                        howWellKnown: _howWellKnown,
                        onHowWellKnownChanged: (val) => val != null
                            ? setState(() => _howWellKnown = val)
                            : null,
                        onPickContact: _pickFromContacts,
                        onPickCity: _pickCity,
                        onSelectMainCategory: _pickMainCategory,
                        onSelectSubCategory: _pickSubCategory,
                        initialCircleName: widget.initialCircleName,
                        initialCategory: widget.initialCategory,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isSubmitting ? null : () => _submit(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isSubmitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Submit Recommendation',
                                  style: AppTypography.labelLarge.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                  RecommendPeerHistoryList(
                    history: state.history,
                    isLoading: state.historyStatus ==
                        RecommendPeerHistoryStatus.loading,
                    onRefresh: () async {
                      context.read<RecommendPeerBloc>().add(
                            const RefreshPeerRecommendationsHistoryEvent(),
                          );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
