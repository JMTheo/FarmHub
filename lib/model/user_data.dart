class UserData {
  String uidAuth;
  final String name;
  final String surname;
  final String cpf;
  final String? email;
  final List<String>? owner;
  final List<String>? canAccess;

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
}
