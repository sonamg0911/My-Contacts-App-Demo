class Contact {
  final int? id;
  final String? name;
  final String? profileUrl;
  final String? email;
  final String? city;
  final String? state;
  final String? phoneNumber;

  Contact({
    this.id,
    this.name,
    this.profileUrl,
    this.email,
    this.city,
    this.state,
    this.phoneNumber,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as int,
      name: json['name'] as String,
      profileUrl: json['profileUrl'] as String,
      email: json['email'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'profileUrl': profileUrl,
        'email': email,
        'city': city,
        'state': state,
        'phoneNumber': phoneNumber,
      };
}
