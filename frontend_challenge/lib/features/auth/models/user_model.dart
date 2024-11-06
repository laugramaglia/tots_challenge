import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

// final example = {
//   "avatar": "",
//   "collectionId": "_pb_users_auth_",
//   "collectionName": "users",
//   "created": "2024-11-05 12:45:38.728Z",
//   "email": "test3@tots.agency",
//   "emailVisibility": false,
//   "id": "qihasw53kmka6xv",
//   "name": "Test",
//   "updated": "2024-11-05 12:46:55.099Z",
//   "username": "users24334",
//   "verified": true
// };

@JsonSerializable()
class UserModel extends Equatable {
  final String name;
  final String email;
  final String id;
  final String token;
  const UserModel({
    required this.name,
    required this.email,
    required this.id,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? name,
    String? email,
    String? id,
    String? token,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      token: token ?? this.token,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, id: $id, token: $token)';
  }

  @override
  List<Object?> get props => [name, email, id, token];
}
