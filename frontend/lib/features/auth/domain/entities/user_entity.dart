import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required int id,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    required bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? profileImage,
    String? phone,
    String? department,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
      
  const UserEntity._();
  
  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();
}
