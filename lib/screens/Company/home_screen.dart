import 'package:flutter/material.dart';
import 'package:mpdam_job_finder/screens/Company/widgets/taglist.dart';
import 'package:mpdam_job_finder/screens/Company/detail_screen.dart';
import 'package:mpdam_job_finder/models/job.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _oKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  ValueNotifier<String?> Category = ValueNotifier<String?>(null);

  final _requirementsController = TextEditingController();
  final _closingdateController = TextEditingController();

  List<String> types = [
    "Select Type",
    "Full-time",
    "contract",
    "Part-time",
    "Internship"
  ];

  late String selectedCategory =
      types[0]; // To keep track of the selected category
  DateTime selectedDate = DateTime.now();

  List categories = [
    "UI/UX",
    "MERN Stack",
    "IOT",
    "AI",
  ];

  late Future<List<Job>> _jobList;

  @override
  void initState() {
    super.initState();
    _jobList = Job.generateJobsForAuthCompany(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Im9yYW5nZUBnbWFpbC5jb20iLCJpYXQiOjE2ODQ1MTU0MDksImV4cCI6MTY4NDUxOTAwOSwic3ViIjoiNyJ9.hYUsZbie7hxxVLqVHWYu3vKMUGLOCa1HTGuJvd_yZ8o');
  }

  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Job Offer'),
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
                              color: Color(0xFF7165D6),
                            ),
                          ),
                          label: Text(
                            "Title",
                            style: TextStyle(
                              color: Color(0xFF7165D6),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.title, // Use location icon
                            color: Color(0xFF7165D6),
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
                                  color: Color(0xFF7165D6),
                                ),
                              ),
                              label: Text(
                                "Type",
                                style: TextStyle(
                                  color: Color(0xFF7165D6),
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.type_specimen_outlined,
                                color: Color(0xFF7165D6),
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
                              color: Color(0xFF7165D6),
                            ),
                          ),
                          label: Text(
                            "Requirement",
                            style: TextStyle(
                              color: Color(0xFF7165D6),
                            ),
                          ),

                          // Use labelText instead of label
                          prefixIcon: Icon(
                            Icons.description, // Use description icon
                            color: Color(0xFF7165D6),
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
                            color: Color(0xFF7165D6),
                          ),
                        ),
                        label: Text(
                          "Closing Date",
                          style: TextStyle(
                            color: Color(0xFF7165D6),
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.calendar_today_outlined,
                          color: Color(0xFF7165D6),
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
                                primaryColor: Color(0xFF7165D6),
                                hintColor: Color(0xFF7165D6),
                                colorScheme: ColorScheme.light(
                                  primary: Color(0xFF7165D6),
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
                  Future<Job> newJobOffer = Job.addJobOffer(
                      name: _nameController.text,
                      type: Category.value.toString(),
                      requirements: _requirementsController.text
                          .split('\n')
                          .map((line) => line.trim())
                          .toList(),
                      closingdate: _closingdateController.text);

                  newJobOffer.then((jobOffer) {
                    setState(() {
                      _jobList.then((value) => value.add(jobOffer));
                    });
                  }).catchError((error) {
                    // Handle any errors that occur during the asynchronous operation
                  });

                  _nameController.clear();
                  Category.value = null;
                  _requirementsController.clear();
                  _closingdateController.clear();

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
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hello Jane Doe",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage("assets/images/avatar.png"),
                )
              ],
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  _showFormDialog(context);
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 238, 142, 247),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        spreadRadius: 4,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Color.fromARGB(255, 238, 142, 247),
                          size: 35,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Add New Offre",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        spreadRadius: 4,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 208, 200, 243),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.home_filled,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Home Visit",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "Categories",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          TagList(),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "All List",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          FutureBuilder<List<Job>>(
            future: _jobList,
            builder: (BuildContext context, AsyncSnapshot<List<Job>> snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final job = snapshot.data![index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(job),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      NetworkImage(job.companyImage),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  job.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock_clock, color: Colors.red),
                                SizedBox(width: 5),
                                Text(
                                  "Closing date:",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),

                            // add some spacing between the icon and the text
                            Text(
                              job.closingdate,
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
