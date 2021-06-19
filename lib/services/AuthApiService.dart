// @dart=2.7

import 'dart:convert';

import 'package:asesorias/models/User.dart';
import 'package:asesorias/models/UserCredentials.dart';
import 'package:asesorias/responses/RegisterResponse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:uuid/uuid.dart';

import 'ApiService.dart';

class AuthApiService extends ApiService {
  AuthApiService({String token = ""}) : super(token: token);

  User user = FirebaseAuth.instance.currentUser;

  Future<String> login(UserCredentials credentials) async {
    UserCredential auth;
    try {
      auth = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: credentials.email,
        password: credentials.password,
      )
          .then((auths) {
        var jwt = JWT(
          {
            'id': auths.user.uid,
            'server': {
              'id': '3e4fc296',
              'loc': 'euw-2',
            }
          },
          issuer: 'https://github.com/jonasroussel/jsonwebtoken',
        );
        token =
            jwt.sign(SecretKey('localizacion'), expiresIn: Duration(days: 1));
      });
      user = FirebaseAuth.instance.currentUser;
      return token;
    } on FirebaseAuthException catch (e) {
      e;
    }
  }

  bool isTokenValid() {
    return true;
  }

  Future<Usuario> getUser() async {
    String idUser = user.uid;

    DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('users').doc(idUser).get();
    return Usuario(
        id: document['id'],
        email: document['email'],
        firstname: document['firstname'],
        peso: document['peso'],
        altura: document['altura'],
        edad: document['edad'],
        annosEntrenando: document['annos_entrenando'],
        rmSquat: document['rm_squat'],
        rmBench: document['rm_bench'],
        rmDeadlift: document['rm_dead_lift']);
  }

  Future<RegisterResponse> register(Usuario user) async {
    UserCredential users;
     users = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: user.email, password: user.password)
        .then((user) {
      var jwt = JWT(
        {
          'id': user.user.uid,
          'server': {
            'id': '3e4fc296',
            'loc': 'euw-2',
          }
        },
        issuer: 'https://github.com/jonasroussel/jsonwebtoken',
      );

      token = jwt.sign(SecretKey('localizacion'), expiresIn: Duration(days: 1));

      return users;
    });
    FirebaseAuth.instance.signInWithEmailAndPassword(email: user.email, password: user.password);

    try {
      String uuid = FirebaseAuth.instance.currentUser.uid;
      await FirebaseFirestore.instance.collection('users').doc(uuid).set({
        "id": uuid,
        "email": user.email,
        "firstname": user.firstname,
        "password": user.password,
        "peso": user.peso,
        "altura": user.altura,
        "edad": user.edad,
        "annos_entrenando": user.annosEntrenando,
        "rm_squat": user.rmSquat,
        "rm_bench": user.rmBench,
        "rm_dead_lift": user.rmDeadlift
      });
    } catch (e) {}
  }
}
