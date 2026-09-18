import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/certification_question_model.dart';
import '../models/leadership_certification_result_model.dart';

abstract class LeadershipCertificationRemoteDataSource {
  Future<List<CertificationQuestionModel>> getQuestions();
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
      'field': 'team_struggling_action',
      'question': 'What do you do when a team peer is struggling?',
      'options': [
        'Offer help and ask what\'s stopping them',
        'Tell them to figure it out',
        'Ignore and wait for results',
        'Replace them with someone else',
      ],
    },
    {
      'field': 'leader_definition',
      'question': 'How would you define a true leader?',
      'options': [
        'Helps others succeed',
        'Someone who gives orders',
        'A person with the highest title',
        'One who works alone and delivers',
      ],
    },
    {
      'field': 'junior_challenged_idea',
      'question': 'A junior challenges your idea in a meeting. What do you do?',
      'options': [
        'Think openly and discuss',
        'Dismiss it politely',
        'Get defensive',
        'Ignore and move on',
      ],
    },
    {
      'field': 'leader_when_wrong',
      'question': 'What does a leader do when they are wrong?',
      'options': [
        'Takes responsibility and finds a solution',
        'Blames the team',
        'Stays silent',
        'Justifies their decision',
      ],
    },
    {
      'field': 'team_motivation',
      'question': 'How do you keep your team motivated?',
      'options': [
        'Appreciation, trust and clear goals',
        'Strict deadlines',
        'Bonuses only',
        'By monitoring them closely',
      ],
    },
    {
      'field': 'leadership_meaning',
      'question': 'What does leadership mean to you?',
      'options': [
        'Taking people forward together',
        'Being in charge',
        'Making all decisions alone',
        'Getting the best results at any cost',
      ],
    },
    {
      'field': 'different_background_team_first_step',
      'question':
          'You are leading a team from very different backgrounds. What is your first step?',
      'options': [
        'Know them and align goals',
        'Divide tasks immediately',
        'Let them figure out roles',
        'Focus only on performance metrics',
      ],
    },
    {
      'field': 'group_task_approach',
      'question': 'How do you approach a group task?',
      'options': [
        'Involve everyone and guide the team',
        'Do most of it yourself',
        'Delegate and disengage',
        'Wait for instructions from above',
      ],
    },
    {
      'field': 'team_credit_sharing',
      'question':
          'When your project achieves huge success, how do you handle recognition?',
      'options': [
        'Give maximum credit to the team publicly',
        'Accept praise on behalf of yourself',
        'Distribute credit equally regardless of effort',
        'Highlight only your core contributions',
      ],
    },
    {
      'field': 'conflict_resolution',
      'question':
          'Two core team members are in a deadlock conflict. What is your intervention?',
      'options': [
        'Facilitate a private dialogue focused on shared vision',
        'Choose a side quickly to avoid project delays',
        'Let them resolve it among themselves entirely',
        'Reassign both to different departments immediately',
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
        final dynamic rawList =
            body['data'] ?? body['questions'] ?? body['items'];
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
        return LeadershipCertificationResultModel.fromJson(
          Map<String, dynamic>.from(rawData as Map),
        );
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
    final tier = percentage >= 80
        ? 'Distinguished Leader'
        : percentage >= 60
        ? 'Certified Leader'
        : 'Emerging Leader';

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
