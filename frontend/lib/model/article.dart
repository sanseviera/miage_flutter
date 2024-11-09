import 'package:projet_clothes/model/clothes_category.dart';
import 'clothes_brand.dart';
import 'clothes_size.dart';

class Article {
  String id;
  String imageBase64;
  String name;
  ClothesSize size;
  int price; // On manipule des entier car sinon on aurit des problémes de précision. Notre prix est donc en centime.
  ClothesBrand clothesBrand;
  ClothesCategory clothesCategory;

  Article({
    required this.id,
    required this.imageBase64,
    required this.name,
    required this.size,
    required this.price,
    required this.clothesBrand,
    required this.clothesCategory,
  });

  // Méthode pour créer un Article à partir d'une Map (données Firestore)
  factory Article.fromMap(Map<String, dynamic> data, String documentId) {
    return Article(
      id: documentId,
      imageBase64: data['imageBase64'] ?? '',
      name: data['name'] ?? 'Unknown',
      size: ClothesSizeExtension.fromMap(data['size'] ?? ''),
      price: (data['price'] ?? 0.0).toInt(),
      clothesBrand: ClothesBrandExtension.fromMap(data['clothesBrand'] ?? ''),
      clothesCategory:
          ClothesCategoryExtension.fromMap(data['clothesCategory'] ?? {}),
    );
  }

  // Méthode pour convertir un Article en Map (pour Firestore par exemple)
  Map<String, dynamic> toMap() {
    return {
      'imageBase64': imageBase64,
      'name': name,
      'size': size.toMap(),
      'price': price,
      'clothesBrand': clothesBrand.toMap(),
      'clothesCategory': clothesCategory.toMap(),
    };
  }

  @override
  String toString() {
    return 'Article(id: $id, name: $name, size: ${size.toMap()}, price: $price, brand: ${clothesBrand.toMap()}, category: ${clothesCategory.toMap()})';
  }
}
