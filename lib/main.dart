import 'package:flutter/material.dart';
import 'screens/Admin/CompaniesScreen.dart';
import 'package:mpdam_job_finder/models/Company.dart';

import 'screens/Student/ProfileScreen.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:mpdam_job_finder/screens/Student/home/home.dart';
import 'package:flutter/services.dart';

import 'package:mpdam_job_finder/screens/Company/welcome_screen.dart';

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
    (SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent)));

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Job Finder App',
        theme: ThemeData(
            primaryColor: Color.fromARGB(255, 238, 142, 247),
            accentColor: Color(0xFFFED408)),
        initialRoute: '/companies',
        routes: {
          '/companies': (context) => CompaniesScreen(),
          '/joboffers': (context) => WelcomeScreen(),
          //'/joboffers': (context) => JobOffersScreen(),
          '/homestudent': (context) => HomePage(),
          '/profilestudent': (context) => ProfileScreen(),
        });
  }
}
