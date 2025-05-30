class ClassModel {
  int id;
  String name;
  int countryId;
  int? departmentId;
  String? deletedAt;
  String createdAt;
  String updatedAt;

  ClassModel({
    required this.id,
    required this.name,
    required this.countryId,
    this.departmentId,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      name: json['name'],
      countryId: json['country_id'],
      departmentId: json['department_id'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'country_id': countryId,
      'department_id': departmentId,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

}
