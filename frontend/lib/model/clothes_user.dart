/// Nous utilisons une classe Singleton puis ce que nous avons besoin d'une seule instance d'utilisateur dans l'application
class ClothesUser {
  String? id;
  String? login;
  String? password;
  DateTime? birthday;
  String? address;
  String? zipCode; //code postal
  String? city;

  // L'instance statique privée de la classe
  static final ClothesUser _instance = ClothesUser._internal();

  // Constructeur privé
  ClothesUser._internal();

  // Méthode factory pour retourner l'instance unique
  factory ClothesUser() {
    return _instance;
  }

  //
  void updateUserInfo({
    required String id,
    required String login,
    required String password,
    required DateTime birthday,
    required String address,
    required String zipCode,
    required String city,
  }) {
    this.id = id;
    this.login = login;
    this.password = password;
    this.birthday = birthday;
    this.address = address;
    this.zipCode = zipCode;
    this.city = city;
  }

  // Méthode toString pour afficher les infos de l'utilisateur
  @override
  String toString() {
    return """
         User(
            id: $id,
            login: $login,
            password: ${password != null ? "*" * password!.length : null},
            address: $address,
            zipCode: $zipCode,
            city: $city
         )""";
  }
}
