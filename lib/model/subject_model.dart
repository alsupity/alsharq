class SubjectModel {
  int id;
  String name;
  String? image;
  String? desc;

  int classesId;

  String? deletedAt;
  String createdAt;
  String updatedAt;

  SubjectModel({
    required this.id,
    required this.name,
    this.image,
    this.desc,
    required this.classesId,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      desc: json['body'],
      classesId: json['classes_id'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'body': desc,
      'classes_id': classesId,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

}
