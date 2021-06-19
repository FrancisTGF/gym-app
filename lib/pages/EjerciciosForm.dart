// @dart=2.7

import 'package:asesorias/models/Ejercicio.dart';
import 'package:asesorias/models/EjerciciosViewModel.dart';
import 'package:asesorias/widgets/ColorPicker.dart';
import 'package:asesorias/widgets/EjercicioDrawer.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class EjerciciosForm extends StatefulWidget {
  @override
  _EjerciciosFormState createState() => _EjerciciosFormState();
}

class _EjerciciosFormState extends State<EjerciciosForm> {
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  Ejercicio ejercicio = Ejercicio();
  Ejercicio updateEjercicio;
  bool isEditing = false;
  NoteColor selectedColor = NoteColor.Blue;

  @override
  Widget build(BuildContext context) {

    var arguments;
    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      updateEjercicio = arguments as Ejercicio;
      ejercicio.id = updateEjercicio.id;
      ejercicio.userId = updateEjercicio.userId;

      isEditing = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva Ejercicio'),
      ),
      drawer: EjercicioDrawer(),
      bottomNavigationBar: buildRow(context),
      body: buildForm(context),
    );
  }

  Row buildRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FlatButton(
            onPressed: () {
              guardar(context);
            },
            child: Text('Guardar')),
        FlatButton(
            onPressed: () {
              cancelar(context);
            },
            child: Text('Cancelar')),
      ],
    );
  }

  Form buildForm(BuildContext context) {
    return Form(
      key: globalFormKey,
      child: Column(
        children: [
          ListTile(
              leading: Icon(Icons.title),
              title: TextFormField(
                initialValue: isEditing
                    ? updateEjercicio.nombreEjercicio
                    : ejercicio.nombreEjercicio,
                validator: validateTitle,
                onSaved: (newValue) => ejercicio.nombreEjercicio = newValue,
                decoration: InputDecoration(hintText: 'Nombre del ejercicio'),
              )),
          ListTile(
            leading: Icon(Icons.description),
            title: TextFormField(
              initialValue:
                  isEditing ? updateEjercicio.kilogramos : ejercicio.kilogramos,
              onSaved: (newValue) => ejercicio.kilogramos = newValue,
              maxLines: 1,
              decoration: InputDecoration(hintText: 'Kilogramos'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: TextFormField(
              initialValue:
                  isEditing ? updateEjercicio.repeticiones : ejercicio.repeticiones,
              onSaved: (newValue) => ejercicio.repeticiones = newValue,
              maxLines: 1,
              decoration: InputDecoration(hintText: 'Repeticiones'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: TextFormField(
              initialValue:
                  isEditing ? updateEjercicio.esfuerzoPercibido : ejercicio.esfuerzoPercibido,
              onSaved: (newValue) => ejercicio.esfuerzoPercibido = newValue,
              maxLines: 1,
              decoration: InputDecoration(hintText: 'Esfuerzo percibido(RPE)'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.date_range),
            title: DateTimeFormField(
              mode: DateTimeFieldPickerMode.date,
              initialValue:
              isEditing ? updateEjercicio.fecha : ejercicio.fecha,
              onSaved: (newValue) {
                int mes = newValue.month;
                int dia = newValue.day;
                int year = newValue.year;
                DateTime fecha = DateTime.utc(year,mes,dia);
                ejercicio.fecha = fecha;},
              decoration: InputDecoration(hintText: 'Fecha'),
            ),
          ),

          /*
          ListTile(
            leading: Icon(Icons.palette),
            title: ColorPicker(
              onChanged: (color) {
                ejercicio.color = color;
                FocusScope.of(context).unfocus();
              },
              initialValue: isEditing ? updateEjercicio.color : ejercicio.color,
              key: UniqueKey(),
            ),
          )*/
        ],
      ),
    );
  }

  String validateTitle(String value) {
    if (value == '') return 'es obligatorio';
    if (value.length < 4) {
      return 'debe tener mas de 4 caracteres';
    }
  }

  void guardar(context) {
    if (globalFormKey.currentState.validate()) {
      globalFormKey.currentState.save();
      if (isEditing) {
        updateEjercicio.copyFrom(ejercicio);

        ScopedModel.of<EjerciciosViewModel>(context, rebuildOnChange: true)
            .updateEjercicio(updateEjercicio);
      } else {
        ScopedModel.of<EjerciciosViewModel>(context, rebuildOnChange: true)
            .addEjercicio(ejercicio);
      }
      ejercicio = Ejercicio();
      Navigator.pop(context);
    }
  }

  void cancelar(context) {
    Navigator.pop(context);
  }
}
