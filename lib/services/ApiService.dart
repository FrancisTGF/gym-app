// @dart=2.7

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ApiService {
  String token;

  ApiService({this.token = ""});

  String getVeryfyFromToken() {
    final mapJwt = JWT.verify(token, SecretKey('localizacion'));
    return mapJwt.jwtId;
  }
}
