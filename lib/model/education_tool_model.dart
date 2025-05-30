class EducationToolModel {
  int id;
  String name;
  String? body;
  String? image;
  String? file;

  int typeId;
  int lessonId;

  String? deletedAt;
  String createdAt;
  String updatedAt;

  EducationToolModel({
    required this.id,
    required this.name,
    this.image,
    this.body,
    this.file,
    required this.typeId,
    required this.lessonId,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EducationToolModel.fromJson(Map<String, dynamic> json) {
    return EducationToolModel(
      id: json['id'],
      name: json['name'],
      body: json['body'],
      image: json['image'],
      file: json['file'],
      typeId: json['type_id'],
      lessonId: json['lesson_id'],
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
      'body': body,
      'file': file,
      'type_id': typeId,
      'lesson_id': lessonId,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
