import '../../domain/entities/circle_meeting_entity.dart';

class CircleMeetingModel extends CircleMeetingEntity {
  const CircleMeetingModel({
    super.date,
    super.time,
    super.formattedDateTime,
    super.mode = 'Offline',
    super.location,
    super.venue,
    super.frequency,
    super.meetingDay,
  });

  factory CircleMeetingModel.fromJson(Map<String, dynamic> json) {
    return CircleMeetingModel(
      date: json['date']?.toString() ?? json['meeting_date']?.toString(),
      time: json['time']?.toString() ?? json['meeting_time']?.toString(),
      formattedDateTime: json['formatted_date_time']?.toString() ??
          json['next_meeting_text']?.toString() ??
          json['formatted_date']?.toString(),
      mode: json['mode']?.toString() ??
          json['meeting_mode']?.toString() ??
          'Offline',
      location: json['location']?.toString() ??
          json['city']?.toString() ??
          json['venue_city']?.toString(),
      venue: json['venue']?.toString() ??
          json['address']?.toString() ??
          json['meeting_link']?.toString(),
      frequency: json['frequency']?.toString() ??
          json['meeting_frequency']?.toString(),
      meetingDay: json['meeting_day']?.toString() ??
          json['day_time']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'time': time,
      'formatted_date_time': formattedDateTime,
      'mode': mode,
      'location': location,
      'venue': venue,
      'frequency': frequency,
      'meeting_day': meetingDay,
    };
  }
}
