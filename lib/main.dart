import 'package:agno_project/backup_excel.dart';
import 'package:agno_project/example.dart';
import 'package:agno_project/filee.dart';
import 'package:agno_project/firebase_options.dart';
import 'package:agno_project/home.dart';
import 'package:agno_project/new_file.dart';
import 'package:agno_project/practice.dart';
import 'package:agno_project/reports.dart';
import 'package:agno_project/shorter_file.dart';
import 'package:agno_project/show_dialogg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    // SyncfusionLicense.registerLicense('YOUR_LICENSE_KEY');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
       home: Reports(),
    );
  }
}
