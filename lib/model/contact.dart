class Contact {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? city;
  final String? state;
  final String? phoneNumber;

  Contact({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.city,
    this.state,
    this.phoneNumber,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'city': city,
        'state': state,
        'phoneNumber': phoneNumber,
      };
}
