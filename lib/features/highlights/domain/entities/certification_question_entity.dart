import 'package:equatable/equatable.dart';

class CertificationQuestionEntity extends Equatable {
  final String field;
  final String question;
  final List<String> options;

  const CertificationQuestionEntity({
    required this.field,
    required this.question,
    required this.options,
  });

  @override
  List<Object?> get props => [field, question, options];
}
