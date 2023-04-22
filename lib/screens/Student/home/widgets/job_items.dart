import 'package:flutter/material.dart';
import 'package:mpdam_job_finder/screens/Student/home/widgets/icon_text.dart';

import 'package:mpdam_job_finder/models/job.dart';

class JobItem extends StatefulWidget {
  final Job job;
  final bool showTime;

  JobItem(this.job, {this.showTime = false});

  @override
  _JobItemState createState() => _JobItemState();
}

class _JobItemState extends State<JobItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: Image.network(widget.job.companyImage),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.job.companyName,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.bookmark_outline_outlined,
              color: Colors.black,
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          widget.job.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconText(
                Icons.lock_clock, "Closing date: " + widget.job.closingdate),
            if (widget.showTime)
              IconText(Icons.access_time_outlined, widget.job.type)
          ],
        )
      ]),
    );
  }
}
