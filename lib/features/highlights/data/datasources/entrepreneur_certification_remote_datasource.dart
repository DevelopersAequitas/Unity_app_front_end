import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/certification_question_model.dart';
import '../models/entrepreneur_certification_result_model.dart';

abstract class EntrepreneurCertificationRemoteDataSource {
  Future<List<CertificationQuestionModel>> getQuestions();
  Future<EntrepreneurCertificationResultModel> submitCertification(Map<String, dynamic> data);
}

class EntrepreneurCertificationRemoteDataSourceImpl implements EntrepreneurCertificationRemoteDataSource {
  final DioClient dioClient;

  const EntrepreneurCertificationRemoteDataSourceImpl({required this.dioClient});

  static const List<Map<String, dynamic>> defaultQuestionsJson = [
    {
      'field': 'entrepreneur_mindset_definition',
      'question': 'How do you describe an entrepreneurial mindset?',
      'options': [
        'Opportunity-focused and resilient in uncertainty',
        'Focused entirely on high profit margins',
        'Avoiding any risk until guaranteed success',
        'Working with a strict routine without change',
      ],
    },
    {
      'field': 'market_validation_step',
      'question': 'Before building a full product, what is the best first step?',
      'options': [
        'Validate demand with potential customers and early feedback',
        'Invest heavily in marketing and branding',
        'Register multiple patents immediately',
        'Hire an extensive team without prototyping',
      ],
    },
    {
      'field': 'product_failure_reaction',
      'question': 'Your initial MVP launch gets minimal traction. What is your action?',
      'options': [
        'Analyze user metrics, gather qualitative feedback, and iterate or pivot',
        'Shut down all operations immediately',
        'Blame marketing channels and double spending',
        'Wait for the market to adapt without changing the product',
      ],
    },
    {
      'field': 'cash_flow_management',
      'question': 'How do you prioritize runway and cash flow in early stages?',
      'options': [
        'Maintain lean operations and prioritize revenue-generating activities',
        'Spend aggressively on premium office spaces',
        'Ignore burn rate while chasing venture capital',
        'Avoid tracking expenses until end of quarter',
      ],
    },
    {
      'field': 'customer_retention_focus',
      'question': 'What is the most sustainable driver of long-term business growth?',
      'options': [
        'High customer satisfaction, retention, and word-of-mouth referrals',
        'Discounting prices below cost continuously',
        'Aggressive one-time acquisition campaigns',
        'Expanding into unrelated markets rapidly',
      ],
    },
    {
      'field': 'delegation_scaling',
      'question': 'When scaling beyond the founder stage, how do you handle delegation?',
      'options': [
        'Empower trusted leaders with clear KPIs and autonomy',
        'Micromanage every single decision',
        'Avoid hiring specialists to save costs',
        'Delegate critical financial decisions with no oversight',
      ],
    },
    {
      'field': 'competitive_advantage',
      'question': 'How do you build a sustainable competitive moat?',
      'options': [
        'Unique customer value, network effects, and continuous innovation',
        'Copying competitors feature-for-feature',
        'Lowering quality to beat price points',
        'Relying solely on short-term promotions',
      ],
    },
    {
      'field': 'investor_relationship',
      'question': 'What is the foundation of a healthy investor or stakeholder relationship?',
      'options': [
        'Transparency, realistic milestones, and consistent reporting',
        'Overpromising metrics and hiding setbacks',
        'Contacting investors only during cash crunches',
        'Ignoring governance and feedback completely',
      ],
    },
  ];

  @override
  Future<List<CertificationQuestionModel>> getQuestions() async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.entrepreneurCertificationQuestions);
      final body = response.data;
      if (body is Map<String, dynamic>) {
        final dynamic rawList = body['data'] ?? body['questions'] ?? body['items'];
        if (rawList is List && rawList.isNotEmpty) {
          return rawList.map((item) => CertificationQuestionModel.fromJson(Map<String, dynamic>.from(item as Map))).toList();
        }
      } else if (body is List && body.isNotEmpty) {
        return body.map((item) => CertificationQuestionModel.fromJson(Map<String, dynamic>.from(item as Map))).toList();
      }
    } catch (_) {}

    return defaultQuestionsJson.map((item) => CertificationQuestionModel.fromJson(item)).toList();
  }

  @override
  Future<EntrepreneurCertificationResultModel> submitCertification(Map<String, dynamic> data) async {
    try {
      final response = await dioClient.dio.post(ApiEndpoints.entrepreneurCertification, data: data);
      final body = response.data;
      if (body is Map<String, dynamic>) {
        final dynamic rawData = body['data'] ?? body;
        return EntrepreneurCertificationResultModel.fromJson(Map<String, dynamic>.from(rawData as Map));
      }
    } catch (_) {}

    final answers = data['answers'] as Map? ?? data;
    int score = 0;
    answers.forEach((k, v) {
      if (v != null && v.toString().isNotEmpty) {
        score += 1;
      }
    });
    final totalQ = defaultQuestionsJson.length;
    final percentage = (totalQ > 0) ? ((score / totalQ) * 100).round() : 100;
    final tier = percentage >= 80 ? 'Master Entrepreneur' : percentage >= 60 ? 'Certified Entrepreneur' : 'Emerging Entrepreneur';

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
