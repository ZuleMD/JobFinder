import 'package:flutter/material.dart';
import 'package:mpdam_job_finder/models/job.dart';
import 'package:mpdam_job_finder/models/Company.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//student
import 'screens/Student/Profile/ProfileScreen.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget initialScreen = HomePage();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    final accessToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Im9yYW5nZUBnbWFpbC5jb20iLCJpYXQiOjE2ODQ1MTU0MDksImV4cCI6MTY4NDUxOTAwOSwic3ViIjoiNyJ9.hYUsZbie7hxxVLqVHWYu3vKMUGLOCa1HTGuJvd_yZ8o'; // replace with actual token from login API

    var decodedToken = JwtDecoder.decode(accessToken);
    var id = decodedToken['sub'];

    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/users/$id'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        String role = jsonData['role'];

        switch (role) {
          case 'admin':
            setState(() {
              initialScreen = WelcomeScreenAdmin();
            });
            break;
          case 'company':
            setState(() {
              initialScreen = WelcomeScreen();
            });
            break;
          case 'student':
            setState(() {
              initialScreen = HomePage();
            });
            break;
          default:
            print('Invalid role: $role');
        }
      } else {
        print('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Job Finder App',
      theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 238, 142, 247),
          accentColor: const Color(0xFFFED408)),
      initialRoute: '/',
      routes: {
        '/': (context) => initialScreen,
      },
    );
  }
}
