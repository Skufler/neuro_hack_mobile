import 'package:neuro_hack/model/user.dart';

import '../constants.dart';

class UserMock extends User {
  UserMock() {
    this.uid = 1;
    this.name = "Валерий";
    this.surname = "Жмышенко";
    this.email = "matviei.skufin@gmail.com";
    this.age = 56;
    this.avatar = Constants.avatar;
  }
}
