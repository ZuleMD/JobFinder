import 'package:flutter/material.dart';
import 'package:mpdam_job_finder/screens/Student/home/widgets/home_app_bar.dart';
import 'package:mpdam_job_finder/screens/Student/home/widgets/job_list.dart';
import 'package:mpdam_job_finder/screens/Student/home/widgets/search_card.dart';
import 'package:mpdam_job_finder/screens/Student/home/widgets/tag_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeAppBar(),
                SearchCard(),
                TagList(),
                JobList(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
