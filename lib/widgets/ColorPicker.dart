// @dart=2.7
import 'package:asesorias/models/Ejercicio.dart';
import 'package:flutter/cupertino.dart';

class ColorPicker extends StatefulWidget {
  void Function(NoteColor) onChanged;
  NoteColor initialValue;

  ColorPicker({key: Key, this.onChanged, initialValue: NoteColor})
      : super(key: key) {
    this.initialValue = initialValue;
  }

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  NoteColor selectedColor;

  @override
  Widget build(BuildContext context) {
    if (selectedColor == null) {
      selectedColor = widget.initialValue;
    }
    return buildRowColor();
  }

  Row buildRowColor() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: NoteColor.values.map((NoteColor enumClor) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedColor = enumClor;
            });
            widget.onChanged(selectedColor);
          },
          child: Container(
            width: enumClor == selectedColor ? 45 : 35,
            height: enumClor == selectedColor ? 45 : 35,
            decoration: BoxDecoration(
              /*color: Ejercicio.getMaterialEnumColor(enumClor),*/
            ),
          ),
        );
      }).toList(),
    );
  }
}
