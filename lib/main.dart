import 'package:flutter/material.dart';
import 'screens/Admin/CompaniesScreen.dart';
import 'package:mpdam_job_finder/models/Company.dart';

import 'screens/Company/JobOffersScreen.dart';
import 'package:mpdam_job_finder/models/JobOffer.dart';

import 'screens/Employee/ProfileScreen.dart';
import 'package:mpdam_job_finder/models/Employee.dart';

void main() {
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
          // Add more routes here as necessary
        });
  }
}
