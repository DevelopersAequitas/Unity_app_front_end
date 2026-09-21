import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/features/events/domain/entities/event_registration_entity.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../circles/domain/entities/circle_open_category_entity.dart';
import '../../../circles/domain/entities/flat_open_category_item.dart';
import '../../../circles/domain/usecases/get_circle_open_categories_usecase.dart';
import '../../../circles/presentation/bloc/circles_bloc.dart';
import '../../../circles/presentation/bloc/circles_event.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../domain/entities/event_entity.dart';
import '../bloc/event_detail_bloc.dart';
import '../bloc/event_detail_event.dart';
import '../bloc/event_detail_state.dart';
import '../utils/event_share_helper.dart';
import '../widgets/event_category_picker_sheet.dart';
import '../widgets/event_detail_bottom_bar.dart';
import '../widgets/event_detail_header_image.dart';
import '../widgets/event_detail_info_section.dart';
import '../widgets/event_detail_organized_by.dart';
import '../widgets/event_request_bottom_sheet.dart';

class EventDetailScreen extends StatefulWidget {
  final EventEntity event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  FlatOpenCategoryItem? _selectedCategory;
  List<FlatOpenCategoryItem> _circleCategories = [];
  Timer? _realtimePollTimer;

  @override
  void initState() {
    super.initState();
    context.read<EventDetailBloc>().add(LoadEventDetailEvent(
          eventId: widget.event.eventId,
          occurrenceId: widget.event.occurrenceId,
        ));

    final profileState = context.read<ProfileBloc>().state;
    if (profileState.profile == null) {
      context.read<ProfileBloc>().add(const ProfileFetchRequested());
    }
    final circlesState = context.read<CirclesBloc>().state;
    if (circlesState.myCircles.isEmpty) {
      context.read<CirclesBloc>().add(const CirclesFetchRequested());
    }

    _startRealtimePolling();
  }

