class Project {
  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
    this.dueDate,
    this.assignedStudents = const [],
    this.tutors = const [],
    this.tags = const [],
    this.attachments = const [],
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    status: json['status'] as String,
    createdBy: json['createdBy'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt'] as String) 
        : null,
    dueDate: json['dueDate'] != null 
        ? DateTime.parse(json['dueDate'] as String) 
        : null,
    assignedStudents: (json['assignedStudents'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList() ?? [],
    tutors: (json['tutors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList() ?? [],
    tags: (json['tags'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList() ?? [],
    attachments: (json['attachments'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList() ?? [],
  );

  final String id;
  final String title;
  final String description;
  final String status;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? dueDate;
  final List<String> assignedStudents;
  final List<String> tutors;
  final List<String> tags;
  final List<String> attachments;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'status': status,
    'createdBy': createdBy,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'dueDate': dueDate?.toIso8601String(),
    'assignedStudents': assignedStudents,
    'tutors': tutors,
    'tags': tags,
    'attachments': attachments,
  };

  Project copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    List<String>? assignedStudents,
    List<String>? tutors,
    List<String>? tags,
    List<String>? attachments,
  }) => Project(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    status: status ?? this.status,
    createdBy: createdBy ?? this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    dueDate: dueDate ?? this.dueDate,
    assignedStudents: assignedStudents ?? this.assignedStudents,
    tutors: tutors ?? this.tutors,
    tags: tags ?? this.tags,
    attachments: attachments ?? this.attachments,
  );
} 
