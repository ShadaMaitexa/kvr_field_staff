class TaskModel {
  final String id;
  final String title;
  final String description;
  final String assigneeId;
  final String assignerId;
  final String? companyId;
  final DateTime dueDate;
  final String status;
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.assigneeId,
    required this.assignerId,
    this.companyId,
    required this.dueDate,
    required this.status,
    required this.createdAt,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      assigneeId: map['assignee_id'],
      assignerId: map['assigner_id'],
      companyId: map['company_id'],
      dueDate: DateTime.parse(map['due_date']),
      status: map['status'] ?? 'pending',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assignee_id': assigneeId,
      'assigner_id': assignerId,
      'company_id': companyId,
      'due_date': dueDate.toIso8601String(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
