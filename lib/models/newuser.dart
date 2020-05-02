class NewUser {

  final String id;
  final String name;
  final String email;
  final String age;
  final String gender;

  NewUser({this.id, this.name, this.email, this.gender, this.age});

  NewUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        email = data['email'],
        age = data['age'],
        gender = data['gender'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
    };
  }
}