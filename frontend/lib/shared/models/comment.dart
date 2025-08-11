class Comment {
  const Comment({
    required this.id,
    required this.content,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
    this.parentId,
    this.attachments = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json['id'] as String,
    content: json['content'] as String,
    createdBy: json['createdBy'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt'] as String) 
        : null,
    parentId: json['parentId'] as String?,
    attachments: (json['attachments'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList() ?? [],
  );

  final String id;
  final String content;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? parentId;
  final List<String> attachments;

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'createdBy': createdBy,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'parentId': parentId,
    'attachments': attachments,
  };

  Comment copyWith({
    String? id,
    String? content,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? parentId,
    List<String>? attachments,
  }) => Comment(
    id: id ?? this.id,
    content: content ?? this.content,
    createdBy: createdBy ?? this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    parentId: parentId ?? this.parentId,
    attachments: attachments ?? this.attachments,
  );
} 
