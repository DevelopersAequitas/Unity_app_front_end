import 'package:equatable/equatable.dart';
import 'leaderboard_entry_entity.dart';

class LeaderboardEntity extends Equatable {
  final List<LeaderboardEntryEntity> entries;
  final LeaderboardEntryEntity? currentUserRank;
  final int totalPeers;

  const LeaderboardEntity({
    this.entries = const [],
    this.currentUserRank,
    this.totalPeers = 0,
  });

  /// The Top 3 podium entries (strictly ranks 1, 2, 3)
  List<LeaderboardEntryEntity> get topThree {
    if (entries.isEmpty) return [];
    final list = entries.where((e) => e.rank >= 1 && e.rank <= 3).toList()
      ..sort((a, b) => a.rank.compareTo(b.rank));
    if (list.isNotEmpty) return list;
    final sorted = List<LeaderboardEntryEntity>.from(entries)
      ..sort((a, b) => a.rank.compareTo(b.rank));
    return sorted.take(3).where((e) => e.rank <= 3).toList();
  }

  /// Rankings starting from rank 4 up to rank 20
  List<LeaderboardEntryEntity> get globalRankings {
    if (entries.isEmpty) return [];
    final list = entries.where((e) => e.rank >= 4 && e.rank <= 20).toList()
      ..sort((a, b) => a.rank.compareTo(b.rank));
    if (list.isNotEmpty) return list;
    final sorted = List<LeaderboardEntryEntity>.from(entries)
      ..sort((a, b) => a.rank.compareTo(b.rank));
    return sorted.skip(3).where((e) => e.rank <= 20).toList();
  }

  /// Whether current user is already present within the top list (entries)
  bool get isCurrentUserInTopList {
    if (entries.any((e) => e.isCurrentUser)) return true;
    if (currentUserRank != null) {
      return entries.any((e) =>
          (currentUserRank!.userId.isNotEmpty &&
              e.userId.isNotEmpty &&
              e.userId == currentUserRank!.userId) ||
          (currentUserRank!.id.isNotEmpty &&
              e.id.isNotEmpty &&
              e.id == currentUserRank!.id) ||
          (currentUserRank!.rank > 0 && e.rank == currentUserRank!.rank));
    }
    return false;
  }

  @override
  List<Object?> get props => [entries, currentUserRank, totalPeers];
}
