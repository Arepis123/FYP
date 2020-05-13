class NewUser {

  final String id;
  final String name;
  final String email;
  final DateTime age;
  final String gender;
  final String role;
  final String imageURL;

  NewUser({this.id, this.name, this.email, this.gender, this.age, this.role, this.imageURL});

  NewUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        email = data['email'],
        age = data['age'],
        gender = data['gender'],
        role = data['role'],
        imageURL = data['imageURL'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'role': role,
      'imageURL': imageURL
    };
  }
}