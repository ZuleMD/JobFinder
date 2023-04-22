import 'dart:convert';
import 'package:http/http.dart' as http;

class Job {
  int id;
  String companyName;
  String companyImage;
  String companyAddress;
  String name;
  String type;
  List<String> requirements;
  String closingdate;

  Job({
    required this.id,
    required this.companyName,
    required this.companyImage,
    required this.companyAddress,
    required this.name,
    required this.type,
    required this.requirements,
    required this.closingdate,
  });

  static Future<List<Job>> generateJobs() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/joboffers'));
    final extractedData = json.decode(response.body) as List<dynamic>;
    return extractedData
        .map((joboffersData) => Job(
              id: joboffersData['id'],
              companyName: joboffersData['companyName'],
              companyImage: joboffersData['companyImage'],
              name: joboffersData['name'],
              companyAddress: joboffersData['companyAddress'],
              type: joboffersData['type'],
              requirements: List<String>.from(joboffersData['requirements']),
              closingdate: joboffersData['closingdate'],
            ))
        .toList();
  }

  static Future<Job> addJobOffer({
    required String companyName,
    required String companyImage,
    required String companyAddress,
    required String name,
    required String type,
    required List<String> requirements,
    required String closingdate,
  }) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/joboffers'),
      body: json.encode({
        'companyName': companyName,
        'companyImage': companyImage,
        'companyAddress': companyAddress,
        'name': name,
        'type': type,
        'requirements': requirements,
        'closingdate': closingdate
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final newJobOffer = Job(
      id: json.decode(response.body)['id'],
      companyName: companyName,
      companyImage: companyImage,
      companyAddress: companyAddress,
      name: name,
      type: type,
      requirements: requirements,
      closingdate: closingdate,
    );

    return newJobOffer;
  }

  static Future<Job> updateJobOffer(
      {required String companyName,
      required String companyImage,
      required String companyAddress,
      required String name,
      required String type,
      required List<String> requirements,
      required String closingdate,
      required int id}) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/joboffers/$id'),
      body: json.encode({
        'companyName': companyName,
        'companyImage': companyImage,
        'companyAddress': companyAddress,
        'name': name,
        'type': type,
        'requirements': requirements,
        'closingdate': closingdate
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final updatedJobOffer = Job(
      id: id,
      companyName: companyName,
      companyImage: companyImage,
      companyAddress: companyAddress,
      name: name,
      type: type,
      requirements: requirements,
      closingdate: closingdate,
    );
    return updatedJobOffer;
  }

  static Future<void> deleteJobOffer(int id) async {
    final response =
        await http.delete(Uri.parse('http://localhost:3000/joboffers/$id'));
  }
}
