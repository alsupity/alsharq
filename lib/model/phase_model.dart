class PhaseModel {
  int id;
  String name;
  double? overrideRate;
  int sequence;
  // int rank;
  int? numActualAsks;
  int subjectId;

  double rate; // local
  int? status; // local

  int priority;
  String? deletedAt;
  String createdAt;
  String updatedAt;

  PhaseModel({
    required this.id,
    required this.name,
    this.overrideRate,
    required this.sequence,
    // required this.rank,
    this.numActualAsks,
    required this.subjectId,

    required this.rate,
    this.status,

    required this.priority,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PhaseModel.fromJson(Map<String, dynamic> json) {
    return PhaseModel(
      id: json['id'],
      name: json['name'],
      overrideRate: json['override_rate'] + 0.0,
      sequence: json['sequence'],
      // rank: json['rank'],
      numActualAsks: json['num_actual_asks'],
      subjectId: json['subject_id'],

      rate: json['rate'] + 0.0,
      status: json['status'],

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
      'override_rate': overrideRate,
      'sequence': sequence,
      // 'rank': rank,
      'num_actual_asks': numActualAsks,
      'subject_id': subjectId,

      'rate': rate,
      'status': status,

      'priority': priority,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

}
