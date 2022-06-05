class UserData {
  String uidAuth;
  final String name;
  final String surname;
  final String cpf;
  final String? email;

  UserData({
    this.uidAuth = '',
    required this.name,
    required this.surname,
    required this.cpf,
    this.email,
  });

  Map<String, dynamic> toJson() => {
        'uid_auth': uidAuth,
        'name': name,
        'surname': surname,
        'cpf': cpf,
        'email': email,
      };

  static UserData fromJson(Map<String, dynamic> json) => UserData(
        uidAuth: json['uid_auth'],
        cpf: json['cpf'],
        name: json['name'],
        surname: json['surname'],
        email: json['email'],
      );
}
