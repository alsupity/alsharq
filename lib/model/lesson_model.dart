class LessonModel {
  int id;
  String name;
  String? image;
  String? body;
  int? qtyAsk;

  int subjectId;
  int userId;

  String? deletedAt;
  String createdAt;
  String updatedAt;

  LessonModel({
    required this.id,
    required this.name,
    this.image,
    this.body,
    required this.subjectId,
    required this.userId,
    required this.qtyAsk,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      body: json['body'],
      subjectId: json['subject_id'],
      userId: json['user_id'],
      qtyAsk: json['qty_ask'],
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
      'subject_id': subjectId,
      'user_id': userId,
      'qty_ask': qtyAsk,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
