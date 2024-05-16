class Mechanic {
  final int? id;
  final String name;
  final String phone;
  final String specialization;
  final int userId;

  Mechanic({this.id, required this.name, required this.phone, required this.specialization, required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'specialization': specialization,
      'user_id': userId,
    };
  }

  factory Mechanic.fromMap(Map<String, dynamic> map) {
    return Mechanic(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      specialization: map['specialization'],
      userId: map['user_id'],
    );
  }
}
