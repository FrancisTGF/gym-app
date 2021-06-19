import 'package:flutter/material.dart';
class Event {

  String nombre;

  Event( {required this.nombre});

  static Event fromMap(Map<String, dynamic> event) => Event(nombre: event['nombre']);

  void copyFrom(Event otherEvent) {
    nombre = otherEvent.nombre;
  }


}