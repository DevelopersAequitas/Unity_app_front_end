import '../../domain/entities/leaderboard_entity.dart';
import 'leaderboard_entry_model.dart';

class LeaderboardModel extends LeaderboardEntity {
  const LeaderboardModel({
    super.entries = const [],
    super.currentUserRank,
    super.totalPeers = 0,
  });

  factory LeaderboardModel.fromJson(dynamic data) {
    List<LeaderboardEntryModel> entries = [];
    LeaderboardEntryModel? currentUserRank;
    int totalPeers = 0;

    if (data is Map<String, dynamic>) {
      final innerData = data['data'];
      final mapData = innerData is Map<String, dynamic> ? innerData : data;

      // 1. Locate the raw List of top peers
      List<dynamic> rawList = [];

      final candidateKeys = [
        'leaderboard',
        'leaderboards',
        'members',
        'rankings',
        'top_peers',
        'top_members',
        'top_20',
        'top20',
        'peers',
        'users',
        'items',
        'records',
        'rows',
        'list',
        'coins_leaderboard',
        'coin_leaderboard',
        'data',
      ];

      // Check innerData first if map
      if (innerData is Map<String, dynamic>) {
        for (final key in candidateKeys) {
          if (innerData[key] is List && (innerData[key] as List).isNotEmpty) {
            rawList = innerData[key] as List;
            break;
          }
        }
      }

      // Check root data
      if (rawList.isEmpty) {
        for (final key in candidateKeys) {
          if (data[key] is List && (data[key] as List).isNotEmpty) {
            rawList = data[key] as List;
            break;
          }
        }
      }

      // Check if data['data'] itself is a List
      if (rawList.isEmpty && data['data'] is List) {
        rawList = data['data'] as List;
      }

      // If still empty, search for ANY List value in innerData or data
      if (rawList.isEmpty && innerData is Map<String, dynamic>) {
        for (final entry in innerData.entries) {
          if (entry.key != 'my_rank' &&
              entry.key != 'user_rank' &&
              entry.value is List &&
              (entry.value as List).isNotEmpty) {
            rawList = entry.value as List;
            break;
          }
        }
      }
      if (rawList.isEmpty) {
        for (final entry in data.entries) {
          if (entry.key != 'my_rank' &&
              entry.key != 'user_rank' &&
              entry.value is List &&
              (entry.value as List).isNotEmpty) {
            rawList = entry.value as List;
            break;
          }
        }
      }

      // Parse entries
      for (int i = 0; i < rawList.length; i++) {
        final item = rawList[i];
        if (item is Map<String, dynamic>) {
          entries.add(LeaderboardEntryModel.fromJson(item, fallbackRank: i + 1));
        }
      }

      // 2. Parse Current User Rank
      dynamic rawUserRank;
      if (innerData is Map<String, dynamic>) {
        rawUserRank = innerData['my_rank'] ??
            innerData['user_rank'] ??
            innerData['current_user_rank'] ??
            innerData['my_ranking'] ??
            innerData['current_user'] ??
            innerData['me'] ??
            innerData['self'] ??
            innerData['myRank'] ??
            innerData['userRank'];
      }
      rawUserRank ??= data['my_rank'] ??
          data['user_rank'] ??
          data['current_user_rank'] ??
          data['my_ranking'] ??
          data['current_user'] ??
          data['me'] ??
          data['self'] ??
          data['myRank'] ??
          data['userRank'];

      if (rawUserRank is Map<String, dynamic>) {
        currentUserRank = LeaderboardEntryModel.fromJson(rawUserRank);
      } else if (rawUserRank is num) {
        currentUserRank = LeaderboardEntryModel(
          id: '',
          userId: '',
          name: 'You',
          rank: rawUserRank.toInt(),
          isCurrentUser: true,
        );
      } else if (rawUserRank is String && int.tryParse(rawUserRank) != null) {
        currentUserRank = LeaderboardEntryModel(
          id: '',
          userId: '',
          name: 'You',
          rank: int.tryParse(rawUserRank) ?? 0,
          isCurrentUser: true,
        );
      }

      // Fallback from entries if an entry is marked as current user or has rank > 20
      if (currentUserRank == null) {
        for (final entry in entries) {
          if (entry.isCurrentUser || entry.rank > 20) {
            currentUserRank = entry;
            break;
          }
        }
      }

      // Ensure entries list only retains Top 20 members (ranks 1 to 20)
      entries = entries.where((e) => e.rank >= 1 && e.rank <= 20).toList();

      // 3. Parse total peers
      totalPeers = int.tryParse(mapData['total_peers']?.toString() ?? '') ??
          int.tryParse(mapData['total_members']?.toString() ?? '') ??
          int.tryParse(mapData['total_users']?.toString() ?? '') ??
          int.tryParse(mapData['total']?.toString() ?? '') ??
          int.tryParse(data['total_peers']?.toString() ?? '') ??
          int.tryParse(data['total']?.toString() ?? '') ??
          entries.length;
    } else if (data is List) {
      for (int i = 0; i < data.length; i++) {
        final item = data[i];
        if (item is Map<String, dynamic>) {
          entries.add(LeaderboardEntryModel.fromJson(item, fallbackRank: i + 1));
        }
      }
      totalPeers = entries.length;
      entries = entries.where((e) => e.rank >= 1 && e.rank <= 20).toList();
    }

    return LeaderboardModel(
      entries: entries,
      currentUserRank: currentUserRank,
      totalPeers: totalPeers,
    );
  }
}
