class User {
  /*
  * uid - id of user
    name - user’s first name
    surname - user’s last name
    email - user’s email
    confirmed - email confirmation flag
    age - user’s age
    avatar - base64-encoded avatar picture
    rate - hidden system rating (evals from users with higher rating have more weight)
    contacts - list of user contacts (uid)
    password - bcrypt-hashed password

  * */
  int uid;
  String name;
  String surname;
  String email;
  String password;
  // bool isConfirmed;
  int age;
  String avatar; // base64 picture
  // List<int> contacts;

  User(
      {this.uid,
      this.name,
      this.surname,
      this.email,
      this.password,
      this.age,
      this.avatar});
}
