class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
    this.dueDate,
    this.assignedTo,
    this.projectId,
    this.tags = const [],
    this.attachments = const [],
    this.comments = const [],
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    status: json['status'] as String,
    priority: json['priority'] as String,
    createdBy: json['createdBy'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt'] as String) 
        : null,
    dueDate: json['dueDate'] != null 
        ? DateTime.parse(json['dueDate'] as String) 
        : null,
    assignedTo: json['assignedTo'] as String?,
    projectId: json['projectId'] as String?,
    tags: (json['tags'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList() ?? [],
    attachments: (json['attachments'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList() ?? [],
    comments: (json['comments'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList() ?? [],
  );

  final String id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? dueDate;
  final String? assignedTo;
  final String? projectId;
  final List<String> tags;
  final List<String> attachments;
  final List<String> comments;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'status': status,
    'priority': priority,
    'createdBy': createdBy,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'dueDate': dueDate?.toIso8601String(),
    'assignedTo': assignedTo,
    'projectId': projectId,
    'tags': tags,
    'attachments': attachments,
    'comments': comments,
  };

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? priority,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    String? assignedTo,
    String? projectId,
    List<String>? tags,
    List<String>? attachments,
    List<String>? comments,
  }) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    status: status ?? this.status,
    priority: priority ?? this.priority,
    createdBy: createdBy ?? this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    dueDate: dueDate ?? this.dueDate,
    assignedTo: assignedTo ?? this.assignedTo,
    projectId: projectId ?? this.projectId,
    tags: tags ?? this.tags,
    attachments: attachments ?? this.attachments,
    comments: comments ?? this.comments,
  );
} 