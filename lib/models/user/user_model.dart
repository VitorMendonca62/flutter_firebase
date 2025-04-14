// lib/models/user_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;
  final String accessToken;
  final bool isEmailVerified;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.accessToken,
    required this.isEmailVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
