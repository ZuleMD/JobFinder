import 'package:flutter/material.dart';
//import 'screens/Admin/CompaniesScreen.dart';
//import 'package:mpdam_job_finder/models/Company.dart';

//import 'screens/Company/JobOffersScreen.dart';
//import 'package:mpdam_job_finder/models/JobOffer.dart';

import 'screens/Employee/ProfileScreen.dart';
import 'package:mpdam_job_finder/models/Employee.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    // final partnerCompaniesService = PartnerCompanies_Service_API();
    return MaterialApp(
      title: 'Gestion des fichiers des entreprises partenaires',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: PartnerCompaniesListScreen(service: partnerCompaniesService),
      home: ProfileScreen(),
    );
  }
}
