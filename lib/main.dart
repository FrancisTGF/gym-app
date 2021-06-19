// @dart=2.7
import 'package:asesorias/models/Preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/AsesoriasApp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app= await Firebase.initializeApp();
  FirebaseAuth.instanceFor(app: app);
  final preferences = Preferences();
  await preferences.initPreferences();
  runApp(AsesoriasApp());
}
