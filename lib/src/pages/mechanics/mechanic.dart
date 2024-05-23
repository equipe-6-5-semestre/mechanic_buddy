class Mechanic {
  final int? id;
  final String name;
  final String phone;
  final String specialization;
  final List<String> vehicleTypes; // Updated to List<String>
  final int experience;
  final String city;
  final int userId;

  Mechanic({
    this.id,
    required this.name,
    required this.phone,
    required this.specialization,
    required this.vehicleTypes,
    required this.experience,
    required this.city,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'specialization': specialization,
      'vehicle_types': vehicleTypes.join(','), // Store as comma-separated string
      'experience': experience,
      'city': city,
      'user_id': userId,
    };
  }

  factory Mechanic.fromMap(Map<String, dynamic> map) {
    return Mechanic(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      specialization: map['specialization'],
      vehicleTypes: map['vehicle_types']?.split(',') ?? [], // Convert back to List<String>
      experience: map['experience'] ?? 0,
      city: map['city'] ?? '',
      userId: map['user_id'],
    );
  }
}

