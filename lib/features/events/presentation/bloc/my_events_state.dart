import 'package:equatable/equatable.dart';
import '../../domain/entities/event_registration_entity.dart';

enum MyEventsStatus { initial, loading, success, failure }

class MyEventsState extends Equatable {
  final MyEventsStatus status;
  final List<EventRegistrationEntity> allItems;
  final String activeTab; // 'registered', 'attending', 'past'
  final String? errorMessage;

  const MyEventsState({
    this.status = MyEventsStatus.initial,
    this.allItems = const [],
    this.activeTab = 'registered',
    this.errorMessage,
  });

  List<EventRegistrationEntity> get filteredItems {
    final now = DateTime.now();
    switch (activeTab) {
      case 'attending':
        return allItems.where((e) {
          final isFuture = e.startAt == null || e.startAt!.isAfter(now);
          return isFuture && (e.status == 'confirmed' || e.status == 'attending');
        }).toList();
      case 'past':
        return allItems.where((e) {
          final isPast = e.endAt != null ? e.endAt!.isBefore(now) : false;
          return isPast || e.status == 'checked_in' || e.status == 'past';
        }).toList();
      case 'registered':
      default:
        return allItems;
    }
  }

  MyEventsState copyWith({
    MyEventsStatus? status,
    List<EventRegistrationEntity>? allItems,
    String? activeTab,
    String? errorMessage,
  }) {
    return MyEventsState(
      status: status ?? this.status,
      allItems: allItems ?? this.allItems,
      activeTab: activeTab ?? this.activeTab,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allItems,
        activeTab,
        errorMessage,
      ];
}
