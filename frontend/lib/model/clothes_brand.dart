enum ClothesBrand { nike, timberland, soixanteHuitArt }

extension ClothesBrandExtension on ClothesBrand {
  // Convertit une valeur de ClothesBrand en une chaîne de caractères
  String toMap() {
    return toString().split('.').last; // Retourne 'nike' ou 'timberland'
  }

  // Convertit une chaîne de caractères en ClothesBrand
  static ClothesBrand fromMap(String brand) {
    switch (brand.toLowerCase()) {
      case 'nike':
        return ClothesBrand.nike;
      case 'timberland':
        return ClothesBrand.timberland;
      case 'soixantehuitart':
        return ClothesBrand.soixanteHuitArt;
      default:
        throw Exception('Invalid brand name: $brand');
    }
  }
}
