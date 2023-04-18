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
}
