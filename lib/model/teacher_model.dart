class TeacherModel {
  int id;
  String name;
  String? body;
  String? image;
  String? email;
  String? phone;
  String? type;

  String? deletedAt;
  String createdAt;
  String updatedAt;

  TeacherModel({
    required this.id,
    required this.name,
    this.body,
    this.image,
    this.email,
    this.phone,
    this.type,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'],
      name: json['name'],
      body: json['body'],
      image: json['image'],
      email: json['email'],
      phone: json['phone'],
      type: json['type'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'body': body,
      'image': image,
      'email': email,
      'phone': phone,
      'type': type,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
