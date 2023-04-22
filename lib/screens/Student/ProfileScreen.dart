import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _imageController = TextEditingController();

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
    });
  }

  Future<void> saveChanges(String fullName, String address, String phone,
      String image, int id) async {
    try {
      await http.put(
        Uri.parse('http://localhost:3000/users/$id'),
        body: json.encode({
          'fullName': fullName,
          'address': address,
          'phone': phone,
          'image': image,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // TODO: Implement image upload functionality
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  _imageController.text,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: "Address",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: "Phone",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _imageController,
                    decoration: InputDecoration(
                      labelText: "Image URL",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Save Changes"),
              onPressed: () {
                saveChanges(
                    _fullNameController.text,
                    _addressController.text,
                    _phoneController.text,
                    _imageController.text,
                    4 // assuming the id of the student is always 4
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}