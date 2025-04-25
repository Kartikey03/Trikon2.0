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