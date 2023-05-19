import 'package:flutter/material.dart';
import 'package:mpdam_job_finder/screens/Student/home/widgets/icon_text.dart';

import 'package:mpdam_job_finder/models/job.dart';
import 'package:file_picker/file_picker.dart';

import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class JobDetail extends StatefulWidget {
  final Job job;
  JobDetail(this.job);
  @override
  _JobDetailState createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  PlatformFile? _file;
  final _oKey = GlobalKey<FormState>();
  TextEditingController _resumeController = TextEditingController();
  bool _resumeUpdated = false;

  void updateResume() async {
    final accessToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InN0dWRlbnRAZ21haWwuY29tIiwiaWF0IjoxNjg0NTE1Mjc0LCJleHAiOjE2ODQ1MTg4NzQsInN1YiI6IjkifQ.jGnf1ixX3vBQeQbPeNKqO_HtPgzcmUzeJYaRHxuMtr8';
    final decodedToken = JwtDecoder.decode(accessToken);
    final Studentid = decodedToken['sub'];

    // Read the existing user data from the JSON server
    var response =
        await http.get(Uri.parse('http://localhost:3000/users/$Studentid'));

    // Parse the response body
    var userData = jsonDecode(response.body);

    // Get the file data as bytes
    var fileData = await _file!.bytes;

    var jobApplicationData = {
      'user': userData,
      'resume': base64Encode(fileData!),
      'companyName': widget.job.companyName,
      'job': widget.job.name
    };

    // Convert the updated user data back to JSON
    var jobApplicationJson = jsonEncode(jobApplicationData);

    // Send a PUT request to update the user data on the JSON server
    await http.post(
      Uri.parse('http://localhost:3000/jobapplications'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jobApplicationJson,
    );

    setState(() {
      _resumeUpdated = true;
    });
  }

  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload your resume'),
          content: SingleChildScrollView(
            child: Form(
              key: _oKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );
                            if (result != null) {
                              setState(() {
                                _file = result.files.first;
                                _resumeController.text = _file!.name;
                              });
                            }
                          },
                          child: Text('Select a PDF file'),
                        ),
                        SizedBox(height: 16),
                        if (_file != null)
                          Text('Selected file: ${_file!.name}'),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF7165D6),
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.file_upload, // Use location icon
                              color: Color(0xFF7165D6),
                            ),
                          ),
                          readOnly: true,
                          controller: _resumeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please upload your resume!';
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _resumeController.clear();
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                if (_oKey.currentState?.validate() ?? false) {
                  updateResume();
                  _resumeController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      height: 550,
      child: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: 5,
            width: 60,
            color: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(children: [
                    Icon(
                      Icons.bookmark_outline_outlined,
                      color: Colors.black,
                    ),
                    Icon(Icons.more_horiz_outlined),
                  ]),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.job.name,
                style: TextStyle(
                  fontSize: 26,
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
                      Icons.location_on_outlined, widget.job.companyAddress),
                  IconText(Icons.access_time_outlined, widget.job.type)
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Requirement',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ...widget.job.requirements
                  .map((e) => Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                height: 5,
                                width: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 300,
                                ),
                                child: Text(
                                  e,
                                  style: TextStyle(
                                    wordSpacing: 2.5,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ]),
                      ))
                  .toList(),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 45,
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Color(0xFF4DB6AC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  onPressed: () {
                    _showFormDialog(context);
                  },
                  child: Text('Apply Now'),
                ),
              ),
              _resumeUpdated
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Resume uploaded successfully!',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          )
        ],
      )),
    );
  }
}
