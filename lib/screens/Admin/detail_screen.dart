import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mpdam_job_finder/models/Company.dart';
import 'package:mpdam_job_finder/screens/Admin/home_screen.dart';

class DetailScreen extends StatefulWidget {
  Company company;

  DetailScreen(this.company);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _oKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();

  late Future<List<Company>> _companyList;

  int _selectedID = -1;

  @override
  void initState() {
    super.initState();
  }

  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Updte company'),
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
                            "Name",
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
                            return 'Please enter company name';
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
                            return 'Please enter company name';
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
                            return 'Please enter company image';
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
                _nameController.clear();
                _imageController.clear();
                _addressController.clear();
                _descriptionController.clear();
                _emailController.clear();
                _passwordController.clear();
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                if (_oKey.currentState?.validate() ?? false) {
                  Future<Company> newCompany = Company.updateCompany(
                      name: _nameController.text,
                      address: _addressController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      image: _imageController.text,
                      description: _descriptionController.text,
                      id: _selectedID);

                  setState(() {});
                  Navigator.of(context).pop();

                  _nameController.clear();
                  _addressController.clear();

                  _imageController.clear();
                  _descriptionController.clear();
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
      body: SingleChildScrollView(
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(widget.company.image),
                        ),
                        SizedBox(height: 15),
                        Text(
                          widget.company.name,
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
                              widget.company.email,
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
                                _selectedID = widget.company.id;
                                _nameController.text = widget.company.name;
                                _addressController.text =
                                    widget.company.address;
                                _emailController.text = widget.company.email;
                                _passwordController.text =
                                    widget.company.password;
                                _imageController.text = widget.company.image;
                                _descriptionController.text =
                                    widget.company.description;

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
                                      title: Text('Delete company'),
                                      content: Text(
                                          'Are you sure you want to delete this company?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Delete'),
                                          onPressed: () {
                                            // Call your delete method here
                                            Company.deleteCompany(
                                                widget.company.id);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Material(
                                                    child: HomeAdmin()),
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
                    "Company Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.company.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
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
                        widget.company.address,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
