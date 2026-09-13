import 'package:equatable/equatable.dart';

class CircleMeetingEntity extends Equatable {
  final String? date;
  final String? time;
  final String? formattedDateTime;
  final String mode; // e.g. "Offline", "Online", "Hybrid"
  final String? location;
  final String? venue;
  final String? frequency;
  final String? meetingDay;

  const CircleMeetingEntity({
    this.date,
    this.time,
    this.formattedDateTime,
    this.mode = 'Offline',
    this.location,
    this.venue,
    this.frequency,
    this.meetingDay,
  });

  @override
  List<Object?> get props => [
        date,
        time,
        formattedDateTime,
        mode,
        location,
        venue,
        frequency,
        meetingDay,
      ];
}
