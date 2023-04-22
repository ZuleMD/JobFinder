import 'package:flutter/material.dart';
import 'package:mpdam_job_finder/screens/Student/home/widgets/job_details.dart';
import 'package:mpdam_job_finder/screens/Student/home/widgets/job_items.dart';

import 'package:mpdam_job_finder/models/job.dart';

class JobList extends StatefulWidget {
  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  late Future<List<Job>> _jobList;

  @override
  void initState() {
    super.initState();
    _jobList = Job.generateJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(vertical: 25),
      height: 220,
      child: FutureBuilder<List<Job>>(
        future: _jobList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 25),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => JobDetail(snapshot.data![index]),
                    );
                  },
                  child: JobItem(snapshot.data![index]),
                ),
                separatorBuilder: (_, index) => SizedBox(width: 15),
                itemCount: snapshot.data!.length,
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
