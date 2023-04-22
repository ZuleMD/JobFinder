import 'package:flutter/material.dart';
import 'package:mpdam_job_finder/models/job.dart';
import 'package:mpdam_job_finder/screens/Student/home/widgets/job_items.dart';

class SearchList extends StatefulWidget {
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  late List<Job> _jobList = [];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    final jobs = await Job.generateJobs();
    setState(() {
      _jobList = jobs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _jobList == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            margin: EdgeInsets.only(top: 25),
            child: ListView.separated(
                padding: EdgeInsets.only(
                  left: 25,
                  right: 25,
                  bottom: 25,
                ),
                itemBuilder: (context, index) => JobItem(
                      _jobList[index],
                      showTime: true,
                    ),
                separatorBuilder: (_, index) => SizedBox(
                      height: 20,
                    ),
                itemCount: _jobList.length));
  }
}
