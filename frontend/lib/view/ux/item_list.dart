import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projet_clothes/controller/articles_controller.dart';
import 'package:projet_clothes/model/article.dart';

import '../../model/clothes_user.dart';
import '../pages/page_clothes_detailed.dart';

class ItemList extends StatefulWidget {
  final Article article;
  final bool inkWellEnable;
  final bool isClosable;
  final Function setStateParent;

  const ItemList(
      {super.key,
      required this.article,
      required this.inkWellEnable,
      required this.isClosable,
      required this.setStateParent});

  @override
  State<ItemList> createState() => _ItemList();
}

class _ItemList extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(16.0), // Le rayon des coins de la carte
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(
              16.0), // Pour que l'effet de clic suive les bords arrondis
          onTap: widget.inkWellEnable
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => PageClothesDetailed(
                              article: widget.article,
                            )),
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(
                10.0), // Optionnel: Ajouter un padding global à l'intérieur de la carte
            child: Row(
              children: [
                Image.memory(
                  base64Decode(
                      widget.article.imageBase64), // Décoder l'image en base64
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(
                    width: 20), // Un espacement entre l'image et le texte
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.article.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text("Taille: ${widget.article.size.name}"),
                      const SizedBox(height: 5),
                      Text("Prix: ${widget.article.price / 100}€"),
                    ],
                  ),
                ),
                widget.isClosable
                    ? IconButton(
                        onPressed: () async {
                          await ArticleController.removeArticleFromBasket(
                              widget.article.id, ClothesUser().id!);
                          widget.setStateParent();
                        },
                        icon:const Icon(Icons.close))
                    :const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
