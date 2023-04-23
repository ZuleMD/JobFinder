import 'package:flutter/material.dart';
import 'package:mpdam_job_finder/models/Company.dart';
import 'package:mpdam_job_finder/screens/Admin/detail_screen.dart';

class HomeAdmin extends StatefulWidget {
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  final _oKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _imageController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();

  late Future<List<Company>> _companyList;

  @override
  void initState() {
    super.initState();
    _companyList = Company.generateCompanies();
  }

  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add company'),
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
                            "Email",
                            style: TextStyle(
                              color: Color(0xFF7165D6),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.email, // Use location icon
                            color: Color(0xFF7165D6),
                          ),
                        ),
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter company email';
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
                            "Password",
                            style: TextStyle(
                              color: Color(0xFF7165D6),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.password, // Use location icon
                            color: Color(0xFF7165D6),
                          ),
                        ),
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter company password';
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
                  Future<Company> newCompany = Company.addCompany(
                      name: _nameController.text,
                      address: _addressController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      image: _imageController.text,
                      description: _descriptionController.text);

                  newCompany.then((company) {
                    setState(() {
                      _companyList.then((value) => value.add(company));
                    });
                  }).catchError((error) {
                    // Handle any errors that occur during the asynchronous operation
                  });

                  _nameController.clear();
                  _addressController.clear();
                  _emailController.clear();
                  _passwordController.clear();
                  _imageController.clear();
                  _descriptionController.clear();

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
                  "Hello Admin",
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
                        "Add New Company",
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
          FutureBuilder<List<Company>>(
            future: _companyList,
            builder:
                (BuildContext context, AsyncSnapshot<List<Company>> snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final company = snapshot.data![index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(company),
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
                                  backgroundImage: NetworkImage(company.image),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  company.name,
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
                                Icon(Icons.location_on,
                                    color: Color(0xFFFED408)),
                                SizedBox(width: 5),
                                Text(
                                  company.address,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
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
