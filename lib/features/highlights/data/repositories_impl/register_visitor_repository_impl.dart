import '../../domain/entities/event_item_entity.dart';
import '../../domain/entities/register_visitor_entity.dart';
import '../../domain/repositories/register_visitor_repository.dart';
import '../datasources/register_visitor_remote_datasource.dart';
import '../models/register_visitor_model.dart';

class RegisterVisitorRepositoryImpl implements RegisterVisitorRepository {
  final RegisterVisitorRemoteDataSource remoteDataSource;

  const RegisterVisitorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> submitRegisterVisitor(RegisterVisitorEntity entity) async {
    final model = RegisterVisitorModel.fromEntity(entity);
    await remoteDataSource.submitRegisterVisitor(model);
  }

  @override
  Future<List<RegisterVisitorEntity>> getRegisterVisitorSubmissions() async {
    final models = await remoteDataSource.getRegisterVisitorSubmissions();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<EventItemEntity>> getEvents() async {
    return await remoteDataSource.getEvents();
  }
}
