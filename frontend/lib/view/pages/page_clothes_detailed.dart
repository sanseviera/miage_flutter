import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projet_clothes/controller/articles_controller.dart';
import 'package:projet_clothes/model/clothes_user.dart';
import 'package:projet_clothes/view/ux/skeleton_pages.dart';
import '../../model/article.dart';

class PageClothesDetailed extends StatefulWidget {
  final Article article;

  const PageClothesDetailed({super.key, required this.article});

  @override
  State<PageClothesDetailed> createState() => _PageClothesDetailed();
}

class _PageClothesDetailed extends State<PageClothesDetailed> {
  @override
  Widget build(BuildContext context) {
    return SkeletonPages(
        title: "Détail du produit",
        isAppBarEnable: true,
        isBottomNavigationBarEnable: false,
        selectedIndex: 0,
        child: Stack(children: [
          ListView(
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: Image.memory(
                  base64Decode(
                      widget.article.imageBase64), // Décoder l'image en base64
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  widget.article.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 200,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Catégorie : ${widget.article.clothesCategory.name}"),
                      Text("Taille : ${widget.article.size.name}"),
                      Text("Marque : ${widget.article.clothesBrand.name}"),
                      Text("Prix : ${widget.article.price / 100}€"),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
              width: double.maxFinite,
              height: double.maxFinite,
              child: Align(
                  alignment: Alignment
                      .bottomCenter, // Aligner l'élément en bas au centre
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            ArticleController.addArticleToBasket(
                                widget.article.id, ClothesUser().id!);
                          },
                          child: const Text("Ajouter au panier")),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Retour")),
                    ],
                  )))
        ]));
  }
}
