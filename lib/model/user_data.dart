class UserData {
  String uidAuth;
  final String name;
  final String surname;
  final String cpf;
  final String? email;
  final List<dynamic>? owner;
  final List<dynamic>? canAccess;

  UserData({
    this.uidAuth = '',
    required this.name,
    required this.surname,
    required this.cpf,
    this.email,
    this.owner,
    this.canAccess,
  });

  Map<String, dynamic> toJson() => {
        'uidAuth': uidAuth,
        'name': name,
        'surname': surname,
        'cpf': cpf,
        'owner': owner,
        'canAccess': canAccess,
      };

  static UserData fromJson(Map<String, dynamic> json) => UserData(
        uidAuth: json['uid_auth'],
        cpf: json['cpf'],
        name: json['name'],
        surname: json['surname'],
        owner: json['owner'],
        canAccess: json['canAccess'],
      );
}
