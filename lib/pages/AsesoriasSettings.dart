// @dart=2.7

import 'package:asesorias/models/Preferences.dart';
import 'package:asesorias/models/PreferencesViewModels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AsesoriasSettings extends StatefulWidget {
  @override
  _AsesoriasSettingsState createState() => _AsesoriasSettingsState();
}

class _AsesoriasSettingsState extends State<AsesoriasSettings> {
  String background;
  final preferences = Preferences();

  @override
  void initState() {
    super.initState();
    background = preferences.ejercicosBackground;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferencias'),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Selecciona un fondo')),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: RadioListTile(
                title: Container(
                  width: 50,
                  height: 70,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(
                        'assets/image/pizarraEntrenos.jpg'),
                    fit: BoxFit.fitHeight,
                  )),
                ),
                value: 'assets/image/pizarraEntrenos.jpg',
                groupValue: background,
                onChanged: onChanged),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: RadioListTile(
                title: Container(
                  width: 50,
                  height: 70,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image:
                        AssetImage('assets/image/pizarra_negra.jpg'),
                    fit: BoxFit.fitHeight,
                  )),
                ),
                value: 'assets/image/pizarra_negra.jpg',
                groupValue: background,
                onChanged: onChanged),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ScopedModelDescendant<PreferencesViewModels>(

              builder: (context, child, model) => FlatButton(
                  onPressed: () {
                    model.background = background;

                    Navigator.pop(context);
                  },
                  child: Text('Guardar')),
            ),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancelar')),
          ],
        ),
      ),
    );
  }

  onChanged(String value) {
    background = value;
    setState(() {});
  }
}
