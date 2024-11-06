import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:frontend_challenge/core/constants/server_constats.dart';
import 'package:frontend_challenge/core/extensions/string.dart';

class CustomerModel extends Equatable {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String? avatar;
  final File? selectedImage;

  const CustomerModel(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.email,
      this.avatar,
      this.selectedImage});

  String get fullName => '${firstname.capitalize()} ${lastname.capitalize()}';
  bool get hasImage => (avatar?.isNotEmpty ?? false);
  String get imageUrl => '${Environment().baseUrl}/files/clients/$id/$avatar';

  @override
  List<Object?> get props => [
        firstname,
        lastname,
        email,
        avatar,
        id,
      ];

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      avatar: json['photo'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;

    return data;
  }
}
