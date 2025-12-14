class Department {
  final int? deptId;
  final String deptName;
  final String deptCode;

  Department({
    this.deptId,
    required this.deptName,
    required this.deptCode,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      deptId: json['deptId'],
      deptName: json['deptName'],
      deptCode: json['deptCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deptId': deptId,
      'deptName': deptName,
      'deptCode': deptCode,
    };
  }

  Department copyWith({
    int? deptId,
    String? deptName,
    String? deptCode,
  }) {
    return Department(
      deptId: deptId ?? this.deptId,
      deptName: deptName ?? this.deptName,
      deptCode: deptCode ?? this.deptCode,
    );
  }
}