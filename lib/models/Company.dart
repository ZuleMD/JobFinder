import 'dart:convert';
import 'package:http/http.dart' as http;

class Company {
  int id;
  String name;
  String address;
  String email;
  String password;
  String image;
  String description;
  String role;

  Company({
    required this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.password,
    required this.image,
    required this.description,
    String? role,
  }) : this.role = role ?? "company";

  static Future<List<Company>> generateCompanies() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/users?role=company'));
    final extractedData = json.decode(response.body) as List<dynamic>;
    return extractedData
        .map((companyData) => Company(
              id: companyData['id'],
              name: companyData['name'],
              address: companyData['address'],
              email: companyData['email'],
              password: companyData['password'],
              description: companyData['description'],
              image: companyData['image'],
            ))
        .toList();
  }

  static Future<Company> addCompany(
      {required String name,
      required String image,
      required String address,
      required String description,
      required String email,
      required String password}) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/signup'),
      body: json.encode({
        'name': name,
        'image': image,
        'address': address,
        'description': description,
        'email': email,
        'password': password,
        'role': 'company',
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final newCompany = Company(
        id: json.decode(response.body)['id'],
        name: name,
        image: image,
        address: address,
        description: description,
        email: email,
        password: password,
        role: "company");

    return newCompany;
  }

  static Future<Company> updateCompany(
      {required String name,
      required String image,
      required String address,
      required String description,
      required String email,
      required String password,
      required int id}) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/users/$id'),
      body: json.encode({
        'name': name,
        'image': image,
        'address': address,
        'description': description,
        'email': email,
        'password': password,
        'role': 'company'
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final updatedCompany = Company(
      id: id,
      name: name,
      image: image,
      address: address,
      description: description,
      email: email,
      password: password,
    );
    return updatedCompany;
  }

  static Future<void> deleteCompany(int id) async {
    final response =
        await http.delete(Uri.parse('http://localhost:3000/users/$id'));
  }
}
