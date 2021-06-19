// @dart=2.7

import 'dart:async';

import 'package:asesorias/models/Ejercicio.dart';
import 'package:asesorias/models/Event.dart';
import 'package:asesorias/models/User.dart';
import 'package:asesorias/services/ApiService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class AsesoriasApiService extends ApiService {
  AsesoriasApiService(String token) : super(token: token);

  Future<List<Ejercicio>> getEjercicios(DateTime diaSeleccionado,
      {String idUsuarioAdmin}) async {
    String userId = FirebaseAuth.instance.currentUser.uid;

    List<Ejercicio> ejercicios = [];
    try {
      await FirebaseFirestore.instance
          .collection('ejercicio')
          .snapshots()
          .listen((snapshot) {
        snapshot.docs.forEach((document) async {
          /* if (idUsuarioAdmin != null) {
         userId = idUsuarioAdmin;
       } else {
         userId = document.data()['userId'];
       }*/
          var time = Timestamp.fromDate(diaSeleccionado);
          bool condicion = time.compareTo(document.data()['fecha']) == 0;
          if (document.data()['userId'] == userId && condicion) {
            ejercicios.add(Ejercicio(
                id: document.data()['id'],
                nombreEjercicio: document.data()['nombre'],
                repeticiones: document.data()['repeticiones'],
                esfuerzoPercibido: document.data()['esfuerzo_percibido'],
                kilogramos: document.data()['kilogramos'],
                fecha: (document.data()['fecha']).toDate(),
                userId: document.data()['userId']));
          }
        });
      });

      return await ejercicios;
    } catch (exception) {
      return ejercicios;
    }
  }

  Future<List<Usuario>> getUser() async {
    List<Usuario> usuarios = [];
    await FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((snapshot) {
      snapshot.docs.forEach((document) {
        usuarios.add(
          Usuario(
              id: document['id'],
              email: document['email'],
              firstname: document['firstname'],
              peso: document['peso'],
              altura: document['altura'],
              edad: document['edad'],
              annosEntrenando: document['annos_entrenando'],
              rmSquat: document['rm_squat'],
              rmBench: document['rm_bench'],
              rmDeadlift: document['rm_dead_lift']),
        );
      });
    });
    return usuarios;
  }

  Future<Ejercicio> addEjercicios(Ejercicio ejercicio) async {
    String uuid = Uuid().v1();
    final userId = FirebaseAuth.instance.currentUser.uid;
    ejercicio.userId = userId;
    await FirebaseFirestore.instance.collection('ejercicio').doc(uuid).set({
      'id': uuid,
      'nombre': ejercicio.nombreEjercicio,
      'kilogramos': ejercicio.kilogramos,
      'esfuerzo_percibido': ejercicio.esfuerzoPercibido,
      'repeticiones': ejercicio.repeticiones,
      'fecha': ejercicio.fecha,
      'userId': ejercicio.userId,
    });
  }

  Future<Ejercicio> updateEjercicio(Ejercicio ejercicio) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance
        .collection('ejercicio')
        .doc(ejercicio.id)
        .set({
      'id': ejercicio.id,
      'nombre': ejercicio.nombreEjercicio,
      'kilogramos': ejercicio.kilogramos,
      'esfuerzo_percibido': ejercicio.esfuerzoPercibido,
      'repeticiones': ejercicio.repeticiones,
      'fecha': ejercicio.fecha,
      'userId': ejercicio.userId,
    });
  }

  Future<bool> removeEjercicio(Ejercicio ejercicio) async {
    try {
      await FirebaseFirestore.instance
          .collection('ejercicio')
          .doc(ejercicio.id)
          .delete();
      return true;
    } catch (Exception) {
      return false;
    }
  }

  Future<Usuario> updateUser(Usuario user) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.collection('users').doc(user.id).set({
      "email": user.email,
      "firstname": user.firstname,
      "password": user.password,
      "peso": user.peso,
      "altura": user.altura,
      "edad": user.edad,
      "annos_entrenando": user.annosEntrenando,
      "rm_squat": user.rmSquat,
      "rm_bench": user.rmBench,
      "rm_dead_lift": user.rmDeadlift,
      "id": user.id
    });
  }

  Future<Usuario> addUser(Usuario user) async {
    String uuid = Uuid().v1();
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
  }

  Future<bool> removeUser(Usuario user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .delete();
      return true;
    } catch (Exception) {
      return false;
    }
  }

  Future<Map<DateTime, List<Event>>> getEjerciciosEvent(
      {String idUsuarioAdmin}) async {
    String userId = FirebaseAuth.instance.currentUser.uid;

    Map<DateTime, List<Event>> eventos = {};
    try {
      await FirebaseFirestore.instance
          .collection('ejercicio')
          .snapshots()
          .listen((snapshot) {
        snapshot.docs.forEach((document) async {
          /* if (idUsuarioAdmin != null) {
         userId = idUsuarioAdmin;
       } else {
         userId = document.data()['userId'];
       }*/
          if (document.data()['userId'] == userId) {
            if (eventos[document.data()['fecha'].toDate().toUtc()] == null) {
              eventos[document.data()['fecha'].toDate().toUtc()] =
                  ([Event(nombre: (document.data()['id']))]);
            } else {
              eventos[document.data()['fecha'].toDate().toUtc()]
                  .add((Event(nombre: (document.data()['id']))));
            }
          }
        });
      });

      return eventos;
    } catch (exception) {
      return eventos;
    }
  }
}
