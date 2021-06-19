// @dart=2.7
import 'package:asesorias/app/AsesoriasApp.dart';
import 'package:asesorias/models/EjerciciosViewModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class EjercicioDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<EjerciciosViewModel>(
      builder: (context, child, model) => Drawer(
        child: ListView(
          children: [
            _buildDrawerHeader(model),
            if (!model.looged)
              ListTile(
                leading: Icon(Icons.login),
                title: Text('Iniciar sesion'),
                onTap: () {
                  Navigator.pop(context);
                  if (ModalRoute.of(context).settings.name !=
                      AsesoriasApp.routeLogin) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, AsesoriasApp.routeLogin, (route) => false);
                  }
                },
              ),
            if (model.looged)
              ListTile(
                leading: Icon(Icons.list),
                title: Text('Ver mis ejercicios'),
                onTap: () {
                  Navigator.pop(context);
                  if (ModalRoute.of(context).settings.name ==
                      AsesoriasApp.routeForm) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, AsesoriasApp.routeList, (route) => false);
                  }
                  Navigator.pushNamedAndRemoveUntil(
                      context, AsesoriasApp.routeList, (route) => false);
                },
              ),
            if (model.looged)
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Nuevo ejercicio'),
                onTap: () async {
                  Navigator.pop(context);
                  if (ModalRoute.of(context).settings.name !=
                      AsesoriasApp.routeForm) {
                    Navigator.pushNamed(context, AsesoriasApp.routeForm);
                  }
                },
              ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Preferencias'),
              onTap: () async {
                Navigator.pop(context);
                if (ModalRoute.of(context).settings.name !=
                    AsesoriasApp.routeSettings) {
                  Navigator.pushNamed(context, AsesoriasApp.routeSettings);
                }
              },
            ),
            if (model.looged)
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Cerrar sesion'),
                onTap: () async {
                  model.looged=false;
                  Navigator.pushNamed(
                      context, AsesoriasApp.routeLogin);
                },
              ),
            if (model.looged)
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Mis Datos'),
                onTap: () async {
                  Navigator.pushNamed(context, AsesoriasApp.routeRegister,
                      arguments: model.user);

                },
              ),
            if (model.isAdmin && model.looged)

              ListTile(
                leading: Icon(Icons.person),
                title: Text('Usuarios'),
                onTap: () async {
                  Navigator.pushNamed(context, AsesoriasApp.routeUserList,
                      arguments: model.user);

                },
              )
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(EjerciciosViewModel model) {
    if (model.looged) {
      return UserAccountsDrawerHeader(
        accountName: Text(model.user.firstname),
        accountEmail: Text(model.user.email),
        currentAccountPicture: CircleAvatar(
          backgroundImage: AssetImage('assets/image/334588-128.png'),
        ),
      );
    } else {
      return DrawerHeader(
        decoration: BoxDecoration(
            color: Colors.blue, backgroundBlendMode: BlendMode.screen),
        child: Stack(
          children: [
            Center(
              child: Text(
                'Mis Notas',
                style: TextStyle(fontSize: 30),
              ),
            ),
            Container(
              child: Text('Sesion no iniciada.'),
              alignment: Alignment.bottomLeft,
            )
          ],
        ),
      );
    }
  }
}
