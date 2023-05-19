import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mpdam_job_finder/screens/Company/home_screen.dart';
import 'package:mpdam_job_finder/models/job.dart';

import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:flutter/services.dart';
import 'dart:io' as io;

class DetailScreen extends StatefulWidget {
  Job job;

  DetailScreen(this.job);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _oKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  ValueNotifier<String?> Category = ValueNotifier<String?>(null);

  final _requirementsController = TextEditingController();
  final _closingdateController = TextEditingController();
  int _selectedID = -1;

  List<String> types = [
    "Select Type",
    "Full-time",
    "contract",
    "Part-time",
    "Internship"
  ].toSet().toList();

  DateTime selectedDate = DateTime.now();

  List categories = [
    "UI/UX",
    "MERN Stack",
    "IOT",
    "AI",
  ];

  late Future<List<dynamic>> _jobAppList;
  @override
  void initState() {
    super.initState();
    _jobAppList = Job.generateJobApplicationsForAuthCompany(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Im9yYW5nZUBnbWFpbC5jb20iLCJpYXQiOjE2ODQ1MTU0MDksImV4cCI6MTY4NDUxOTAwOSwic3ViIjoiNyJ9.hYUsZbie7hxxVLqVHWYu3vKMUGLOCa1HTGuJvd_yZ8o',
        widget.job.name);
  }

  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('update Job Offer'),
          content: SingleChildScrollView(
            child: Form(
              key: _oKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 238, 142, 247),
                            ),
                          ),
                          label: Text(
                            "Title",
                            style: TextStyle(
                              color: Color.fromARGB(255, 238, 142, 247),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.title, // Use location icon
                            color: Color.fromARGB(255, 238, 142, 247),
                          ),
                        ),
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter job title';
                          }
                        }),
                  ),
                  ValueListenableBuilder(
                    valueListenable: Category,
                    builder:
                        (BuildContext context, String? value, Widget? child) {
                      return Padding(
                        padding: EdgeInsets.all(12),
                        child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 238, 142, 247),
                                ),
                              ),
                              label: Text(
                                "Type",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 238, 142, 247),
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.type_specimen_outlined,
                                color: Color.fromARGB(255, 238, 142, 247),
                              ),
                            ),
                            value: value,
                            items: types.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              Category.value = newValue;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter job type';
                              }
                            }),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: TextFormField(
                        maxLines:
                            3, // Set the maximum number of lines for description
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 238, 142, 247),
                            ),
                          ),
                          label: Text(
                            "Requirement",
                            style: TextStyle(
                              color: Color.fromARGB(255, 238, 142, 247),
                            ),
                          ),

                          // Use labelText instead of label
                          prefixIcon: Icon(
                            Icons.description, // Use description icon
                            color: Color.fromARGB(255, 238, 142, 247),
                          ),
                        ),
                        controller: _requirementsController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter requirements';
                          }
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 238, 142, 247),
                          ),
                        ),
                        label: Text(
                          "Closing Date",
                          style: TextStyle(
                            color: Color.fromARGB(255, 238, 142, 247),
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.calendar_today_outlined,
                          color: Color.fromARGB(255, 238, 142, 247),
                        ),
                      ),
                      readOnly: true,
                      controller: _closingdateController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter closing date';
                        }
                        DateTime selectedDate = DateTime.parse(value);
                        if (selectedDate.isBefore(DateTime.now())) {
                          return 'Closing date cannot be in the past';
                        }
                        return null;
                      },
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          helpText: 'Select a date',
                          cancelText: 'Cancel',
                          confirmText: 'OK',
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor:
                                    Color.fromARGB(255, 238, 142, 247),
                                hintColor: Color.fromARGB(255, 238, 142, 247),
                                colorScheme: ColorScheme.light(
                                  primary: Color.fromARGB(255, 238, 142, 247),
                                ),
                                buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary,
                                ),
                              ),
                              child: child ?? const SizedBox.shrink(),
                            );
                          },
                        );
                        if (pickedDate != null) {
                          selectedDate = pickedDate;
                          _closingdateController.text =
                              "${selectedDate.toLocal()}".split(' ')[0];
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _nameController.clear();
                Category.value = null;
                _requirementsController.clear();
                _closingdateController.clear();
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                if (_oKey.currentState?.validate() ?? false) {
                  Future<Job> newJobOffer = Job.updateJobOffer(
                      name: _nameController.text,
                      type: Category.value.toString(),
                      requirements: _requirementsController.text
                          .split('\n')
                          .map((line) => line.trim())
                          .toList(),
                      closingdate: _closingdateController.text,
                      id: _selectedID);

                  setState(() {});
                  Navigator.of(context).pop();

                  _nameController.clear();
                  Category.value = null;
                  _requirementsController.clear();
                  _closingdateController.clear();
                }
              },
              child: Text('UPDATE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 238, 142, 247),
        body: FutureBuilder<List<dynamic>>(
            future: _jobAppList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<dynamic> jobApplications = snapshot.data ?? [];

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 22),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(widget.job.companyImage),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    widget.job.companyName +
                                        ' - ' +
                                        widget.job.name,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 5),
                                      Text(
                                        widget.job.type,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.lock_clock),
                                      SizedBox(width: 5),
                                      Text(
                                        "Closing date: " +
                                            widget.job.closingdate,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          _selectedID = widget.job.id;
                                          _nameController.text =
                                              widget.job.name;
                                          Category.value = widget.job.type;
                                          _requirementsController.text = widget
                                              .job.requirements
                                              .join(', ');
                                          _closingdateController.text =
                                              widget.job.closingdate;
                                          _showFormDialog(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF4DB6AC),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      TextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Delete Job Offer'),
                                                content: Text(
                                                    'Are you sure you want to delete this job offer?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Delete'),
                                                    onPressed: () {
                                                      // Call your delete method here
                                                      Job.deleteJobOffer(
                                                          widget.job.id);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Material(
                                                            child: HomeScreen(),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF4DB6AC),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            CupertinoIcons.delete,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: MediaQuery.of(context).size.height / 1.5,
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          top: 20,
                          left: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Offer Requirements",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  widget.job.requirements.map((requirement) {
                                return Text(
                                  '-' + requirement,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  "Students Applied",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "(" + jobApplications.length.toString() + ")",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 238, 142, 247),
                                  ),
                                ),
                                //spacer align next widget to the end of row
                                Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "See All",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 238, 142, 247),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 160,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: jobApplications.length,
                                itemBuilder: (context, index) {
                                  final jobApplication = jobApplications[index];
                                  return Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.4,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: CircleAvatar(
                                              radius: 25,
                                              backgroundImage: NetworkImage(
                                                  jobApplication['user']
                                                      ['image']),
                                            ),
                                            title: Text(
                                              jobApplication['user']
                                                  ['fullName'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            subtitle: Text('Iset ' +
                                                jobApplication['user']
                                                    ['isetName']),
                                          ),
                                          SizedBox(height: 5),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              jobApplication['user']
                                                  ['description'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: InkWell(
                                              onTap: () async {},
                                              child: Text(
                                                'View Resume',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Location",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            ListTile(
                              leading: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF0EEFA),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.location_on,
                                  color: Color(0xFFFED408),
                                  size: 30,
                                ),
                              ),
                              title: Text(
                                widget.job.companyAddress,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }));
  }
}
