class AskModel {
  int id;
  String name;
  String optionsJson;
  int phaseId;

  int priority;
  String? deletedAt;
  String createdAt;
  String updatedAt;

  AskModel({
    required this.id,
    required this.name,
    required this.optionsJson,
    required this.phaseId,
    this.deletedAt,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AskModel.fromJson(Map<String, dynamic> json) {
    return AskModel(
      id: json['id'],
      name: json['name'],
      optionsJson: json['options_json'],
      phaseId: json['phase_id'],
      priority: json['priority'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'options_json': optionsJson,
      'phase_id': phaseId,
      'priority': priority,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

}
