class ContactModel {
  int id;
  String name;
  String number;
  String image;
  bool isFavourite;

  ContactModel({
    required this.id,
    required this.name,
    required this.number,
    required this.image,
    this.isFavourite = false,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      image: json['image'],
      isFavourite: json['isFavourite'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'image': image,
      'isFavourite': isFavourite ? 1 : 0,
    };
  }
}