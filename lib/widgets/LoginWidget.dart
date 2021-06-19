// @dart=2.7
import 'package:asesorias/models/UserCredentials.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
class LoginWidget extends StatefulWidget {
  Function(String) onChangeField;
  UserCredentials userCredentials;

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool _showPassword = false;
  String _emailValidator(String email) {
    final emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    final String admin = 'admin@admin.com';
    if (!emailValid) {
      return 'El email no es valido';
    }
  }


  String _passwordValidator(String password) {
    if (password.length < 3) {
      return 'La constraseña no es valida';
    }
  }

  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        leading: Icon(Icons.email),
        title: TextFormField(
          initialValue: 'francist@gmail.com',
          onChanged: widget.onChangeField,
          keyboardType: TextInputType.text,
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
