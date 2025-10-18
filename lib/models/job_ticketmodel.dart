class Job {
  final int? id;
  final String title;
  final String description;
  final String status;
  final String assignedTo;
  final String createdAt;
  final String priority; // ✅ New field

  Job({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.assignedTo,
    required this.createdAt,
    required this.priority,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'assignedTo': assignedTo,
      'createdAt': createdAt,
      'priority': priority,
    };
  }

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'] as int?,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? '',
      assignedTo: map['assignedTo'] ?? '',
      createdAt: map['createdAt'] ?? '',
      priority: map['priority'] ?? 'Low',
    );
  }

  Job copyWith({
    int? id,
    String? title,
    String? description,
    String? status,
    String? assignedTo,
    String? createdAt,
    String? priority,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
    );
  }
}
