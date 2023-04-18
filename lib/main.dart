import 'package:flutter/material.dart';
import 'screens/Admin/CompaniesScreen.dart';
import 'package:mpdam_job_finder/models/Company.dart';

import 'screens/Company/JobOffersScreen.dart';
import 'package:mpdam_job_finder/models/JobOffer.dart';

import 'screens/Student/ProfileScreen.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void configureApp() {
  setUrlStrategy(PathUrlStrategy());
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gestion des fichiers des entreprises partenaires',
        initialRoute: '/companies',
        routes: {
          '/companies': (context) => CompaniesScreen(),
          '/joboffers': (context) => JobOffersScreen(),
          '/profile': (context) => ProfileScreen()
        });
  }
}
