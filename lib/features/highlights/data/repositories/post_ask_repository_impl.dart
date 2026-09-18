import '../../domain/entities/post_ask_entity.dart';
import '../../domain/repositories/post_ask_repository.dart';
import '../datasources/post_ask_remote_datasource.dart';
import '../models/post_ask_model.dart';

class PostAskRepositoryImpl implements PostAskRepository {
  final PostAskRemoteDataSource remoteDataSource;

  const PostAskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PostAskEntity>> getMyAsks() async {
    return remoteDataSource.getMyAsks();
  }

  @override
  Future<String> submitAsk(PostAskEntity ask) async {
    final model = PostAskModel.fromEntity(ask);
    return remoteDataSource.submitAsk(model);
  }

  @override
  Future<void> completeAsk(String id, {String? subject}) async {
    return remoteDataSource.completeAsk(id, subject: subject);
  }
}