  void _startRealtimePolling() {
    _realtimePollTimer?.cancel();
    _realtimePollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final bloc = context.read<EventDetailBloc>();
      final state = bloc.state;
      if (state.isRegistering) return;

      final regId = state.registration?.registrationId ?? widget.event.userRegistration?.registrationId;
      final regStatus = state.registration?.status ?? state.event?.userRegistration?.status ?? widget.event.userRegistration?.status;

      if (regId != null && regId.isNotEmpty && (regStatus == 'pending_payment' || state.status == EventDetailStatus.paymentRequired)) {
        bloc.add(PollPaymentStatusEvent(regId));
      }

      bloc.add(LoadEventDetailEvent(
        eventId: widget.event.eventId,
        occurrenceId: widget.event.occurrenceId,
        isRefresh: true,
      ));
    });
  }

  @override
  void dispose() {
    _realtimePollTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadCircleCategories([String? circleIdOverride]) async {
    final cId = circleIdOverride ??
        widget.event.circleId ??
        (widget.event.circleIds.isNotEmpty ? widget.event.circleIds.first : null) ??
        widget.event.circle?.id;
    if (cId == null || cId.isEmpty) return;
    try {
      final useCase = context.read<GetCircleOpenCategoriesUseCase>();
      final open = await useCase(cId).catchError((_) => <CircleOpenCategoryEntity>[]);
      final flat = <FlatOpenCategoryItem>[];

      void extractLeafs(
        List<CircleOpenCategoryEntity> nodes, {
        String? sector,
        String? subcategory,
      }) {
        for (final node in nodes) {
          if (node.children.isEmpty) {
            if (!node.isClosed) {
              flat.add(FlatOpenCategoryItem(
                id: node.id,
                name: node.name,
                sectorName: sector ?? node.name,
                subcategoryName: subcategory,
              ));
            }
          } else {
            extractLeafs(
              node.children,
              sector: sector ?? node.name,
              subcategory: sector != null ? (subcategory ?? node.name) : null,
            );
          }
        }
      }

      extractLeafs(open);
      if (mounted) setState(() => _circleCategories = flat);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileBloc>().state.profile;
    final myCircles = context.watch<CirclesBloc>().state.myCircles;
    final isPro = profile?.isPro ?? false;
    final userCircleMemberships = profile?.circleMemberships ?? [];

    return BlocConsumer<EventDetailBloc, EventDetailState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
        }
        if (state.successMessage != null) {
          AppSnackBar.showSuccess(context, state.successMessage!);
        }
        if (state.status == EventDetailStatus.paymentRequired && state.registration != null) {
          _handlePayment(state, widget.event);
        }
        if (state.event != null && _circleCategories.isEmpty) {
          final event = state.event!;
          final eventCircleIds = <String>{
            if (event.circle?.id != null && event.circle!.id.isNotEmpty) event.circle!.id.trim(),
            if (event.circleId != null && event.circleId!.isNotEmpty) event.circleId!.trim(),
            ...event.circleIds.map((id) => id.trim()).where((id) => id.isNotEmpty),
            ...event.circles.map((c) => c.id.trim()).where((id) => id.isNotEmpty),
          };
          final userCircleIds = <String>{
            if (profile?.activeCircleId != null && profile!.activeCircleId!.isNotEmpty)
              profile.activeCircleId!.trim(),
            if (profile?.activeCircle?.id != null && profile!.activeCircle!.id.isNotEmpty)
              profile.activeCircle!.id.trim(),
            ...userCircleMemberships.map((m) => m.circleId.trim()).where((id) => id.isNotEmpty),
            ...profile?.categories.map((c) => c.circleId.trim()).where((id) => id.isNotEmpty) ?? [],
            ...myCircles.map((c) => c.id.trim()).where((id) => id.isNotEmpty),
          };
          final userCircleNames = <String>{
            if (profile?.activeCircle?.name != null) profile!.activeCircle!.name.toLowerCase().trim(),
            ...userCircleMemberships.map((m) => m.circleName.toLowerCase().trim()).where((n) => n.isNotEmpty),
            ...userCircleMemberships.map((m) => (m.circleSlug ?? '').toLowerCase().trim()).where((s) => s.isNotEmpty),
            ...myCircles.map((c) => c.name.toLowerCase().trim()).where((n) => n.isNotEmpty),
            ...myCircles.map((c) => (c.slug ?? '').toLowerCase().trim()).where((s) => s.isNotEmpty),
          };
          final eventCircleName = (event.circle?.name ?? '').toLowerCase().trim();
          final eventCircleSlug = (event.circle?.slug ?? '').toLowerCase().trim();

          final isSame = eventCircleIds.any((id) => userCircleIds.contains(id)) ||
              (eventCircleName.isNotEmpty && userCircleNames.contains(eventCircleName)) ||
              (eventCircleSlug.isNotEmpty && userCircleNames.contains(eventCircleSlug));

          if (!isSame && eventCircleIds.isNotEmpty) {
            _loadCircleCategories(eventCircleIds.first);
          }
        }
      },
      builder: (context, state) {
        // Merge image URL and details to avoid losing image from list state
        final currentEvent = state.event != null
            ? ((state.event!.imageUrl == null || state.event!.imageUrl!.isEmpty) && widget.event.imageUrl != null
                ? state.event!.copyWith(imageUrl: widget.event.imageUrl)
                : state.event!)
            : widget.event;

        final userJoinedCircleIds = <String>{
          if (profile?.activeCircleId != null && profile!.activeCircleId!.isNotEmpty)
            profile.activeCircleId!.trim(),
          if (profile?.activeCircle?.id != null && profile!.activeCircle!.id.isNotEmpty)
            profile.activeCircle!.id.trim(),
          ...userCircleMemberships.map((m) => m.circleId.trim()).where((id) => id.isNotEmpty),
          ...profile?.categories.map((c) => c.circleId.trim()).where((id) => id.isNotEmpty) ?? [],
          ...myCircles.map((c) => c.id.trim()).where((id) => id.isNotEmpty),
        };

        final eventCircleIds = <String>{
          if (currentEvent.circle?.id != null && currentEvent.circle!.id.isNotEmpty)
            currentEvent.circle!.id.trim(),
          if (currentEvent.circleId != null && currentEvent.circleId!.isNotEmpty)
            currentEvent.circleId!.trim(),
          ...currentEvent.circleIds.map((id) => id.trim()).where((id) => id.isNotEmpty),
          ...currentEvent.circles.map((c) => c.id.trim()).where((id) => id.isNotEmpty),
        };

        final userJoinedCircleNames = <String>{
          if (profile?.activeCircle?.name != null) profile!.activeCircle!.name.toLowerCase().trim(),
          ...userCircleMemberships.map((m) => m.circleName.toLowerCase().trim()).where((n) => n.isNotEmpty),
          ...userCircleMemberships.map((m) => (m.circleSlug ?? '').toLowerCase().trim()).where((s) => s.isNotEmpty),
          ...myCircles.map((c) => c.name.toLowerCase().trim()).where((n) => n.isNotEmpty),
          ...myCircles.map((c) => (c.slug ?? '').toLowerCase().trim()).where((s) => s.isNotEmpty),
        };

        final eventCircleName = (currentEvent.circle?.name ?? '').toLowerCase().trim();
        final eventCircleSlug = (currentEvent.circle?.slug ?? '').toLowerCase().trim();

        final isSameCircleByName = (eventCircleName.isNotEmpty && userJoinedCircleNames.contains(eventCircleName)) ||
            (eventCircleSlug.isNotEmpty && userJoinedCircleNames.contains(eventCircleSlug));

        final isGlobalEvent = currentEvent.eventType.toLowerCase().contains('global') ||
            currentEvent.eventCategory.toLowerCase().contains('global');

        final isInEventCircle = isGlobalEvent ||
            eventCircleIds.any((id) => userJoinedCircleIds.contains(id)) ||
            isSameCircleByName;

        final matchingRegistration = state.registration ??
            (currentEvent.userRegistration != null
                ? EventRegistrationEntity(
                    registrationId: currentEvent.userRegistration!.registrationId ?? '',
                    eventId: currentEvent.eventId,
                    occurrenceId: currentEvent.occurrenceId,
                    status: currentEvent.userRegistration!.status ?? 'confirmed',
                    qrToken: currentEvent.userRegistration!.qrToken,
                    qrCodeUrl: currentEvent.userRegistration!.qrCodeUrl,
                    paymentUrl: currentEvent.userRegistration!.checkoutUrl,
                    attendeeName: currentEvent.userRegistration!.attendeeName,
                    ticketPrice: currentEvent.ticketPrice,
                    location: currentEvent.location,
                    eventTitle: currentEvent.title,
                  )
                : null);

        return AppGradientBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const AppCommonBar(
              title: 'Event Details',
              showBack: true,
              showSearch: false,
              showChat: false,
              showNotifications: false,
              showProfile: false,
            ),
            bottomNavigationBar: EventDetailBottomBar(
              event: currentEvent,
              registration: matchingRegistration,
              isPro: isPro,
              isInEventCircle: isInEventCircle,
              isRegistering: state.isRegistering,
              onAttend: () => _handleAttend(currentEvent),
              onRequestToAttend: () => _showRequestModal(
                currentEvent,
                isInEventCircle: isInEventCircle,
              ),
              onUpgradeToPro: () => Navigator.pushNamed(context, AppRoutes.membershipPaywall),
              onProceedToPay: () => _handlePayment(state, currentEvent),
              onViewQr: () => _navigateToQr(state, currentEvent),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EventDetailHeaderImage(
                    event: currentEvent,
                    onShareTap: () => EventShareHelper.shareEvent(currentEvent),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EventDetailInfoSection(event: currentEvent),
                        const SizedBox(height: 16),
                        EventDetailOrganizedBy(
                          event: currentEvent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleAttend(EventEntity event) {
    context.read<EventDetailBloc>().add(AttendEventEvent(
          eventId: event.eventId,
          occurrenceId: event.occurrenceId,
        ));
  }

  void _showRequestModal(EventEntity event, {required bool isInEventCircle}) {
    final cId = event.circleId ??
        (event.circleIds.isNotEmpty ? event.circleIds.first : null) ??
        event.circle?.id;
    if (!isInEventCircle && _circleCategories.isEmpty && cId != null && cId.isNotEmpty) {
      _loadCircleCategories(cId);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return EventRequestBottomSheet(
            isVisitor: !isInEventCircle,
            selectedCategory: _selectedCategory,
            onSelectCategory: !isInEventCircle
                ? () async {
                    if (_circleCategories.isEmpty && cId != null && cId.isNotEmpty) {
                      await _loadCircleCategories(cId);
                    }
                    if (!mounted) return;
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => EventCategoryPickerSheet(
                        categories: _circleCategories,
                        onSelected: (cat) {
                          setState(() => _selectedCategory = cat);
                          setModalState(() {});
                        },
                      ),
                    );
                  }
                : null,
            onSubmit: (reason, coupon) {
              context.read<EventDetailBloc>().add(AttendEventEvent(
                    eventId: event.eventId,
                    occurrenceId: event.occurrenceId,
                    couponCode: coupon.isNotEmpty ? coupon : null,
                    reason: reason.isNotEmpty ? reason : null,
                    categoryId: !isInEventCircle ? _selectedCategory?.id : null,
                  ));
            },
          );
        },
      ),
    );
  }

  Future<void> _handlePayment(EventDetailState state, EventEntity currentEvent) async {
    final url = state.registration?.paymentUrl ??
        state.registration?.checkoutUrl ??
        currentEvent.userRegistration?.checkoutUrl;
    if (url != null && url.trim().isNotEmpty) {
      final uri = Uri.parse(url.trim());
      try {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
      } catch (_) {
        try {
          await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
        } catch (e) {
          if (mounted) {
            AppSnackBar.showError(context, 'Unable to open payment link: $e');
          }
        }
      }

      final regId = state.registration?.registrationId ?? currentEvent.userRegistration?.registrationId;
      if (regId != null && regId.isNotEmpty && mounted) {
        context.read<EventDetailBloc>().add(
              PollPaymentStatusEvent(regId),
            );
      }
    }
  }

  void _navigateToQr(EventDetailState state, EventEntity currentEvent) {
    final userReg = currentEvent.userRegistration;
    final ticket = state.registration ??
        (userReg != null
            ? EventRegistrationEntity(
                registrationId: userReg.registrationId ?? '',
                eventId: currentEvent.eventId,
                occurrenceId: currentEvent.occurrenceId,
                status: userReg.status ?? 'confirmed',
                qrToken: userReg.qrToken,
                qrCodeUrl: userReg.qrCodeUrl,
                paymentUrl: userReg.checkoutUrl,
                attendeeName: userReg.attendeeName,
                ticketPrice: currentEvent.ticketPrice,
                location: currentEvent.location,
                eventTitle: currentEvent.title,
                startAt: currentEvent.startAt ?? userReg.startAt,
                endAt: currentEvent.endAt,
              )
            : EventRegistrationEntity(
                registrationId: currentEvent.occurrenceId,
                eventId: currentEvent.eventId,
                occurrenceId: currentEvent.occurrenceId,
                status: 'confirmed',
                location: currentEvent.location,
                eventTitle: currentEvent.title,
                startAt: currentEvent.startAt,
                endAt: currentEvent.endAt,
              ));

    Navigator.pushNamed(
      context,
      AppRoutes.eventQrTicket,
      arguments: ticket,
    );
  }
}
