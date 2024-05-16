class Service {
  final int? id;
  final int mechanicId;
  final String name;
  final String description;
  final double price;

  Service({
    this.id,
    required this.mechanicId,
    required this.name,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mechanic_id': mechanicId,
      'name': name,
      'description': description,
      'price': price,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'],
      mechanicId: map['mechanic_id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
    );
  }
}
