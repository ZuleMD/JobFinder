import 'package:flutter/material.dart';
import 'package:mpdam_job_finder/screens/Student/search/widgets/search_app_bar.dart';
import 'package:mpdam_job_finder/screens/Student/search/widgets/search_input.dart';
import 'package:mpdam_job_finder/screens/Student/search/widgets/search_list.dart';
import 'package:mpdam_job_finder/screens/Student/search/widgets/search_option.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchAppBar(),
              SearchInput(),
              SearchOption(),
              Expanded(child: SearchList()),
            ],
          )
        ],
      ),
    );
  }
}
