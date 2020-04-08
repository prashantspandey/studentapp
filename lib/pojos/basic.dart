class StudentUser {
  String key;
  String username;
  String name;
  String institute;

  StudentUser({this.key, this.username, this.name, this.institute});
  factory StudentUser.fromJson(Map<String, dynamic> json) {
    return StudentUser(
        key: json['key'],
        institute: json['institute'],
        username: json['username'],
        name: json['name']);
  }
  Map<String, dynamic> toJson() => {
        'key': key,
        'username': username,
        'name': name,
        'institute': institute,
      };
}
