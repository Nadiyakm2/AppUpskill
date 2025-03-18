class JobPost {
  final String id;
  final String title;
  final String description;
  final String company;
  final String location;
  final String salary;
  final String experienceRequired;
  final String applyLink;
  final String postedAt;
  final String jobType;

  JobPost({
    required this.id,
    required this.title,
    required this.description,
    required this.company,
    required this.location,
    required this.salary,
    required this.experienceRequired,
    required this.applyLink,
    required this.postedAt,
    required this.jobType,
  });

  // Create a JobPost object from Supabase row data
  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      company: json['company'],
      location: json['location'],
      salary: json['salary'],
      experienceRequired: json['experience_required'],
      applyLink: json['apply_link'],
      postedAt: json['posted_at'],
      jobType: json['job_type'],
    );
  }
}
