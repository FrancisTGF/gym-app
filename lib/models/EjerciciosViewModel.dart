// @dart=2.7

import 'dart:async';

import 'package:asesorias/models/Ejercicio.dart';
import 'package:asesorias/models/Event.dart';
import 'package:asesorias/models/Preferences.dart';
import 'package:asesorias/models/User.dart';
import 'package:asesorias/models/UserCredentials.dart';
import 'package:asesorias/responses/RegisterResponse.dart';
import 'package:asesorias/services/AuthApiService.dart';
import 'package:asesorias/services/AsesoriasApiService.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:table_calendar/src/shared/utils.dart';
import 'package:table_calendar/table_calendar.dart';

import 'Ejercicio.dart';

class EjerciciosViewModel extends Model {

  Preferences preferences = Preferences();
  int dia;
  int mes;
  int year ;
  DateTime diaSeleccionado;
  DateTime diaFocused;
  AsesoriasApiService api;
  AuthApiService apiService;
  CalendarFormat calendarFormat;
  bool looged = false;
  bool isAdmin = false;
  String idAdminElegido;
  Usuario user;
  var textMovimientos='Mis Movimientos';

  double porcentaje = 0.4;

  Future<List<Ejercicio>> get ejerciciosList async {

    if (isTokenValid()) {
      Future<List<Ejercicio>> ejercicios =  api.getEjercicios(
          diaSeleccionado , idUsuarioAdmin: idAdminElegido  );
      await Future.delayed(Duration(milliseconds: 500));
      return ejercicios;

    } else {
      logout();



      notifyListeners();
    }
  }
  Future<Map<DateTime , List<Event>>>  ejerciciosListEvent()  async {

    if (isTokenValid()) {
      Map<DateTime , List<Event>> eventos = await api.getEjerciciosEvent(
            idUsuarioAdmin: idAdminElegido  ) ;
       await Future.delayed(Duration(milliseconds: 500));
      return eventos;

    } else {
      logout();

      notifyListeners();
    }
  }


  Future<List<Usuario>> get users async {
    if (isTokenValid()) {
      final users = api.getUser();

      await Future.delayed(Duration(milliseconds: 500));
      return users;
    } else {
      logout();
      notifyListeners();
    }
  }



  addEjercicio(Ejercicio ejercicio) async {
    await api.addEjercicios(ejercicio);
    notifyListeners();
  }

  removeEjercicio(Ejercicio ejercicio) async {
  api.removeEjercicio(ejercicio);
    notifyListeners();
  }

  removeUser(Usuario user) async {
    await api.removeUser(user);
    notifyListeners();
  }

  updateEjercicio(Ejercicio ejercicio) async {
    await api.updateEjercicio(ejercicio);
    notifyListeners();
  }

  updateUser(Usuario user) async {
    await api.updateUser(user);
    notifyListeners();
  }

  Future<void> refresh() async {
    notifyListeners();
  }

  Future<bool> login(UserCredentials credentials) async {
    final token = await apiService.login(credentials);
    return setLoginStatus(token);
  }

  bool isTokenValid() {
    final token = preferences.token;
    if (token != null && token != "") {
      return AuthApiService(token: token).isTokenValid();
    }
    return false;
  }

  EjerciciosViewModel() {
    if (isTokenValid()) {
      api = AsesoriasApiService(preferences.token);
      apiService = AuthApiService(token: preferences.token);
      dia=DateTime.now().day;
      mes=DateTime.now().month;
      year =DateTime.now().year;
      diaSeleccionado=DateTime.utc(year,mes,dia);
      diaFocused=DateTime.now();
      calendarFormat=CalendarFormat.month;
      getUser();
      looged = true;
    } else {
      apiService = AuthApiService();
    }
  }

  getUser() async {
    user = await apiService.getUser();
    if (user.email == 'admin@admin.com') {
      isAdmin = true;
    } else {
      isAdmin = false;
    }
  }

  logout() {
    looged = false;
    preferences.token = null;
  }

  Future<RegisterResponse> register(Usuario user) async {
    final response = await apiService.register(user);
    if (response.status == RegisterResponseStatus.Success) {
      setLoginStatus(response.token);
    }
    return response;
  }

  bool setLoginStatus(String token) {
    if (token != null) {
      looged = true;
      preferences.token = token;
      api = AsesoriasApiService(token);
      getUser();
      return true;
    } else {
      looged = false;
      preferences.token = null;
      return false;
    }
  }
}
