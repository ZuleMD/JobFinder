import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mpdam_job_finder/screens/Student/Profile/widgets/profile_menu.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mpdam_job_finder/common/constant/image_strings.dart';
import 'package:mpdam_job_finder/common/text_string.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _oKey = GlobalKey<FormState>();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  TextEditingController _isetNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final response = await http.get(Uri.parse(
        'http://localhost:3000/users?id=4')); //we update here: when the authenticated user's id
    final jsonData = json.decode(response.body);

    final student = jsonData[0];

    setState(() {
      _fullNameController.text = student['fullName'];
      _addressController.text = student['address'];
      _phoneController.text = student['phone'];
      _imageController.text = student['image'];
      _descriptionController.text = student['description'];
      _isetNameController.text = student['isetName'];
      _emailController.text = student['email'];
      _passwordController.text = student['password'];
    });
  }

  Future<void> saveChanges(String fullName, String address, String phone,
      String image, String description, String isetName, int id) async {
    try {
      await http.put(
        Uri.parse('http://localhost:3000/users/$id'),
        body: json.encode({
          'fullName': fullName,
          'address': address,
          'phone': phone,
          'image': image,
          'description': description,
          'isetName': isetName,
          'password': _passwordController.text,
          'email': _emailController.text
        }),
        headers: {'Content-Type': 'application/json'},
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Changes saved successfully!"),
        ),
      );
    } catch (error) {
      print("Error saving changes: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save changes. Please try again."),
        ),
      );
    }
  }

  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Updte profile'),
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
                            "Full Name",
                            style: TextStyle(
                              color: Color(0xFF7165D6),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.title, // Use location icon
                            color: Color(0xFF7165D6),
                          ),
                        ),
                        controller: _fullNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
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
                            "Address",
                            style: TextStyle(
                              color: Color(0xFF7165D6),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.location_on, // Use location icon
                            color: Color(0xFF7165D6),
                          ),
                        ),
                        controller: _addressController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
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
                            "Phone",
                            style: TextStyle(
                              color: Color(0xFF7165D6),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.location_on, // Use location icon
                            color: Color(0xFF7165D6),
                          ),
                        ),
                        controller: _phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
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
                            "Iset",
                            style: TextStyle(
                              color: Color(0xFF7165D6),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.school, // Use location icon
                            color: Color(0xFF7165D6),
                          ),
                        ),
                        controller: _isetNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Iset name';
                          }
                        }),
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
                            "Description",
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
                        controller: _descriptionController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter descriptions';
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
                            "Image",
                            style: TextStyle(
                              color: Color(0xFF7165D6),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.image, // Use location icon
                            color: Color(0xFF7165D6),
                          ),
                        ),
                        controller: _imageController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your photo';
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _fullNameController.clear();
                _imageController.clear();
                _addressController.clear();
                _descriptionController.clear();
                _phoneController.clear();
                _isetNameController.clear();
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                if (_oKey.currentState?.validate() ?? false) {
                  saveChanges(
                      _fullNameController.text,
                      _addressController.text,
                      _phoneController.text,
                      _imageController.text,
                      _descriptionController.text,
                      _isetNameController.text,
                      4);

                  setState(() {});
                  Navigator.of(context).pop();

                  _fullNameController.clear();
                  _addressController.clear();
                  _phoneController.clear();
                  _imageController.clear();
                  _descriptionController.clear();
                  _isetNameController.clear();
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
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text(
          tProfile,
          style: Theme.of(context).textTheme.headline4!.copyWith(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 95),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: _imageController.text.isEmpty
                                ? Text('No image')
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      _imageController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _fullNameController.text,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        _emailController.text,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 170,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () => {_showFormDialog(context)},
                          child: Text(tEditProfile),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4DB6AC),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      //Menu
                      ProfileMenuWidget(
                        title: "Settings",
                        icon: LineAwesomeIcons.cog,
                        onPress: () {},
                      ),
                      ProfileMenuWidget(
                        title: "Applications list",
                        icon: LineAwesomeIcons.list,
                        onPress: () {},
                      ),

                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),

                      ProfileMenuWidget(
                        title: "Information",
                        icon: LineAwesomeIcons.info,
                        onPress: () {},
                      ),
                      ProfileMenuWidget(
                        title: "Logout",
                        icon: LineAwesomeIcons.alternate_sign_out,
                        textColor: Colors.red,
                        endIcon: false,
                        onPress: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
