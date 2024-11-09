class AppConfig {
  // Créer un champ statique privé pour stocker l'instance unique
  static final AppConfig _instance = AppConfig._internal();

  // Cette méthode est privée et ne permet la création de l'instance qu'une seule fois.
  AppConfig._internal();

  // Fournir un point d'accès global à l'instance unique
  factory AppConfig() {
    return _instance;
  }

  // Propriétés et méthodes de la classe Singleton
  String appName = "Projet Clothes";
  bool isDebuggerEnabled = false;
}
