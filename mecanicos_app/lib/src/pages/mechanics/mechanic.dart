class Mechanic {
  final int? id;
  final String name;
  final String phone;
  final String specialization;

  Mechanic({this.id, required this.name, required this.phone, required this.specialization});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'specialization': specialization,
    };
  }

  factory Mechanic.fromMap(Map<String, dynamic> map) {
    return Mechanic(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      specialization: map['specialization'],
    );
  }
}
