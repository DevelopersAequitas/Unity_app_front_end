import 'package:equatable/equatable.dart';
import 'entrepreneur_certification_result_entity.dart';

class EntrepreneurSubmissionsResponseEntity extends Equatable {
  final List<EntrepreneurCertificationResultEntity> items;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const EntrepreneurSubmissionsResponseEntity({
    this.items = const [],
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 15,
    this.total = 0,
  });

  @override
  List<Object?> get props => [items, currentPage, lastPage, perPage, total];
}
