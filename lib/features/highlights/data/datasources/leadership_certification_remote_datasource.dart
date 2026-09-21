import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/certification_question_model.dart';
import '../models/leadership_certification_result_model.dart';
import '../models/leadership_submissions_response_model.dart';

abstract class LeadershipCertificationRemoteDataSource {
  Future<List<CertificationQuestionModel>> getQuestions();
  Future<LeadershipSubmissionsResponseModel> getSubmissions({int page = 1});
  Future<LeadershipCertificationResultModel> submitCertification(
    Map<String, dynamic> data,
  );
}

class LeadershipCertificationRemoteDataSourceImpl
    implements LeadershipCertificationRemoteDataSource {
  final DioClient dioClient;

  const LeadershipCertificationRemoteDataSourceImpl({required this.dioClient});

  static const List<Map<String, dynamic>> defaultQuestionsJson = [
    {
      'key': 'team_struggling_action',
      'question': 'When a team member is struggling with a task, what do you usually do?',
      'options': [
        'Offer help and ask what’s stopping them',
        'Take over the task and complete it myself',
        'Wait until the deadline to address the issue',
        'Assign the task to someone else without discussion',
      ],
    },
    {
      'key': 'leader_definition',
      'question': 'In your view, what defines a true leader?',
      'options': [
        'Helps others succeed',
        'Holds the highest authority in the room',
        'Focuses solely on individual performance',
        'Commands and gives orders without feedback',
      ],
    },
    {
      'key': 'junior_challenged_idea',
      'question': 'If a junior team member challenges your idea, how do you respond?',
      'options': [
        'Think openly and discuss',
        'Dismiss their opinion immediately',
        'Insist on your authority and experience',
        'Ignore the input and proceed as planned',
      ],
    },
    {
      'key': 'leader_when_wrong',
      'question': 'What should a leader do when things go wrong or a mistake occurs?',
      'options': [
        'Takes responsibility and finds a solution',
        'Blame team members or external factors',
        'Hide the mistake to protect reputation',
        'Wait for someone else to resolve the problem',
      ],
    },
    {
      'key': 'team_motivation',
      'question': 'What is the most effective way to keep your team motivated?',
      'options': [
        'Appreciation, trust and clear goals',
        'Strict monitoring and penalties',
        'Only offering monetary incentives',
        'Creating aggressive competition among members',
      ],
    },
    {
      'key': 'leadership_meaning',
      'question': 'What does leadership mean to you fundamentally?',
      'options': [
        'Taking people forward together',
        'Holding power and control over others',
        'Achieving personal recognition and titles',
        'Managing tasks without personal connection',
      ],
    },
  ];

  @override
  Future<List<CertificationQuestionModel>> getQuestions() async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.leadershipCertificationQuestions,
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
  Future<LeadershipSubmissionsResponseModel> getSubmissions({int page = 1}) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.leadershipCertification,
        queryParameters: {'page': page},
      );
      final body = response.data;
      if (body is Map<String, dynamic>) {
        return LeadershipSubmissionsResponseModel.fromJson(body);
      }
    } catch (_) {}
    return const LeadershipSubmissionsResponseModel();
  }

  @override
  Future<LeadershipCertificationResultModel> submitCertification(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.leadershipCertification,
        data: data,
      );
      final body = response.data;
      if (body is Map<String, dynamic>) {
        final dynamic rawData = body['data'] ?? body;
        if (rawData is Map<String, dynamic>) {
          return LeadershipCertificationResultModel.fromJson(rawData);
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
        ? 'Established Leader'
        : percentage >= 61
        ? 'Growing Leader'
        : percentage >= 40
        ? 'Aspiring Leader'
        : 'Needs Improvement';

    return LeadershipCertificationResultModel(
      id: 'cert-${DateTime.now().millisecondsSinceEpoch}',
      fullName: data['full_name']?.toString() ?? '',
      businessName: data['business_name']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      contactNo: data['contact_no']?.toString() ?? '',
      totalScore: score,
      percentage: percentage,
      certificationLevel: tier,
      status: 'approved',
    );
  }
}

