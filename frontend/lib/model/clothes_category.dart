enum ClothesCategory { ceinture, chaussures, haut }

extension ClothesCategoryExtension on ClothesCategory {
  // Convertit une valeur de ClothesCategory en une chaîne de caractères
  String toMap() {
    return toString()
        .split('.')
        .last; // Retourne 'pantalon', 'short' ou 'haut'
  }

  // Convertit une chaîne de caractères en ClothesCategory
  static ClothesCategory fromMap(String category) {
    switch (category.toLowerCase()) {
      case 'ceinture':
        return ClothesCategory.ceinture;
      case 'chaussures':
        return ClothesCategory.chaussures;
      case 'haut':
        return ClothesCategory.haut;
      default:
        throw Exception('Invalid category name: $category');
    }
  }
}
