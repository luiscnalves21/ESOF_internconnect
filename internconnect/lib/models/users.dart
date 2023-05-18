class User {
  User({required this.name, required this.email});

  final String? name;
  final String? email;
}

class UserData {
  final String uid;
  final String type;
  final String name;
  final String email;
  final List<String> softSkills;
  final List<String> certificates;

  UserData({
    required this.type,
    required this.uid,
    required this.name,
    required this.email,
    required this.softSkills,
    required this.certificates,
  });
}
