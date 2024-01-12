class User_obj{
  final String uid;

  User_obj({required this.uid});
}

class UserData{
  final String uid;
  final String username;
  final String email;
  final String password;

  UserData({required this.uid, required this.username,
            required this.email, required this.password
  });
}