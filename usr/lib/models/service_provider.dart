class ServiceProvider {
  final String id;
  final String name;
  final String phone;
  final String serviceType;
  final String city;
  final String description;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.phone,
    required this.serviceType,
    required this.city,
    required this.description,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      serviceType: json['serviceType'],
      city: json['city'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'serviceType': serviceType,
      'city': city,
      'description': description,
    };
  }
}