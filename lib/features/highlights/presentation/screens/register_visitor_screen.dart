import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/datasources/location_remote_datasource.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../../../core/utils/paywall_gate_helper.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/city_picker_sheet.dart';
import '../../../../core/widgets/contact_picker_sheet.dart';
import '../../domain/entities/event_item_entity.dart';
import '../../domain/entities/register_visitor_entity.dart';
import '../bloc/register_visitor/register_visitor_bloc.dart';
import '../bloc/register_visitor/register_visitor_event.dart';
import '../bloc/register_visitor/register_visitor_state.dart';
import '../widgets/event_picker_sheet.dart';
import '../widgets/register_visitor_bottom_nav.dart';
import '../widgets/register_visitor_form_tab.dart';
import '../widgets/register_visitor_history_list.dart';

class RegisterVisitorScreen extends StatefulWidget {
  const RegisterVisitorScreen({super.key});

  @override
  State<RegisterVisitorScreen> createState() => _RegisterVisitorScreenState();
}

class _RegisterVisitorScreenState extends State<RegisterVisitorScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentIndex = 0;
  final _formKey = GlobalKey<FormState>();

  final _eventNameController = TextEditingController();
  final _visitorFullNameController = TextEditingController();
  final _visitorMobileController = TextEditingController();
  final _visitorEmailController = TextEditingController();
  final _visitorCityController = TextEditingController();
  final _visitorBusinessController = TextEditingController();
  final _noteController = TextEditingController();
  String _eventType = 'physical';
  DateTime? _eventDate;
  String _howKnown = 'friend';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging && mounted) {
        setState(() => _currentIndex = _tabController.index);
      }
    });
    context.read<RegisterVisitorBloc>()
      ..add(const FetchRegisterVisitorHistoryEvent())
      ..add(const FetchEventsEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _eventNameController.dispose();
    _visitorFullNameController.dispose();
    _visitorMobileController.dispose();
    _visitorEmailController.dispose();
    _visitorCityController.dispose();
    _visitorBusinessController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickEventDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null && mounted) setState(() => _eventDate = picked);
  }

  Future<void> _pickFromEvents(
    List<EventItemEntity> events,
    bool isLoading,
  ) async {
    final picked = await EventPickerSheet.show(
      context: context,
      events: events,
      isLoading: isLoading,
    );
    if (picked != null && mounted) {
      setState(() {
        _eventNameController.text = picked.title;
        final parsed = AppDateFormatter.parseUtc(picked.startDate) ??
            AppDateFormatter.parseUtc(picked.startAt);
        if (parsed != null) _eventDate = parsed;
        _eventType = picked.isOnline ? 'online' : 'physical';
      });
    }
  }

  Future<void> _pickCity() async {
    final locationDataSource = LocationRemoteDataSourceImpl(
      dioClient: DioClient(),
    );
    final picked = await CityPickerSheet.show(
      context,
      dataSource: locationDataSource,
    );
    if (picked != null && mounted) {
      final cityPart = picked.name.isNotEmpty ? picked.name : picked.label;
      final statePart = picked.state.isNotEmpty
          ? picked.state
          : picked.stateCode;
      final countryPart = picked.country.isNotEmpty
          ? picked.country
          : picked.countryCode;
      final fullCity = picked.formattedLocation.isNotEmpty
          ? picked.formattedLocation
          : [
              cityPart,
              statePart,
              countryPart,
            ].where((s) => s.trim().isNotEmpty).join(', ');
      setState(() => _visitorCityController.text = fullCity);
    }
  }

  Future<void> _pickFromContacts() async {
    final contact = await ContactPickerSheet.pickContact(context);
    if (contact != null && mounted) {
      setState(() {
        if (contact.name.isNotEmpty) {
          _visitorFullNameController.text = contact.name;
        }
        if (contact.phone.isNotEmpty) {
          _visitorMobileController.text = contact.phone;
        }
        if (contact.email?.isNotEmpty == true) {
          _visitorEmailController.text = contact.email!;
        }
        if (contact.company?.isNotEmpty == true) {
          _visitorBusinessController.text = contact.company!;
        }
        if (contact.address?.isNotEmpty == true) {
          _visitorCityController.text = contact.address!;
        }
      });
    }
  }

  void _submit() {
    if (!PaywallGateHelper.checkPro(context, message: 'Upgrade to Pro to register visitors.')) {
      return;
    }

    if (_eventNameController.text.trim().isEmpty) {
      AppSnackBar.showError(context, 'Please select or enter event name.');
      return;
    }
    if (_eventDate == null) {
      AppSnackBar.showError(context, 'Please select the event date.');
      return;
    }
    if (_visitorFullNameController.text.trim().isEmpty) {
      AppSnackBar.showError(context, 'Please enter visitor full name.');
      return;
    }
    if (_visitorMobileController.text.trim().isEmpty) {
      AppSnackBar.showError(context, 'Please enter visitor mobile number.');
      return;
    }
    if (_visitorCityController.text.trim().isEmpty) {
      AppSnackBar.showError(context, 'Please select or enter visitor city.');
      return;
    }
    if (_visitorBusinessController.text.trim().isEmpty) {
      AppSnackBar.showError(
        context,
        'Please enter visitor business / profession.',
      );
      return;
    }

    final entity = RegisterVisitorEntity(
      eventType: _eventType,
      eventName: _eventNameController.text.trim(),
      eventDate: AppDateFormatter.toUtcDateString(_eventDate!),
      visitorFullName: _visitorFullNameController.text.trim(),
      visitorMobile: _visitorMobileController.text.trim(),
      visitorEmail: _visitorEmailController.text.trim(),
      howKnown: _howKnown,
      visitorCity: _visitorCityController.text.trim(),
      visitorBusiness: _visitorBusinessController.text.trim(),
      note: _noteController.text.trim(),
    );

    context.read<RegisterVisitorBloc>().add(SubmitRegisterVisitorEvent(entity));
  }

  void _clearForm() {
    _eventNameController.clear();
    _visitorFullNameController.clear();
    _visitorMobileController.clear();
    _visitorEmailController.clear();
    _visitorCityController.clear();
    _visitorBusinessController.clear();
    _noteController.clear();
    setState(() {
      _eventDate = null;
      _eventType = 'physical';
      _howKnown = 'friend';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: 'Register A Visitor',
        showBack: Navigator.canPop(context),
        onBackTap: Navigator.canPop(context)
            ? () => Navigator.pop(context)
            : null,
      ),
      bottomNavigationBar: RegisterVisitorBottomNav(
        activeIndex: _currentIndex,
        onIndexChanged: (idx) {
          setState(() => _currentIndex = idx);
          _tabController.animateTo(idx);
        },
      ),
      body: AppGradientBackground(
        child: BlocConsumer<RegisterVisitorBloc, RegisterVisitorState>(
          listener: (context, state) {
            if (state.successMessage != null) {
              AppSnackBar.showSuccess(context, state.successMessage!);
              _clearForm();
              _tabController.animateTo(1);
            } else if (state.errorMessage != null) {
              AppSnackBar.showError(context, state.errorMessage!);
            }
          },
          builder: (context, state) {
            return TabBarView(
              controller: _tabController,
              children: [
                RegisterVisitorFormTab(
                  formKey: _formKey,
                  eventNameController: _eventNameController,
                  visitorFullNameController: _visitorFullNameController,
                  visitorMobileController: _visitorMobileController,
                  visitorEmailController: _visitorEmailController,
                  visitorCityController: _visitorCityController,
                  visitorBusinessController: _visitorBusinessController,
                  noteController: _noteController,
                  eventType: _eventType,
                  onEventTypeChanged: (val) => setState(() => _eventType = val),
                  eventDate: _eventDate,
                  onPickDate: _pickEventDate,
                  onPickEvent: () => _pickFromEvents(
                    state.events,
                    state.eventsStatus == RegisterVisitorStatus.loading,
                  ),
                  onPickCity: _pickCity,
                  howKnown: _howKnown,
                  onHowKnownChanged: (val) => setState(() => _howKnown = val),
                  onPickContact: _pickFromContacts,
                  state: state,
                  onSubmit: _submit,
                ),
                RegisterVisitorHistoryList(
                  submissions: state.submissions,
                  isLoading: state.status == RegisterVisitorStatus.loading,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
