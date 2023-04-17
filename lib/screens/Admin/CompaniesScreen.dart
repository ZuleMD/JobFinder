import 'package:flutter/material.dart';
import 'package:mpdam_job_finder/models/Company.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CompanyScreen extends StatefulWidget {
  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<Company> _companies = [];

  bool _isEditing = false;
  int _selectedIndex = -1;

  // ******************Services******************

  Future<void> fetchCompanies() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/companies'));
    final extractedData = json.decode(response.body) as List<dynamic>;
    final List<Company> loadedCompanies = [];
    extractedData.forEach((companiesData) {
      loadedCompanies.add(Company(
        id: companiesData['id'],
        name: companiesData['name'],
        address: companiesData['address'],
        email: companiesData['email'],
        password: companiesData['password'],
        image: companiesData['image'],
        description: companiesData['description'],
      ));
    });

    setState(() {
      _companies = loadedCompanies;
    });
  }

  Future<void> addCompany(String name, String address, String email,
      String password, String image, String description) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/companies'),
      body: json.encode({
        'name': name,
        'address': address,
        'email': email,
        'password': password,
        'image': image,
        'description': description
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final newCompany = Company(
        id: json.decode(response.body)['id'],
        name: name,
        address: address,
        email: email,
        password: password,
        image: image,
        description: description);

    setState(() {
      _companies.add(newCompany);
    });
  }

  Future<void> updateCompany(String name, String address, String email,
      String password, String image, String description, int id) async {
    final companyIndex = _companies.indexWhere((company) => company.id == id);

    if (companyIndex >= 0) {
      final response = await http.put(
        Uri.parse('http://localhost:3000/companies/$id'),
        body: json.encode({
          'name': name,
          'address': address,
          'email': email,
          'password': password,
          'image': image,
          'description': description
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final updatedCompany = Company(
          id: id,
          name: name,
          address: address,
          email: email,
          password: password,
          image: image,
          description: description);

      setState(() {
        _companies[companyIndex] = updatedCompany;
      });
    }
  }

  Future<void> deleteCompany(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
              'Are you sure you want to delete this partner company?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final response = await http
                    .delete(Uri.parse('http://localhost:3000/companies/$id'));
                setState(() {
                  _companies.removeWhere((company) => company.id == id);
                });
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }
  // ****************** End Services******************

  @override
  void initState() {
    super.initState();
    fetchCompanies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_isEditing ? 'Edit Company' : 'Add Company'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _imageController,
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an image URL';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _nameController.clear();
                _addressController.clear();
                _emailController.clear();
                _passwordController.clear();
                _imageController.clear();
                _descriptionController.clear();
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  if (_isEditing) {
                    updateCompany(
                        _nameController.text,
                        _addressController.text,
                        _emailController.text,
                        _passwordController.text,
                        _imageController.text,
                        _descriptionController.text,
                        _companies[_selectedIndex].id);
                  } else {
                    addCompany(
                        _nameController.text,
                        _addressController.text,
                        _emailController.text,
                        _passwordController.text,
                        _imageController.text,
                        _descriptionController.text);
                  }
                  _nameController.clear();
                  _addressController.clear();
                  _emailController.clear();
                  _passwordController.clear();
                  _imageController.clear();
                  _descriptionController.clear();

                  Navigator.pop(context);
                }
              },
              child: Text(_isEditing ? 'UPDATE' : 'SAVE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partner Companies Management'),
      ),
      body: _companies.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _companies.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(_companies[index].image),
                  ),
                  title: Text(_companies[index].name),
                  subtitle: Text(_companies[index].email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _isEditing = true;
                          _selectedIndex = index;
                          _nameController.text = _companies[index].name;
                          _addressController.text = _companies[index].address;
                          _emailController.text = _companies[index].email;
                          _passwordController.text = _companies[index].password;
                          _imageController.text = _companies[index].image;
                          _descriptionController.text =
                              _companies[index].description;
                          _showFormDialog(context);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteCompany(_companies[index].id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _isEditing = false;
          _selectedIndex = -1;
          _showFormDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
