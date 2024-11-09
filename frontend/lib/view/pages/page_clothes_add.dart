import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projet_clothes/controller/articles_controller.dart';
import 'package:projet_clothes/model/clothes_brand.dart';
import 'package:projet_clothes/model/clothes_category.dart';
import 'package:projet_clothes/model/clothes_size.dart';
import 'package:projet_clothes/view/ux/skeleton_pages.dart';
import '../../controller/api_service.dart';
import '../../model/article.dart';

class PageClothesAdd extends StatefulWidget {
  const PageClothesAdd({super.key});

  @override
  State<PageClothesAdd> createState() => _PageClothesAdd();
}

class _PageClothesAdd extends State<PageClothesAdd> {
  final TextEditingController _titleController = TextEditingController();
  String? _base64Image;
  final ImagePicker _picker = ImagePicker();
  ApiService apiService = ApiService();
  // Initialiser les valeurs par défaut pour les enums
  ClothesCategory categorie = ClothesCategory.haut;
  ClothesSize taille = ClothesSize.xs;
  ClothesBrand brand = ClothesBrand.soixanteHuitArt;
  final TextEditingController _priceController = TextEditingController();

  Future<void> _pickImage() async {
    // Ouvrir la galerie pour sélectionner une image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Convertir l'image en base64
      final bytes = await File(image.path).readAsBytes();
      // Conversion en base64
      _base64Image = base64Encode(bytes);

      try {
        // Envoyer l'image à l'API et attendre le résultat
        int? type = await apiService.sendImage(_base64Image!);
        // Mettre à jour l'état avec setState
        setState(() {
          if (type == 0) {
            categorie = ClothesCategory.ceinture;
          } else if (type == 1) {
            categorie = ClothesCategory.chaussures;
          } else if (type == 2) {
            categorie = ClothesCategory.haut;
          }
        });
      } catch (e) {
        // Vous pouvez éventuellement informer l'utilisateur via un snackbar ou une alerte
      }
    }
  }

  goTo() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonPages(
      title: "Ajouter un vétement",
      isAppBarEnable: true,
      isBottomNavigationBarEnable: false,
      selectedIndex: 2,
      child: Form(
        child: ListView(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.abc),
                labelText: 'Titre',
                labelStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 17,
                    fontFamily: 'AvenirLight'),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple),
                ),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un titre';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Sélectionner une image'),
            ),
            const SizedBox(height: 20),
            Text("Catégorie : ${categorie.name}"),
            DropdownButton<ClothesSize>(
              value: taille,
              items: ClothesSize.values.map((ClothesSize size) {
                return DropdownMenuItem<ClothesSize>(
                  value: size,
                  child: Text(size.name),
                );
              }).toList(),
              onChanged: (ClothesSize? value) {
                setState(() {
                  if (value != null) {
                    taille = value;
                  }
                });
              },
            ),
            Text("Marque : ${brand.name}"),
            DropdownButton<ClothesBrand>(
              value: brand,
              items: ClothesBrand.values.map((ClothesBrand brandItem) {
                return DropdownMenuItem<ClothesBrand>(
                  value: brandItem,
                  child: Text(brandItem.name),
                );
              }).toList(),
              onChanged: (ClothesBrand? value) {
                setState(() {
                  if (value != null) {
                    brand = value;
                  }
                });
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.euro),
                labelText: 'Prix',
                labelStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 17,
                    fontFamily: 'AvenirLight'),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple),
                ),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un prix';
                }
                return null;
              },
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isNotEmpty && _base64Image != null) {
                  final Article article = Article(
                    id: "",
                    name: _titleController.text,
                    imageBase64: _base64Image!,
                    clothesCategory: categorie,
                    size: taille,
                    clothesBrand: brand,
                    price: (double.parse(_priceController.text) * 100).toInt(),
                  );
                  await ArticleController.addArticle(article);
                  goTo();
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}
