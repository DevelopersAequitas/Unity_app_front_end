import '../repositories/peers_repository.dart';

class TogglePeerBookmarkUseCase {
  final PeersRepository repository;

  TogglePeerBookmarkUseCase(this.repository);

  Future<void> call(String memberId, bool isCurrentlyBookmarked) {
    return repository.togglePeerBookmark(memberId, isCurrentlyBookmarked);
  }
}
