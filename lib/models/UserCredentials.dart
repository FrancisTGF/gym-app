// @dart=2.7

import 'dart:convert';

import 'package:flutter/material.dart';

class UserCredentials {
  String email;
  String password;

  UserCredentials({@required this.email, this.password});

  toJson() {
    final loginData = {"email": email, "password": password};
    return json.encode(loginData);
  }
}
