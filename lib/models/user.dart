
class User{
  int id;
  String username;
  String email;
  String role;
  int score;

  User({
    this.id,
    this.username,
    this.email,
    this.role,
    this.score,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      role: map['role'],
      score: map['score']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'username': this.username,
      'email': this.email,
      'role': this.role,
      'score': this.score
    };
  }

}