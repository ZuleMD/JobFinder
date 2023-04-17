import 'package:flutter/material.dart';
import 'package:mpdam_job_finder/models/JobOffer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobOffersScreen extends StatefulWidget {
  @override
  _JobOffersScreenState createState() => _JobOffersScreenState();
}

class _JobOffersScreenState extends State<JobOffersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _companyImageController = TextEditingController();
  final _companyAddressController = TextEditingController();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _requirementsController = TextEditingController();
  List<JobOffer> _joboffers = [];

  bool _isEditing = false;
  int _selectedIndex = -1;

  // ******************Services******************

  Future<void> fetchJobOffers() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/joboffers'));
    final extractedData = json.decode(response.body) as List<dynamic>;
    final List<JobOffer> loadedJobOffers = [];
    extractedData.forEach((joboffersData) {
      loadedJobOffers.add(JobOffer(
        id: joboffersData['id'],
        companyName: joboffersData['companyName'],
        companyImage: joboffersData['companyImage'],
        companyAddress: joboffersData['companyAddress'],
        name: joboffersData['name'],
        type: joboffersData['type'],
        requirements: joboffersData['requirements'],
      ));
    });

    setState(() {
      _joboffers = loadedJobOffers;
    });
  }

  Future<void> addJobOffer(
      String companyName,
      String companyImage,
      String companyAddress,
      String name,
      String type,
      String requirements) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/joboffers'),
      body: json.encode({
        'companyName': companyName,
        'companyImage': companyImage,
        'companyAddress': companyAddress,
        'name': name,
        'type': type,
        'requirements': requirements
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final newJobOffer = JobOffer(
        id: json.decode(response.body)['id'],
        companyName: companyName,
        companyImage: companyImage,
        companyAddress: companyAddress,
        name: name,
        type: type,
        requirements: requirements);

    setState(() {
      _joboffers.add(newJobOffer);
    });
  }

  Future<void> updateJobOffer(
      String companyName,
      String companyImage,
      String companyAddress,
      String name,
      String type,
      String requirements,
      int id) async {
    final jobofferIndex =
        _joboffers.indexWhere((joboffer) => joboffer.id == id);

    if (jobofferIndex >= 0) {
      final response = await http.put(
        Uri.parse('http://localhost:3000/joboffers/$id'),
        body: json.encode({
          'companyName': companyName,
          'companyImage': companyImage,
          'companyAddress': companyAddress,
          'name': name,
          'type': type,
          'requirements': requirements
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final updatedJobOffer = JobOffer(
          id: id,
          companyName: companyName,
          companyImage: companyImage,
          companyAddress: companyAddress,
          name: name,
          type: type,
          requirements: requirements);

      setState(() {
        _joboffers[jobofferIndex] = updatedJobOffer;
      });
    }
  }

  Future<void> deleteJobOffer(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
              const Text('Are you sure you want to delete this job offer?'),
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
                    .delete(Uri.parse('http://localhost:3000/joboffers/$id'));
                setState(() {
                  _joboffers.removeWhere((joboffer) => joboffer.id == id);
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
    fetchJobOffers();
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyImageController.dispose();
    _companyAddressController.dispose();
    _nameController.dispose();
    _typeController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_isEditing ? 'Edit Job Offer' : 'Add Job Offer'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _companyNameController,
                    decoration: InputDecoration(
                      labelText: 'Company Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter company name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _companyImageController,
                    decoration: InputDecoration(
                      labelText: 'Company Image URL',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter company image URL';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _companyAddressController,
                    decoration: InputDecoration(
                      labelText: 'Company Address',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter company address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Job Offer Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter job offer name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _typeController,
                    decoration: InputDecoration(
                      labelText: 'Job Offer Type',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter job offer type';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _requirementsController,
                    decoration: InputDecoration(
                      labelText: 'Job Offer Requirements',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter job offer requirements';
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
                _companyNameController.clear();
                _companyImageController.clear();
                _companyAddressController.clear();
                _nameController.clear();
                _typeController.clear();
                _requirementsController.clear();
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  if (_isEditing) {
                    updateJobOffer(
                        _companyNameController.text,
                        _companyImageController.text,
                        _companyAddressController.text,
                        _nameController.text,
                        _typeController.text,
                        _requirementsController.text,
                        _joboffers[_selectedIndex].id);
                  } else {
                    addJobOffer(
                        _companyNameController.text,
                        _companyImageController.text,
                        _companyAddressController.text,
                        _nameController.text,
                        _typeController.text,
                        _requirementsController.text);
                  }
                  _companyNameController.clear();
                  _companyImageController.clear();
                  _companyAddressController.clear();
                  _nameController.clear();
                  _typeController.clear();
                  _requirementsController.clear();

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
        title: const Text('Job Offers Management'),
      ),
      body: _joboffers.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _joboffers.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(_joboffers[index].companyImage),
                  ),
                  title: Text(_joboffers[index].companyName),
                  subtitle: Text(_joboffers[index].name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _isEditing = true;
                          _selectedIndex = index;
                          _companyNameController.text =
                              _joboffers[index].companyName;
                          _companyImageController.text =
                              _joboffers[index].companyImage;
                          _companyAddressController.text =
                              _joboffers[index].companyAddress;
                          _nameController.text = _joboffers[index].name;
                          _typeController.text = _joboffers[index].type;
                          _requirementsController.text =
                              _joboffers[index].requirements;
                          _showFormDialog(context);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteJobOffer(_joboffers[index].id);
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
