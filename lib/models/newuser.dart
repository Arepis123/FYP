class NewUser {

  final String id;
  final String name;
  final String email;
  final DateTime age;
  final String gender;
  final String role;
  final String imageURL;
  final int noReview;
  final int noPlaceAdded;

  NewUser({this.id, this.name, this.email, this.gender, this.age, this.role, this.imageURL, this.noReview, this.noPlaceAdded});

  NewUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        email = data['email'],
        age = data['age'],
        gender = data['gender'],
        role = data['role'],
        imageURL = data['imageURL'],
        noReview = data['noReview'],
        noPlaceAdded = data['noPlaceAdded'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'role': role,
      'imageURL': imageURL,
      'noReview': noReview,
      'noPlaceAdded': noPlaceAdded
    };
  }
}