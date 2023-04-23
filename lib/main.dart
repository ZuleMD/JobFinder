import 'package:flutter/material.dart';
import 'package:mpdam_job_finder/models/job.dart';
import 'package:mpdam_job_finder/models/Company.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/services.dart';

//student
import 'screens/Student/ProfileScreen.dart';
import 'package:mpdam_job_finder/screens/Student/home/home.dart';

//admin
import 'package:mpdam_job_finder/screens/Admin/home_screen.dart';
import 'package:mpdam_job_finder/screens/Admin/welcome_screen.dart';
//company
import 'package:mpdam_job_finder/screens/Company/welcome_screen.dart';
import 'package:mpdam_job_finder/screens/Company/home_screen.dart';
import 'package:mpdam_job_finder/screens/Company/detail_screen.dart';

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
        initialRoute: '/admin',
        routes: {
          '/company': (context) => WelcomeScreen(),
          '/admin': (context) => WelcomeScreenAdmin(),
          '/student': (context) => HomePage(),
        });
  }
}
