// @dart=2.7

import 'dart:convert';

import 'package:asesorias/models/UserCredentials.dart';
import 'package:flutter/material.dart';

class Usuario extends UserCredentials {
  String id;
  String firstname;
  String peso;
  String altura;
  String edad;
  String porcentajeGraso;
  String annosEntrenando;
  String rmSquat;
  String rmBench;
  String rmDeadlift;

  Usuario({
    this.id,
    @required email,
    password,
    this.firstname,
    this.peso,
    this.altura,
    this.edad,
    this.porcentajeGraso,
    this.annosEntrenando,
    this.rmSquat,
    this.rmBench,
    this.rmDeadlift,
  }) : super(email: email, password: password);

  get fullName {
    return "$firstname ";
  }

  loginToJson() {
    final loginData = {"email": email, "password": password};
    return json.encode(loginData);
  }

  String toJson() {
    final loginData = {
      "id" : id,
      "email": email,
      "firstname": firstname,
      "password": password,
      "peso": peso,
      "altura": altura,
      "edad": edad,
      "annos_entrenando": annosEntrenando,
      "rm_squat": rmSquat,
      "rm_bench": rmBench,
      "rm_dead_lift": rmDeadlift
    };
    return json.encode(loginData);
  }

  static List<Usuario> userFromJson(String jsonData) {
    final data = json.decode(jsonData);
    final users = List<Usuario>.from(data.map((user) => Usuario.fromMap(user)));
    var filteredNotes = <Usuario>[];
    users.forEach((user) {
      filteredNotes.add(user);
    });
    return filteredNotes;
  }

  void copyFrom(Usuario otherUser) {
    id = otherUser.id;
    email = otherUser.email;
    firstname = otherUser.firstname;
    password = otherUser.firstname;
    peso = otherUser.peso;
    altura = otherUser.altura;
    edad = otherUser.edad;
    annosEntrenando = otherUser.annosEntrenando;
    rmSquat = otherUser.rmSquat;
    rmDeadlift = otherUser.rmDeadlift;
    rmBench = otherUser.rmBench;
  }

  static Usuario fromJson(String body) {
    final data = json.decode(body);
    return fromMap(data);
  }

  static fromMap(Map<String, dynamic> userMap) {
    return Usuario(
        id: userMap['id'],
        email: userMap['email'],
        firstname: userMap['firstname'],
        peso: userMap['peso'],
        altura: userMap['altura'],
        edad: userMap['edad'],
        annosEntrenando: userMap['annos_entrenando'],
        rmSquat: userMap['rm_squat'],
        rmBench: userMap['rm_bench'],
        rmDeadlift: userMap['rm_dead_lift']);
  }
}
