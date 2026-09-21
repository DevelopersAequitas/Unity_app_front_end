import '../../domain/entities/support_ticket_entity.dart';

class SupportTicketModel extends SupportTicketEntity {
  const SupportTicketModel({
    required super.id,
    required super.subject,
    required super.description,
    required super.status,
    super.department = 'General',
    super.priority = 'Medium',
    super.createdAt = '',
    super.adminReply,
    super.mediaUrl,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: (json['id'] ?? json['ticket_id'] ?? json['ticket_number'] ?? '').toString(),
      subject: (json['subject'] ?? json['title'] ?? 'Support Request').toString(),
      description: (json['description'] ?? json['message'] ?? json['details'] ?? '').toString(),
      status: (json['status'] ?? json['state'] ?? 'Pending').toString(),
      department: (json['department'] ?? json['category'] ?? json['screen_name'] ?? 'General').toString(),
      priority: (json['priority'] ?? 'Medium').toString(),
      createdAt: (json['created_at'] ?? json['date'] ?? '').toString(),
      adminReply: json['admin_reply']?.toString() ?? json['reply']?.toString() ?? json['response']?.toString(),
      mediaUrl: json['media_url']?.toString() ?? json['file_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'description': description,
      'status': status,
      'department': department,
      'priority': priority,
      'created_at': createdAt,
      'admin_reply': adminReply,
      'media_url': mediaUrl,
    };
  }
}
