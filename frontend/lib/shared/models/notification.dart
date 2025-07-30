class Notification {
  const Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.readAt,
    this.userId,
    this.data = const {},
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    id: json['id'] as String,
    title: json['title'] as String,
    message: json['message'] as String,
    type: json['type'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    readAt: json['readAt'] != null 
        ? DateTime.parse(json['readAt'] as String) 
        : null,
    userId: json['userId'] as String?,
    data: (json['data'] as Map<String, dynamic>?) ?? {},
  );

  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime createdAt;
  final DateTime? readAt;
  final String? userId;
  final Map<String, dynamic> data;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'type': type,
    'createdAt': createdAt.toIso8601String(),
    'readAt': readAt?.toIso8601String(),
    'userId': userId,
    'data': data,
  };

  Notification copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    DateTime? createdAt,
    DateTime? readAt,
    String? userId,
    Map<String, dynamic>? data,
  }) => Notification(
    id: id ?? this.id,
    title: title ?? this.title,
    message: message ?? this.message,
    type: type ?? this.type,
    createdAt: createdAt ?? this.createdAt,
    readAt: readAt ?? this.readAt,
    userId: userId ?? this.userId,
    data: data ?? this.data,
  );

  bool get isRead => readAt != null;
} 