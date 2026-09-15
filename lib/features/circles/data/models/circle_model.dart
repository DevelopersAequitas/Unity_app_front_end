import '../../domain/entities/circle_entity.dart';
import 'circle_leader_model.dart';
import 'circle_meeting_model.dart';

class CircleModel extends CircleEntity {
  const CircleModel({
    required super.id,
    required super.name,
    super.slug,
    super.circleKey,
    super.category,
    super.city,
    super.state,
    super.country,
    super.description,
    super.membershipStatus = 'Active',
    super.membersCount = 0,
    super.peersCount = 0,
    super.meetingFrequency = 'Monthly',
    super.meetingMode = 'Offline',
    super.nextMeeting,
    super.rank,
    super.stage,
    super.logoUrl,
    super.coverImageUrl,
    super.memberAvatars = const [],
    super.circleLeaders = const [],
    super.regionalLeaders = const [],
    super.leadership,
    super.focusAreas = const [],
    super.type,
  });

  factory CircleModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value, [int fallback = 0]) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? fallback;
      return fallback;
    }

    List<String> parseStringList(dynamic value) {
      if (value is List) {
        return value
            .map((e) {
              if (e is Map<String, dynamic>) {
                return e['name']?.toString() ?? e['category_name']?.toString() ?? '';
              }
              return e?.toString() ?? '';
            })
            .where((e) => e.isNotEmpty)
            .toList();
      }
      return const [];
    }

    List<CircleLeaderModel> parseCircleLeaders(dynamic value) {
      final List<CircleLeaderModel> list = [];
      if (value is Map<String, dynamic>) {
        for (final entry in value.entries) {
          if (entry.value is Map<String, dynamic>) {
            final leaderMap = Map<String, dynamic>.from(entry.value as Map<String, dynamic>);
            leaderMap['designation'] ??= entry.value['designation'] ?? entry.key.replaceAll('_', ' ');
            leaderMap['role'] ??= leaderMap['designation'];
            list.add(CircleLeaderModel.fromJson(leaderMap, 'circle'));
          } else if (entry.value is List) {
            for (final sub in entry.value as List) {
              if (sub is Map<String, dynamic>) {
                list.add(CircleLeaderModel.fromJson(sub, 'circle'));
              }
            }
          }
        }
      } else if (value is List) {
        for (final item in value) {
          if (item is Map<String, dynamic>) {
            list.add(CircleLeaderModel.fromJson(item, 'circle'));
          }
        }
      }
      return list;
    }

    List<CircleLeaderModel> parseRegionalLeaders(dynamic value, Map<String, dynamic> rootJson) {
      final List<CircleLeaderModel> list = [];
      if (value is List) {
        for (final item in value) {
          if (item is Map<String, dynamic>) {
            list.add(CircleLeaderModel.fromJson(item, 'regional'));
          }
        }
      }
      if (list.isEmpty) {
        if (rootJson['founder'] is Map<String, dynamic>) {
          final m = Map<String, dynamic>.from(rootJson['founder'] as Map<String, dynamic>);
          m['designation'] ??= 'Founder';
          m['role'] ??= 'Founder';
          list.add(CircleLeaderModel.fromJson(m, 'regional'));
        }
        if (rootJson['director'] is Map<String, dynamic>) {
          final m = Map<String, dynamic>.from(rootJson['director'] as Map<String, dynamic>);
          m['designation'] ??= 'Director';
          m['role'] ??= 'Director';
          list.add(CircleLeaderModel.fromJson(m, 'regional'));
        }
        if (rootJson['ded'] is Map<String, dynamic>) {
          final m = Map<String, dynamic>.from(rootJson['ded'] as Map<String, dynamic>);
          m['designation'] ??= 'DED';
          m['role'] ??= 'DED';
          list.add(CircleLeaderModel.fromJson(m, 'regional'));
        }
        if (rootJson['industry_director'] is Map<String, dynamic>) {
          final m = Map<String, dynamic>.from(rootJson['industry_director'] as Map<String, dynamic>);
          m['designation'] ??= 'ID';
          m['role'] ??= 'ID';
          list.add(CircleLeaderModel.fromJson(m, 'regional'));
        }
      }
      return list;
    }

    CircleMeetingModel? parseMeeting(dynamic value) {
      if (value is Map<String, dynamic>) {
        return CircleMeetingModel.fromJson(value);
      }
      return null;
    }

    // Extract city, state, country safely
    String? parsedCity;
    String? parsedState;
    String? parsedCountry = json['country']?.toString();
    if (json['city'] is Map<String, dynamic>) {
      final cityMap = json['city'] as Map<String, dynamic>;
      parsedCity = cityMap['name']?.toString();
      parsedState = cityMap['state']?.toString();
      parsedCountry ??= cityMap['country']?.toString();
    } else if (json['city'] is String) {
      parsedCity = json['city']?.toString();
      parsedState = json['state']?.toString();
    }

    // Extract category name
    String? parsedCategory;
    if (json['categories'] is List && (json['categories'] as List).isNotEmpty) {
      final first = (json['categories'] as List).first;
      if (first is Map<String, dynamic>) {
        parsedCategory = first['category_name']?.toString() ?? first['name']?.toString();
      } else if (first is String) {
        parsedCategory = first;
      }
    }
    parsedCategory ??= json['category_name']?.toString() ??
        json['category']?.toString() ??
        json['industry_name']?.toString() ??
        json['industry']?.toString();

    // Extract ranking
    String? parsedRank;
    if (json['circle_ranking'] is Map<String, dynamic>) {
      parsedRank = json['circle_ranking']['rank']?.toString() ??
          json['circle_ranking']['title']?.toString();
    }
    parsedRank ??= json['rank']?.toString() ?? json['ranking']?.toString();

    // Extract Next meeting from calendar or flat fields
    CircleMeetingModel? nextMeetingModel;
    if (json['next_meeting'] != null) {
      nextMeetingModel = parseMeeting(json['next_meeting']);
    } else if (json['calendar'] is Map<String, dynamic>) {
      final cal = json['calendar'] as Map<String, dynamic>;
      final sched = cal['meeting_schedule'] is List && (cal['meeting_schedule'] as List).isNotEmpty
          ? (cal['meeting_schedule'] as List).first as Map<String, dynamic>?
          : null;
      final settings = cal['settings'] is Map<String, dynamic>
          ? cal['settings'] as Map<String, dynamic>
          : null;
      final freq = sched?['frequency']?.toString() ?? settings?['meeting_frequency']?.toString() ?? json['meeting_frequency']?.toString() ?? 'Monthly';
      final day = sched?['day_of_week']?.toString();
      final time = sched?['default_meet_time']?.toString();
      final mode = settings?['meeting_mode']?.toString() ?? json['meeting_mode']?.toString() ?? 'Offline';
      final formattedDay = day != null && day.isNotEmpty
          ? '${day[0].toUpperCase()}${day.substring(1)}'
          : '';
      final formattedFreq = freq.isNotEmpty
          ? '${freq[0].toUpperCase()}${freq.substring(1)}'
          : 'Monthly';
      final dateTimeText = (formattedDay.isNotEmpty && time != null)
          ? '$formattedFreq, $formattedDay • $time'
          : formattedFreq;

      nextMeetingModel = CircleMeetingModel(
        formattedDateTime: dateTimeText,
        mode: mode,
        location: parsedCity ?? json['location']?.toString(),
        frequency: formattedFreq,
        meetingDay: formattedDay,
        time: time,
      );
    } else if (json['next_meeting_text'] != null || json['next_meeting_date'] != null) {
      nextMeetingModel = CircleMeetingModel(
        formattedDateTime: json['next_meeting_text']?.toString() ?? json['next_meeting_date']?.toString(),
        mode: json['meeting_mode']?.toString() ?? 'Offline',
        location: parsedCity ?? json['location']?.toString(),
        frequency: json['meeting_frequency']?.toString(),
        meetingDay: json['meeting_day']?.toString(),
      );
    }

    final calendarMap = json['calendar'] is Map<String, dynamic> ? json['calendar'] as Map<String, dynamic> : null;

    final cLeaders = parseCircleLeaders(
      json['circle_leaders'] ?? json['calendar']?['leadership'],
    );
    final rLeaders = parseRegionalLeaders(
      json['regional_leaders'],
      json,
    );


    return CircleModel(
      id: json['id']?.toString() ?? json['circle_id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['circle_name']?.toString() ?? 'Circle',
      slug: json['slug']?.toString(),
      circleKey: json['circle_key']?.toString() ?? json['key']?.toString(),
      category: parsedCategory,
      city: parsedCity,
      state: parsedState,
      country: parsedCountry,
      description: json['description']?.toString() ??
          json['short_description']?.toString() ??
          json['about']?.toString() ??
          json['purpose']?.toString(),
      membershipStatus: json['member_status']?.toString() ??
          json['membership_status']?.toString() ??
          json['status']?.toString() ??
          'Active',
      membersCount: parseInt(
        json['members_count'] ?? json['member_count'] ?? json['membersCount'],
        0,
      ),
      peersCount: parseInt(
        json['peers_count'] ?? json['peer_count'],
        0,
      ),
      meetingFrequency: json['meeting_frequency']?.toString() ??
          json['frequency']?.toString() ??
          'Monthly',
      meetingMode: json['meeting_mode']?.toString() ?? 'Offline',
      nextMeeting: nextMeetingModel,
      rank: parsedRank,
      stage: json['circle_stage']?.toString() ?? json['stage']?.toString(),
      logoUrl: parseImageUrl(json['circle_image_url'], [
        json['circle_image'],
        json['circle_image_file_id'],
        calendarMap?['circle_image'],
        json['logo_url'],
        json['icon_url'],
        json['image_url'],
        json['logo'],
        json['image'],
      ]),
      coverImageUrl: parseImageUrl(json['cover_image_url'], [
        json['cover_image'],
        json['cover_file_id'],
        calendarMap?['cover'],
        json['cover_photo_url'],
        json['banner_url'],
        json['cover'],
      ]),
      memberAvatars: parseStringList(
        json['recent_member_avatars'] ?? json['member_avatars'] ?? json['members_preview'],
      ),
      circleLeaders: cLeaders,
      regionalLeaders: rLeaders,
      leadership: [...cLeaders, ...rLeaders],
      focusAreas: parseStringList(
        json['industry_tags'] ?? json['focus_areas'] ?? json['categories'],
      ),
      type: json['type']?.toString() ?? json['circle_type']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'circle_key': circleKey,
      'category': category,
      'city': city,
      'state': state,
      'country': country,
      'description': description,
      'membership_status': membershipStatus,
      'members_count': membersCount,
      'peers_count': peersCount,
      'meeting_frequency': meetingFrequency,
      'meeting_mode': meetingMode,
      'next_meeting': nextMeeting is CircleMeetingModel
          ? (nextMeeting as CircleMeetingModel).toJson()
          : null,
      'rank': rank,
      'stage': stage,
      'logo_url': logoUrl,
      'cover_image_url': coverImageUrl,
      'member_avatars': memberAvatars,
      'circle_leaders': circleLeaders
          .whereType<CircleLeaderModel>()
          .map((e) => e.toJson())
          .toList(),
      'regional_leaders': regionalLeaders
          .whereType<CircleLeaderModel>()
          .map((e) => e.toJson())
          .toList(),
      'leadership': leadership
          .whereType<CircleLeaderModel>()
          .map((e) => e.toJson())
          .toList(),
      'focus_areas': focusAreas,
      'type': type,
    };
  }

  static String? parseImageUrl(dynamic val, [List<dynamic> fallbacks = const []]) {
    String? extract(dynamic v) {
      if (v == null) return null;
      if (v is String) {
        final s = v.trim();
        if (s.isEmpty) return null;
        if (s.startsWith('http://') || s.startsWith('https://')) return s;
        if (s.length >= 20 && !s.contains('/')) {
          return 'https://dev.peersunity.com/api/v1/files/$s';
        }
        return s;
      }
      if (v is Map<String, dynamic>) {
        final url = v['url']?.toString();
        if (url != null && url.isNotEmpty) return url;
        final fileId = v['file_id']?.toString() ?? v['id']?.toString();
        if (fileId != null && fileId.isNotEmpty) {
          return 'https://dev.peersunity.com/api/v1/files/$fileId';
        }
      }
      return null;
    }

    final primary = extract(val);
    if (primary != null) return primary;
    for (final fb in fallbacks) {
      final res = extract(fb);
      if (res != null) return res;
    }
    return null;
  }
}

