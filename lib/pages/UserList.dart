// @dart=2.7

import 'package:asesorias/app/AsesoriasApp.dart';
import 'package:asesorias/models/EjerciciosViewModel.dart';
import 'package:asesorias/models/Preferences.dart';
import 'package:asesorias/models/PreferencesViewModels.dart';
import 'package:asesorias/models/User.dart';
import 'package:asesorias/widgets/EjercicioDrawer.dart';
import 'package:asesorias/widgets/EjercicioBackground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:asesorias/models/Preferences.dart';
import 'package:scoped_model/scoped_model.dart';

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final preferences = Preferences();
    var background = preferences.ejercicosBackground;

    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios del sistema'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, AsesoriasApp.routeSettings);

            },
          )
        ],
      ),
      drawer: EjercicioDrawer(),
      body: Stack(
        children: [
          ScopedModelDescendant<PreferencesViewModels>(
              builder: (context, child, model) =>
                  EjercicioBackground(image: model.background)),
          buildListView(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        onPressed: () {

              Navigator.pushNamed(context, AsesoriasApp.routeRegister);
        },
      ),
    );
  }

  Widget buildListView([BuildContext context]) {
    return ScopedModelDescendant<EjerciciosViewModel>(
      builder: (context, child, model) => FutureBuilder<List<Usuario>>(
        future: model.users,
        builder: (context, snapshot) {
          var childWidget;

          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              childWidget = ListView(
                children: [Center(child: CircularProgressIndicator())],
              );
              break;
            case ConnectionState.done:
              if (snapshot.hasError)
                childWidget = ListView(children: [
                  Center(
                    child: Text('error de conexion'),
                  ),
                ]);
              else {
                if (snapshot.data == null || snapshot.data.length == 0) {
                  childWidget = warningEmptyList();
                } else {
                  childWidget = buildFutureNotesList(snapshot.data);
                }
              }
              break;

            default:
              childWidget = ListView(children: [
                Center(
                  child: Text('text'),
                )
              ]);
          }
          return RefreshIndicator(
              onRefresh: () => model.refresh(), child: childWidget);
        },
      ),
    );
  }

  ListView buildFutureNotesList(List<Usuario> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        var user = users[index];
        return Padding(
            padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: [
                IconSlideAction(
                  caption: 'Borrar',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    deleteUser(user, context);
                  },

                ),IconSlideAction(
                  caption: 'Actualizar',
                  color: Colors.yellow,
                  icon: Icons.update,
                  onTap: () {
                    Navigator.pushNamed(context, AsesoriasApp.routeRegister,
                        arguments: user);
                  },

                )
              ],
              child: Card(
                elevation: 10,
                child: ListTile(
                  title: Text(user.email),
                  subtitle: Text("Nombre: " +
                      user.firstname +
                      "   Edad: " +
                      user.edad +
                      "   Altura: " +
                      user.altura +
                      "   Peso: " +
                      user.peso),
                  onTap: () {

                    Navigator.pushNamed(context, AsesoriasApp.routeList,
                        arguments: user.id);


                    // setState(() {
                    //
                    // });
                  },
                ),
              ),
            ));
      },
    );
  }

  Widget warningEmptyList() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            color: Colors.orangeAccent,
            child: ListTile(
              leading: Icon(Icons.warning),
              title: Text('No hay usuarios'),
              subtitle: Text('Pulsa + para añadir mas usuarios'),
            ),
          ),
        )
      ],
    );
  }

  Future<void> deleteUser(Usuario user, BuildContext context) {
    var isDeleted = showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ELiminar usuario'),
          content: Text('¿Estas seguro de eliminar ' + user.email + ' ?'),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar'),
            ),
            ScopedModelDescendant<EjerciciosViewModel>(
              builder: (context, child, model) => FlatButton(
                onPressed: () {
                  model.removeUser(user);
                },
                child: Text('Borrar'),
              ),
            )
          ],
        );
      },
    );
  }

}
