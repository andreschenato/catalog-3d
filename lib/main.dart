import 'package:catalog_3d/app.dart';
import 'package:catalog_3d/core/config/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await initFirebase();
  runApp(const App());
}
