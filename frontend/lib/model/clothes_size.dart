enum ClothesSize {
  xs,
  s,
  m,
  l,
  xl,
  xll,
}

extension ClothesSizeExtension on ClothesSize {
  // Convertit une valeur de ClothesSize en chaîne de caractères
  String toMap() {
    return toString().split('.').last; // Retourne 'xs', 's', 'm', etc.
  }

  // Convertit une chaîne de caractères en ClothesSize
  static ClothesSize fromMap(String size) {
    switch (size.toLowerCase()) {
      case 'xs':
        return ClothesSize.xs;
      case 's':
        return ClothesSize.s;
      case 'm':
        return ClothesSize.m;
      case 'l':
        return ClothesSize.l;
      case 'xl':
        return ClothesSize.xl;
      case 'xll':
        return ClothesSize.xll;
      default:
        throw Exception('Invalid size: $size');
    }
  }
}
