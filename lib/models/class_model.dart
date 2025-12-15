class ClassModel {
  final int? id;
  final String className;
  final int departmentId;

  ClassModel({
    this.id,
    required this.className,
    required this.departmentId,
  });

factory ClassModel.fromJson(Map<String, dynamic> json) {
  return ClassModel(
    id: json['id'] != null ? json['id'] as int : null,
    className: json['className'] ?? '', // Default to empty string if null
    departmentId: json['departmentId'] != null ? json['departmentId'] as int : 0, // Default 0 if null
  );
}

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'className': className,
      'departmentId': departmentId,
    };
  }

  ClassModel copyWith({
    int? id,
    String? className,
    int? departmentId,
  }) {
    return ClassModel(
      id: id ?? this.id,
      className: className ?? this.className,
      departmentId: departmentId ?? this.departmentId,
    );
  }
}