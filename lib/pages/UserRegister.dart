// @dart=2.7

import 'package:asesorias/app/AsesoriasApp.dart';
import 'package:asesorias/models/EjerciciosViewModel.dart';
import 'package:asesorias/models/User.dart';
import 'package:asesorias/responses/RegisterResponse.dart';
import 'package:asesorias/widgets/EjercicioDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'UserLogin.dart';

class UserRegister extends StatefulWidget {
  UserRegister({Key key}) : super(key: key);

  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEditingRegister = false;
  bool _error = false;
  Usuario _user = Usuario();
  Usuario _updateUser = Usuario();
  RegisterResponse registerResponse =
      RegisterResponse.unknowError('unknowError');

  _register() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (isEditingRegister) {
        _updateUser.copyFrom(_user);

        ScopedModel.of<EjerciciosViewModel>(context, rebuildOnChange: true)
            .updateUser(_updateUser);
      } else {
         await ScopedModel.of<EjerciciosViewModel>(context,
                rebuildOnChange: true)
            .register(_user);

        if (registerResponse.status == RegisterResponseStatus.Success) {
          Navigator.pushNamedAndRemoveUntil(
              context, AsesoriasApp.routeList, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context, AsesoriasApp.routeList, (route) => false);
          setState(() {

            _error = true;
          });
        }
      }
    }
  }

  _onChangeField(String value) {
    setState(() {
      _error = false;
    });
  }

  String _nameNotEmpty(String name) {
    if (name == null || name.length == 0) {
      return 'Nombre  obligatorio';
    }
  }

  String _datosNotEmptyAndNumber(String name) {
    final letras = RegExp(r"^[^0-9]+");
    if (name == null || name.length == 0 || name.contains(letras)) {
      return 'Campo  obligatorio, debe ser un numero';
    }
  }

  @override
  Widget build(BuildContext context) {
    var arguments;
    arguments = ModalRoute.of(context).settings.arguments;
    String textButton = 'Registrar usuario';
    if (arguments != null) {
      _updateUser = arguments as Usuario;
      _user.id = _updateUser.id;
      _user.email = _updateUser.email;
      _user.password = _updateUser.password;

      isEditingRegister = true;
      textButton = 'Actualizar usuario';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar usuario'),
      ),
      drawer: EjercicioDrawer(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Icon(Icons.person_add, size: 120),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(90)),
                ),
              ),
              if (!isEditingRegister)
                LoginWidget(
                  onChangeField: _onChangeField,
                  userCredentials: _user,
                ),
              ListTile(
                leading: Icon(Icons.person_outline),
                title: TextFormField(
                    initialValue: isEditingRegister
                        ? _updateUser.firstname
                        : _user.firstname,
                    validator: _nameNotEmpty,
                    onChanged: _onChangeField,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Nombre'),
                    onSaved: (newValue) => _user.firstname = newValue),
                subtitle: Text('Nombre'),
              ),
              ListTile(
                leading: Icon(Icons.account_balance_outlined),
                title: TextFormField(
                    initialValue:
                        isEditingRegister ? _updateUser.peso : _user.peso,
                    validator: _datosNotEmptyAndNumber,
                    onChanged: _onChangeField,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Peso'),
                    onSaved: (newValue) => _user.peso = newValue),
                subtitle: Text('Peso'),
              ),
              ListTile(
                leading: Icon(Icons.height),
                title: TextFormField(
                    initialValue:
                        isEditingRegister ? _updateUser.altura : _user.altura,
                    validator: _datosNotEmptyAndNumber,
                    onChanged: _onChangeField,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Altura'),
                    onSaved: (newValue) => _user.altura = newValue),
                subtitle: Text('Altura'),
              ),
              ListTile(
                leading: Icon(Icons.timeline),
                title: TextFormField(
                    initialValue:
                        isEditingRegister ? _updateUser.edad : _user.edad,
                    validator: _datosNotEmptyAndNumber,
                    onChanged: _onChangeField,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Edad'),
                    onSaved: (newValue) => _user.edad = newValue),
                subtitle: Text('Edad'),
              ),
              ListTile(
                leading: Icon(Icons.arrow_circle_down),
                title: TextFormField(
                    initialValue: isEditingRegister
                        ? _updateUser.annosEntrenando
                        : _user.annosEntrenando,
                    validator: _datosNotEmptyAndNumber,
                    onChanged: _onChangeField,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Años Entrenando'),
                    onSaved: (newValue) => _user.annosEntrenando = newValue),
                subtitle: Text('Años Entrenando'),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: TextFormField(
                    initialValue:
                        isEditingRegister ? _updateUser.rmSquat : _user.rmSquat,
                    validator: _datosNotEmptyAndNumber,
                    onChanged: _onChangeField,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'RM Sentadilla'),
                    onSaved: (newValue) => _user.rmSquat = newValue),
                subtitle: Text('RM Sentadilla'),
              ),
              ListTile(
                leading: Icon(Icons.arrow_forward),
                title: TextFormField(
                    initialValue:
                        isEditingRegister ? _updateUser.rmBench : _user.rmBench,
                    validator: _datosNotEmptyAndNumber,
                    onChanged: _onChangeField,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'RM Banca'),
                    onSaved: (newValue) => _user.rmBench = newValue),
                subtitle: Text('RM banca'),
              ),
              ListTile(
                leading: Icon(Icons.arrow_circle_up_rounded),
                title: TextFormField(
                    initialValue: isEditingRegister
                        ? _updateUser.rmDeadlift
                        : _user.rmDeadlift,
                    validator: _datosNotEmptyAndNumber,
                    onChanged: _onChangeField,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'RM Peso Muerto'),
                    onSaved: (newValue) => _user.rmDeadlift = newValue),
                subtitle: Text('Rm Peso Muerto'),
              ),
              if (_error)
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    registerResponse.errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    child: Text(textButton),
                    onPressed: _register,
                  ),
                  RaisedButton(
                      child: Text('Cancelar'),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
