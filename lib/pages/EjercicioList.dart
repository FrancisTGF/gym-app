// @dart=2.7

import 'dart:ui';
import 'package:asesorias/app/AsesoriasApp.dart';
import 'package:asesorias/models/Ejercicio.dart';
import 'package:asesorias/models/EjerciciosViewModel.dart';
import 'package:asesorias/models/Event.dart';
import 'package:asesorias/models/PreferencesViewModels.dart';
import 'package:asesorias/widgets/EjercicioBackground.dart';
import 'package:asesorias/widgets/EjercicioDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:table_calendar/table_calendar.dart';

class EjercicioList extends StatelessWidget {
  Map<DateTime, List<Event>> selectedEvents = Map<DateTime, List<Event>>();

  List<Event> _getEventsfromDay(DateTime date, Map<DateTime, List<Event>> data) {

    selectedEvents = data;

    return selectedEvents[date.toUtc()] ?? [];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: ScopedModelDescendant<EjerciciosViewModel>(
            builder: (context, child, model) => Text(model.textMovimientos)),
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
          ScopedModelDescendant<EjerciciosViewModel>(
              builder: (context, child, model) => ListView(children: [
                    SizedBox(

                        child: calendar(model.diaSeleccionado)),
                SizedBox(

                      child: buildListView(context),
                    )
                  ])),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, AsesoriasApp.routeForm);
        },
      ),
    );
  }

  Widget buildListView([BuildContext context]) {
    return ScopedModelDescendant<EjerciciosViewModel>(
      builder: (context, child, model) => FutureBuilder<List<Ejercicio>>(
        future: model.ejerciciosList,
        builder: (context, snapshot) {
          var arguments;
          arguments = ModalRoute.of(context).settings.arguments;
          model.idAdminElegido = arguments;

          if (model.idAdminElegido != null) {
            model.refresh();
          } else {
            model.textMovimientos = 'Mis movimientos ';
          }

          var childWidget;

          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              childWidget = SizedBox(
                  height: 400, // fixed height
                  child: ListView(
                    children: [Center(child: CircularProgressIndicator())],
                  ));
              break;
            case ConnectionState.done:
              if (snapshot.hasError)
                childWidget = SizedBox(
                    height: 400, // fixed height
                    child: ListView(children: [
                      Center(
                        child: Text('error de conexion'),
                      ),
                    ]));
              else {
                if (snapshot.data == null || snapshot.data.length == 0) {
                  childWidget = SizedBox(
                      height: 400, // fixed height
                      child: warningEmptyList());
                } else {
                  childWidget = SizedBox(
                    height: MediaQuery.of(context).size.height * model.porcentaje,

                      child: buildFutureEjerciciosList(snapshot.data));
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

  ListView buildFutureEjerciciosList(List<Ejercicio> ejercicios) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: ejercicios.length,
      itemBuilder: (context, index) {
        var ejercicio = ejercicios[index];
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
                    deleteEjercicio(ejercicio, context);
                  },
                )
              ],
              child: Card(
                elevation: 10,
                child: ListTile(
                  title: Text(ejercicio.nombreEjercicio),
                  subtitle: Text('Kilos:  ' +
                      ejercicio.kilogramos +
                      '  Repes:  ' +
                      ejercicio.repeticiones +
                      '  RPE:  ' +
                      ejercicio.esfuerzoPercibido),
                  onTap: () {
                    Navigator.pushNamed(context, AsesoriasApp.routeForm,
                        arguments: ejercicio);

                  },
                ),
              ),
            ));
      },
    );
  }

  Widget calendar(DateTime dateTime) {

    return ScopedModelDescendant<EjerciciosViewModel>(
        builder: (context, child, model) => FutureBuilder(
            future: model.ejerciciosListEvent(),
            builder: (context, snapshot) {
              var childWidget;

              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  childWidget = SizedBox(
                      height: 400, // fixed height
                      child: ListView(
                        children: [Center(child: CircularProgressIndicator())],
                      ));
                  break;
                case ConnectionState.done:
                  if (snapshot.hasError)
                    childWidget = SizedBox(
                        height: 400, // fixed height
                        child: ListView(children: [
                          Center(
                            child: Text('error de conexion'),
                          ),
                        ]));
                  else {
                      childWidget = Card(
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.all(8.0),
                        child: TableCalendar(
                            daysOfWeekStyle: DaysOfWeekStyle(),
                            calendarFormat: model.calendarFormat,
                            onFormatChanged: ( format){
                              model.calendarFormat = format;
                              switch(format) {
                                case CalendarFormat.month:
                                  model.porcentaje=0.4;
                                  break;
                                case CalendarFormat.twoWeeks:
                                  model.porcentaje=0.6;
                                  break;
                                case CalendarFormat.week:
                                  model.porcentaje=0.7;
                                  break;
                              }
                              model.notifyListeners();

                            },
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            selectedDayPredicate: (day) {
                              return isSameDay(model.diaSeleccionado, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              model.diaSeleccionado = selectedDay;
                              model.diaFocused = focusedDay;
                              model.notifyListeners();
                            },
                            eventLoader: (day) {

                              return _getEventsfromDay(day, snapshot.data);
                            },
                            onPageChanged: (focusedDay) {
                              model.diaFocused = focusedDay;
                              model.notifyListeners();
                            },
                            calendarBuilders: CalendarBuilders(),
                            weekendDays: [6, 7],
                            headerStyle: HeaderStyle(
                              decoration: BoxDecoration(
                                color: Colors.black45,
                              ),
                              headerMargin: const EdgeInsets.only(bottom: 8.0),
                              titleTextStyle: TextStyle(
                                color: Colors.white,
                              ),
                              formatButtonDecoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              formatButtonTextStyle:
                                  TextStyle(color: Colors.white),
                              leftChevronIcon: Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                              ),
                              rightChevronIcon: Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                              ),
                            ),
                            calendarStyle: CalendarStyle(),
                            focusedDay: model.diaFocused,
                            lastDay: DateTime.now().add(Duration(days: 360)),
                            firstDay: DateTime.now().add(Duration(days: -360))),
                      );

                  }
                  break;

                default:
                  childWidget = ListView(children: [
                    Center(
                      child: Text('text'),
                    )
                  ]);
              }
              return childWidget;
            }));
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
              title: Text('No hay ejercicios para hoy'),
              subtitle: Text('Pulsa + para añadir mas ejercicios'),
            ),
          ),
        )
      ],
    );
  }

  Future<void> deleteEjercicio(Ejercicio ejercicios, BuildContext context) {
    var isDeleted = showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ELiminar Ejercicios'),
          content:
              Text('Estas seguro de eliminar ' + ejercicios.nombreEjercicio),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar'),
            ),
            ScopedModelDescendant<EjerciciosViewModel>(
              builder: (context, child, model) => FlatButton(
                onPressed: () {
                  model.removeEjercicio(ejercicios);
                  Navigator.pop(context);
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
