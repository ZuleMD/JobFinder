class JobOffer {
  int id;
  String companyName;
  String companyImage;
  String companyAddress;
  String name;
  String type;
  List<String> requirements;

  JobOffer(
      {required this.id,
      required this.companyName,
      required this.companyImage,
      required this.companyAddress,
      required this.name,
      required this.type,
      required this.requirements});
}
