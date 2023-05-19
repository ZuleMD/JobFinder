import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

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

  static Future<List<Job>> generateJobsForAuthCompany(
      String accessToken) async {
    final decodedToken = JwtDecoder.decode(accessToken);
    final id = decodedToken['sub'];

    final userResponse =
        await http.get(Uri.parse('http://localhost:3000/users/$id'));

    final userData = jsonDecode(userResponse.body);
    final companyName = userData['name'];

    final jobOffersResponse =
        await http.get(Uri.parse('http://localhost:3000/joboffers'));

    final extractedData = json.decode(jobOffersResponse.body) as List<dynamic>;
    final filteredData = extractedData
        .where((jobOfferData) => jobOfferData['companyName'] == companyName);

    return filteredData
        .map((jobOfferData) => Job(
              id: jobOfferData['id'],
              companyName: jobOfferData['companyName'],
              companyImage: jobOfferData['companyImage'],
              name: jobOfferData['name'],
              companyAddress: jobOfferData['companyAddress'],
              type: jobOfferData['type'],
              requirements: List<String>.from(jobOfferData['requirements']),
              closingdate: jobOfferData['closingdate'],
            ))
        .toList();
  }

  static Future<List<dynamic>> generateJobApplicationsForAuthCompany(
      String accessToken, String jobName) async {
    final decodedToken = JwtDecoder.decode(accessToken);
    final id = decodedToken['sub'];

    final userResponse =
        await http.get(Uri.parse('http://localhost:3000/users/$id'));

    final userData = jsonDecode(userResponse.body);
    final companyName = userData['name'];

    final jobApplicationsResponse =
        await http.get(Uri.parse('http://localhost:3000/jobapplications'));

    final extractedData =
        json.decode(jobApplicationsResponse.body) as List<dynamic>;
    print(extractedData);
    final filteredData = extractedData.where((jobAppData) =>
        jobAppData['companyName'] == companyName &&
        jobAppData['job'] == jobName);

    return filteredData.toList();
  }

  static Future<Job> addJobOffer({
    required String name,
    required String type,
    required List<String> requirements,
    required String closingdate,
  }) async {
    final accessToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Im9yYW5nZUBnbWFpbC5jb20iLCJpYXQiOjE2ODQ1MTU0MDksImV4cCI6MTY4NDUxOTAwOSwic3ViIjoiNyJ9.hYUsZbie7hxxVLqVHWYu3vKMUGLOCa1HTGuJvd_yZ8o';
    final decodedToken = JwtDecoder.decode(accessToken);
    final id = decodedToken['sub'];

    final userResponse =
        await http.get(Uri.parse('http://localhost:3000/users/$id'));

    final userData = jsonDecode(userResponse.body);
    final companyName = userData['name'];
    final companyImage = userData['image'];
    final companyAddress = userData['address'];

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
      {required String name,
      required String type,
      required List<String> requirements,
      required String closingdate,
      required int id}) async {
    final accessToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Im9yYW5nZUBnbWFpbC5jb20iLCJpYXQiOjE2ODQ1MTU0MDksImV4cCI6MTY4NDUxOTAwOSwic3ViIjoiNyJ9.hYUsZbie7hxxVLqVHWYu3vKMUGLOCa1HTGuJvd_yZ8o'; // replace with actual token from login API

    final decodedToken = JwtDecoder.decode(accessToken);
    final idd = decodedToken['sub'];

    final userResponse =
        await http.get(Uri.parse('http://localhost:3000/users/$idd'));

    final userData = jsonDecode(userResponse.body);
    final companyName = userData['name'];
    final companyImage = userData['image'];
    final companyAddress = userData['address'];

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
