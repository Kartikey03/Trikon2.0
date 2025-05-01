import 'package:firebase_database/firebase_database.dart';

class MemberModel {
  final String name;
  final String role;
  final String? branch;
  final String image;
  final String instagram;
  final String linkedin;
  final String gmail;
  final String? quote;
  final String? github;
  final String? twitter;
  final String? imagePosition;

  MemberModel({
    required this.name,
    required this.role,
    this.branch,
    required this.image,
    required this.instagram,
    required this.linkedin,
    required this.gmail,
    this.quote,
    this.github,
    this.twitter,
    this.imagePosition,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      branch: json['branch'],
      image: json['image'] ?? '',
      instagram: json['instagram'] ?? '',
      linkedin: json['linkedin'] ?? '',
      gmail: json['gmail'] ?? '',
      quote: json['quote'],
      github: json['github'],
      twitter: json['twitter'],
      imagePosition: json['imagePosition'],
    );
  }
}
class MembersService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("teamDetails");

  Future<List<MemberModel>> getLeadership() async {
    final snapshot = await _database.child('leadership').get();
    if (snapshot.exists) {
      final data = snapshot.value as List<dynamic>;
      return data.map((e) => MemberModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    return [];
  }

  Future<List<MemberModel>> getStudentCoordinators() async {
    final snapshot = await _database.child('studentCoordinators').get();
    if (snapshot.exists) {
      final data = snapshot.value as List<dynamic>;
      return data.map((e) => MemberModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    return [];
  }

  Future<List<MemberModel>> getCoreTeam() async {
    final snapshot = await _database.child('coreTeam').get();
    if (snapshot.exists) {
      final data = snapshot.value as List<dynamic>;
      return data.map((e) => MemberModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    return [];
  }

  Future<List<MemberModel>> getJuniorTeam() async {
    final snapshot = await _database.child('juniorTeam').get();
    if (snapshot.exists) {
      final data = snapshot.value as List<dynamic>;
      return data.map((e) => MemberModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    return [];
  }
}

class MentorModel {
  final String name;
  final String role;
  final String image;
  final String bio;
  final String email;
  final String linkedin;
  final String? instagram;
  final String specialty;

  MentorModel({
    required this.name,
    required this.role,
    required this.image,
    required this.bio,
    required this.email,
    required this.linkedin,
    this.instagram,
    required this.specialty,
  });

  factory MentorModel.fromJson(Map<String, dynamic> json) {
    return MentorModel(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      image: json['image'] ?? '',
      bio: json['bio'] ?? '',
      email: json['email'] ?? '',
      linkedin: json['linkedin'] ?? '',
      instagram: json['instagram'],
      specialty: json['specialty'] ?? '',
    );
  }
}
class MentorsService {
  final DatabaseReference _databaseMentors = FirebaseDatabase.instance.ref("trikon2025");

  Future<List<MentorModel>> getMentors() async {
    final snapshot = await _databaseMentors.child('mentors').get();
    if (snapshot.exists) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
      // Convert the map to a list of MentorModel objects
      return data.entries.map((entry) {
        final mentorData = Map<String, dynamic>.from(entry.value as Map);
        return MentorModel.fromJson(mentorData);
      }).toList();
    }
    return [];
  }
}

class JuryModel {
  final String name;
  final String role;
  final String image;
  final String linkedin;
  final String? bio;
  final String? email;


  JuryModel({
    required this.name,
    required this.role,
    required this.image,
    required this.linkedin,
    required this.bio,
    this.email,
  });

  factory JuryModel.fromJson(Map<String, dynamic> json) {
    return JuryModel(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      image: json['image'] ?? '',
      linkedin: json['linkedin'] ?? '',
      bio: json['bio'] ?? '',
      email: json['email'],
    );
  }
}
class JuryService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("trikon2025");

  Future<List<JuryModel>> getJury() async {
    final snapshot = await _database.child('jury').get();
    if (snapshot.exists) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
      // Convert the map to a list of JuryModel objects
      return data.entries.map((entry) {
        final juryData = Map<String, dynamic>.from(entry.value as Map);
        return JuryModel.fromJson(juryData);
      }).toList();
    }
    return [];
  }
}