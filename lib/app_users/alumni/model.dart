class Alumni {
  final String id;
  final String name;
  final String email;
  final String company;
  final String experience;
  final bool isMentor;
  final String profileImage;

  Alumni({
    required this.id,
    required this.name,
    required this.email,
    required this.company,
    required this.experience,
    required this.isMentor,
    required this.profileImage,
  });

  // Convert JSON to Alumni object
  factory Alumni.fromJson(Map<String, dynamic> json) {
    return Alumni(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      company: json['company'],
      experience: json['experience'],
      isMentor: json['isMentor'],
      profileImage: json['profile_image'] ?? '',
    );
  }

  // Convert Alumni object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'company': company,
      'experience': experience,
      'isMentor': isMentor,
      'profile_image': profileImage,
    };
  }
}
