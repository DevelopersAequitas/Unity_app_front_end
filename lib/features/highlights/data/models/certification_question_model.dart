import '../../domain/entities/certification_question_entity.dart';

class CertificationQuestionModel extends CertificationQuestionEntity {
  const CertificationQuestionModel({
    required super.field,
    required super.question,
    required super.options,
  });

  factory CertificationQuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    List<String> parsedOptions = [];
    if (rawOptions is List) {
      parsedOptions = rawOptions.map((e) => e.toString()).toList();
    }
    return CertificationQuestionModel(
      field: json['key']?.toString() ?? json['field']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      options: parsedOptions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'question': question,
      'options': options,
    };
  }
}
