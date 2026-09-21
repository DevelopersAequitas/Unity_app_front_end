import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/certification_question_model.dart';
import '../models/entrepreneur_certification_result_model.dart';
import '../models/entrepreneur_submissions_response_model.dart';

abstract class EntrepreneurCertificationRemoteDataSource {
  Future<List<CertificationQuestionModel>> getQuestions();
  Future<EntrepreneurSubmissionsResponseModel> getSubmissions({int page = 1});
  Future<EntrepreneurCertificationResultModel> submitCertification(
    Map<String, dynamic> data,
  );
}

class EntrepreneurCertificationRemoteDataSourceImpl
    implements EntrepreneurCertificationRemoteDataSource {
  final DioClient dioClient;

  const EntrepreneurCertificationRemoteDataSourceImpl({
    required this.dioClient,
  });

  static const List<Map<String, dynamic>> defaultQuestionsJson = [
    {
      'key': 'entrepreneur_mindset_definition',
      'question': 'How do you describe an entrepreneurial mindset?',
      'options': [
        'Opportunity-focused and resilient in uncertainty',
        'Focused entirely on high profit margins',
        'Avoiding any risk until guaranteed success',
        'Working with a strict routine without change',
      ],
    },
    {
      'key': 'market_validation_step',
      'question':
          'Before building a full product, what is the best first step?',
      'options': [
        'Validate demand with potential customers and early feedback',
        'Invest heavily in marketing and branding',
        'Register multiple patents immediately',
        'Hire an extensive team without prototyping',
      ],
    },
    {
      'key': 'product_failure_reaction',
      'question':
          'Your initial MVP launch gets minimal traction. What is your action?',
      'options': [
        'Analyze user metrics, gather qualitative feedback, and iterate or pivot',
        'Shut down all operations immediately',
        'Blame marketing channels and double spending',
        'Wait for the market to adapt without changing the product',
      ],
    },
    {
      'key': 'cash_flow_management',
      'question':
          'How do you prioritize runway and cash flow in early stages?',
      'options': [
        'Maintain lean operations and prioritize revenue-generating activities',
        'Spend aggressively on premium office spaces',
        'Ignore burn rate while chasing venture capital',
        'Avoid tracking expenses until end of quarter',
      ],
    },
    {
      'key': 'customer_retention_focus',
      'question':
          'What is the most sustainable driver of long-term business growth?',
      'options': [
        'High customer satisfaction, retention, and word-of-mouth referrals',
        'Discounting prices below cost continuously',
        'Aggressive one-time acquisition campaigns',
        'Expanding into unrelated markets rapidly',
      ],
    },
  ];

  @override
  Future<List<CertificationQuestionModel>> getQuestions() async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.entrepreneurCertificationQuestions,
      );
      final body = response.data;
      if (body is Map<String, dynamic>) {
        dynamic rawList;
        if (body['data'] is Map<String, dynamic>) {
          rawList = body['data']['questions'] ?? body['data']['items'];
        } else if (body['data'] is List) {
          rawList = body['data'];
        } else {
          rawList = body['questions'] ?? body['items'];
        }

        if (rawList is List && rawList.isNotEmpty) {
          return rawList
              .map(
                (item) => CertificationQuestionModel.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList();
        }
      } else if (body is List && body.isNotEmpty) {
        return body
            .map(
              (item) => CertificationQuestionModel.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList();
      }
    } catch (_) {}

    return defaultQuestionsJson
        .map((item) => CertificationQuestionModel.fromJson(item))
        .toList();
  }

  @override
  Future<EntrepreneurSubmissionsResponseModel> getSubmissions({
    int page = 1,
  }) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.entrepreneurCertification,
        queryParameters: {'page': page},
      );
      final body = response.data;
      if (body is Map<String, dynamic>) {
        return EntrepreneurSubmissionsResponseModel.fromJson(body);
      }
    } catch (_) {}
    return const EntrepreneurSubmissionsResponseModel();
  }

  @override
  Future<EntrepreneurCertificationResultModel> submitCertification(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.entrepreneurCertification,
        data: data,
      );
      final body = response.data;
      if (body is Map<String, dynamic>) {
        final dynamic rawData = body['data'] ?? body;
        if (rawData is Map<String, dynamic>) {
          return EntrepreneurCertificationResultModel.fromJson(rawData);
        }
      }
    } catch (e) {
      rethrow;
    }

    final answers = data['answers'] as Map? ?? data;
    int score = 0;
    answers.forEach((k, v) {
      if (v != null && v.toString().isNotEmpty) {
        score += 4;
      }
    });
    final totalQ = 25;
    final percentage = (totalQ > 0) ? ((score / 100) * 100).round() : 100;
    final tier = percentage >= 81
        ? 'Master Entrepreneur'
        : percentage >= 61
        ? 'Certified Entrepreneur'
        : percentage >= 40
        ? 'Emerging Entrepreneur'
        : 'Needs Improvement';

    return EntrepreneurCertificationResultModel(
      id: 'cert-${DateTime.now().millisecondsSinceEpoch}',
      fullName: data['full_name']?.toString() ?? '',
      businessName: data['business_name']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      contactNo: data['contact_no']?.toString() ?? '',
      totalScore: score,
      percentage: percentage,
      certificationTier: tier,
      status: 'approved',
    );
  }
}
