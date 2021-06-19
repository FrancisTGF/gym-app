// @dart=2.7
import 'package:flutter/material.dart';

class EjercicioBackground extends StatelessWidget {
  String image;

  EjercicioBackground(
      {this.image = 'assets/image/pizarraEntrenos.jpg'});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.fill)),
    );
  }
}
