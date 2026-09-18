import '../../domain/entities/introduced_peer_entity.dart';
import '../../domain/entities/top_builder_entity.dart';
import '../../domain/repositories/top_builders_repository.dart';
import '../datasources/top_builders_remote_datasource.dart';

class TopBuildersRepositoryImpl implements TopBuildersRepository {
  final TopBuildersRemoteDataSource remoteDataSource;

  const TopBuildersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TopBuilderEntity>> getTopBuilders() async {
    final models = await remoteDataSource.getTopBuilders();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<IntroducedPeerEntity>> getMyIntroducedPeers() async {
    final models = await remoteDataSource.getMyIntroducedPeers();
    return models.map((m) => m.toEntity()).toList();
  }
}
