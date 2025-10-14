class AppUser {
  final String uid;
  final String email;
  final String role;

  AppUser({required this.uid,
    required this.email,
    required this.role,
  });

  //covert app user => json
  Map<String, dynamic> toJson (){
    return {
      'uid' : uid,
      'email' : email,
      'role': role,
    };

  }

//covert json => app user
  factory AppUser.fromJson(Map<String, dynamic> jsonuser) {
    return AppUser(
        uid: jsonuser ['uid'],
        email: jsonuser ['email'],
        role: jsonuser['role'] ?? 'customer', // default if missing
    );
  }
}