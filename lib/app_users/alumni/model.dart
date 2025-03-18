class Alumni {
  final String id;
  final String name;
  final String email;
  final String role;
  final String profilePicture;

  Alumni({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.profilePicture,
  });

  // Convert JSON to Alumni object
  factory Alumni.fromJson(Map<String, dynamic> json) {
    return Alumni(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      profilePicture: json['profile_picture'],
    );
  }

  // Convert Alumni object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'profile_picture': profilePicture,
    };
  }
}
