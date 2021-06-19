// @dart=2.7

import 'package:asesorias/models/EjerciciosViewModel.dart';
import 'package:asesorias/models/PreferencesViewModels.dart';
import 'package:asesorias/pages/EjercicioList.dart';
import 'package:asesorias/pages/EjerciciosForm.dart';
import 'package:asesorias/pages/UserLogin.dart';
import 'package:asesorias/pages/UserRegister.dart';
import 'package:asesorias/pages/AsesoriasSettings.dart';
import 'package:asesorias/pages/UserList.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AsesoriasApp extends StatelessWidget {
  static String routeForm = '/ejerciciosForm';
  static String routeList = '/ejerciciosList';
  static String routeSettings = '/asesoriasSettings';
  static String routeLogin = '/userLogin';
  static String routeRegister = '/userRegister';
  static String routeUserList = '/userList';

  EjerciciosViewModel ejerciciosViewModel;

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: EjerciciosViewModel(),
      child: ScopedModel(
        model: PreferencesViewModels(),
        child: ScopedModelDescendant<EjerciciosViewModel>(
          builder: (context, child, model) {
            var initalRoute = routeLogin;
            if (ejerciciosViewModel.isTokenValid()) {
              initalRoute = routeList;
            }
            return MaterialApp(
              key: UniqueKey(),
              title: 'Asesorias aplicación',
              theme: ThemeData(
                  primaryColor: Colors.blueGrey, accentColor: Colors.yellow),
              routes: {
                routeList: (context) => EjercicioList(),
                routeForm: (context) => EjerciciosForm(),
                routeSettings: (context) => AsesoriasSettings(),
                routeLogin: (context) => UserLogin(),
                routeRegister: (context) => UserRegister(),
                routeUserList: (context) => UserList()
              },
              initialRoute: initalRoute,
            );
          },
        ),
      ),
    );
  }

  AsesoriasApp() {
    this.ejerciciosViewModel = EjerciciosViewModel();
  }
}
