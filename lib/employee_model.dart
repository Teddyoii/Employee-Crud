class Employee {
  final String id;
  final String name;
  final String role;
  final DateTime startDate;
  final DateTime endDate;
  final bool isPresent;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.startDate,
    required this.endDate,
    required this.isPresent,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'isPresent': isPresent ? 1 : 0,
    };
  }

  static Employee fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      role: map['role'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      isPresent: map['isPresent'] == 1 ? true : false,
    );
  }
}
