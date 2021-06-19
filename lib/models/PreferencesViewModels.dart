// @dart=2.7

import 'package:asesorias/models/Preferences.dart';
import 'package:scoped_model/scoped_model.dart';

class PreferencesViewModels extends Model {
  Preferences _preferences = Preferences();

  set background(String background) {
    _preferences.ejercicosBackground = background;
    notifyListeners();
  }

  get background {
    return _preferences.ejercicosBackground;
  }
}
