class Employee {
  int id;
  String fullName;
  String address;
  String phone;
  String image;
  String role;

  Employee({
    required this.id,
    required this.fullName,
    required this.address,
    required this.phone,
    required this.image,
    String? role,
  }) : this.role = role ?? "student";
}
