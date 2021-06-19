// @dart=2.7

import 'package:asesorias/app/AsesoriasApp.dart';
import 'package:asesorias/models/EjerciciosViewModel.dart';
import 'package:asesorias/models/UserCredentials.dart';
import 'package:asesorias/widgets/EjercicioDrawer.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _error = false;
  UserCredentials credentials = UserCredentials();

  _login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
       await ScopedModel.of<EjerciciosViewModel>(context,
              rebuildOnChange: true)
          .login(credentials);
      if (true) {
        Navigator.of(context).pushReplacementNamed(AsesoriasApp.routeList);
      } else {
        setState(() {
          _error = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar sesion'),
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
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Container(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.person,
                          size: 100,
                        )),
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(70)),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: TextFormField(
                    initialValue: 'admin@admin.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onSaved: (newValue) {
                      credentials.email = newValue;
                    },
                    onChanged: _onChangeField,
                    decoration: InputDecoration(hintText: 'correo electonico'),
                    validator: _emailValidator,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.security),
                  title: TextFormField(
                    initialValue: 'admin',
                    obscureText: !_showPassword,
                    validator: _passwordValidator,
                    onSaved: (newValue) => credentials.password = newValue,
                    onChanged: _onChangeField,
                    decoration: InputDecoration(
                        hintText: 'contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(_showPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        )),
                  ),
                ),
                if (_error)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "usuario o contraseña incorrecta",
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton(
                      child: Text('Iniciar sesion'),
                      onPressed: _login,
                    ),
                    RaisedButton(
                      child: Text('Registrar'),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, AsesoriasApp.routeRegister);
                      },
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  String _passwordValidator(String password) {
    if (password.length < 3) {
      return 'la contraseña no es valida';
    }
  }

  String _emailValidator(String email) {
    final emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z09.!#$%&'*+./= ? ^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (!emailValid) {
      return 'el email insertado no es valiido';
    }
  }

  _onChangeField(String value) {
    setState(() {
      _error = false;
    });
  }
}

class LoginWidget extends StatefulWidget {
  Function(String) onChangeField;
  UserCredentials userCredentials;

  LoginWidget({this.onChangeField, this.userCredentials});

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool _showPassword = false;

  String _emailValidator(String email) {
    final emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (!emailValid) {
      return 'El email insertado no es valido';
    }
  }

  String _passwordValidator(String password) {
    if (password.length < 3) {
      return 'La constraseña no puede tener menos de 3 caracteres';
    }
  }

  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        leading: Icon(Icons.email),
        title: TextFormField(
          initialValue: 'francist@gmail.com',
          onChanged: widget.onChangeField,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(hintText: 'Correo electronico'),
          validator: _emailValidator,
          onSaved: (newValue) => widget.userCredentials.email = newValue,
        ),
      ),
      ListTile(
        leading: Icon(Icons.security),
        title: TextFormField(
          initialValue: 'admin',
          validator: _passwordValidator,
          obscureText: !_showPassword,
          onChanged: widget.onChangeField,
          onSaved: (newValue) => widget.userCredentials.password = newValue,
          decoration: InputDecoration(
              hintText: 'Contraseña',
              suffixIcon: IconButton(
                  icon: Icon(
                      _showPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  })),
        ),
      ),
    ]);
  }
}
