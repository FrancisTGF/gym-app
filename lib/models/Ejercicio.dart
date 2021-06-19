// @dart=2.7

import 'dart:convert';

import 'package:flutter/material.dart';

enum NoteColor { Red, Green, Blue, Yellow, Orange }

t enumFromString<t>(Iterable<t> values, String value) {
  return values.firstWhere((color) => color.toString() == value,
      orElse: () => null);
}

class Ejercicio {
  String id;
  String nombreEjercicio;
  String kilogramos;
  String repeticiones;
  String esfuerzoPercibido;

  DateTime fecha;
  String userId;

  static final NoteColorMap = <NoteColor, Color>{
    NoteColor.Red: Colors.red,
    NoteColor.Blue: Colors.blue,
    NoteColor.Green: Colors.green,
    NoteColor.Yellow: Colors.yellow,
    NoteColor.Orange: Colors.orange,
  };

  //Constructor
  Ejercicio(
      {this.id,
      @required this.nombreEjercicio = '',
      this.kilogramos = '',
      this.repeticiones = '',
      this.esfuerzoPercibido = '',
      this.fecha,
      this.userId});

  static Ejercicio fromMap(Map<String, dynamic> ejercicio) => Ejercicio(
      id: ejercicio['id'],
      nombreEjercicio: ejercicio['nombreEjercicio'],
      kilogramos: ejercicio['kilogramos'],
      repeticiones: ejercicio['repeticiones'],
      esfuerzoPercibido: ejercicio['esfuerzo_percibido'],
      fecha: ejercicio['fecha'],
      userId: ejercicio['userId']);

  static List<Ejercicio> ejercicioFromJson(String jsonData, int filterId) {
    final data = json.decode(jsonData);
    final ejercicios = List<Ejercicio>.from(
        data.map((ejercicio) => Ejercicio.fromMap(ejercicio)));
    var filteredEjercicios = <Ejercicio>[];
    ejercicios.forEach((ejercicio) {
      if (ejercicio.userId == filterId) {
        filteredEjercicios.add(ejercicio);
      }
    });
    return filteredEjercicios;
  }

  void copyFrom(Ejercicio otherEjercicios) {
    id = otherEjercicios.id;
    nombreEjercicio = otherEjercicios.nombreEjercicio;
    kilogramos = otherEjercicios.kilogramos;
    repeticiones = otherEjercicios.repeticiones;
    esfuerzoPercibido = otherEjercicios.esfuerzoPercibido;
    fecha = otherEjercicios.fecha;
    userId = otherEjercicios.userId;
  }

  /*getMaterialColor() {
    return NoteColorMap[color];
  }*/
/*
  static Color getMaterialEnumColor(NoteColor color) {
    return NoteColorMap[color];
  }
*/
  toJson() {
    return json.encode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nombreEjercicio": nombreEjercicio,
      "kilogramos": kilogramos,
      "repeticiones": repeticiones,
      "esfuerzo_percibido": esfuerzoPercibido,
      "fecha": fecha,
      "userId": userId
    };
  }

  static Ejercicio fromJson(String body) {
    final data = json.decode(body);
    return fromMap(data);
  }
}
