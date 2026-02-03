import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'core/config/firebase_options_loader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final options = await FirebaseOptionsLoader.load();
  await Firebase.initializeApp(options: options);
  runApp(const ELibraryPrintingApp());
}
