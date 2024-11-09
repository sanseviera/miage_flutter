import 'package:flutter/material.dart';
import 'package:projet_clothes/controller/articles_controller.dart';
import 'package:projet_clothes/view/ux/skeleton_pages.dart';
import '../../model/article.dart';
import '../ux/item_list.dart';

class PageClothesBasket extends StatefulWidget {
  const PageClothesBasket({super.key});

  @override
  State<PageClothesBasket> createState() => _PageClothesBasket();
}

class _PageClothesBasket extends State<PageClothesBasket> {
  double priceTotal = 0;

  // Fonction pour obtenir les articles en widget
  Future<List<Widget>> getArticlesWidgets() async {
    List<Widget> result = [];
    List<Article> articles = await ArticleController.getArticlesInBasket();

    // Réinitialisation du prix total pour éviter les accumulations incorrectes
    priceTotal = 0;

    for (int i = 0; i < articles.length; i++) {
      result.add(ItemList(
        article: articles[i],
        inkWellEnable: false,
        isClosable: true,
        setStateParent: () {
          setState(() {});
        },
      ));
      priceTotal += articles[i].price; // Ajout du prix de chaque article
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonPages(
      title: "Votre panier",
      isAppBarEnable: true,
      isBottomNavigationBarEnable: true,
      selectedIndex: 1,
      child: FutureBuilder<List<Widget>>(
        future:
            getArticlesWidgets(), // On attend que la liste des widgets soit obtenue
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Affichage d'un loader pendant le chargement
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Panier vide')); // Affichage si pas d'articles
          } else {
            // Si les données sont chargées et valides
            return Stack(
              children: [
                ListView(children: snapshot.data!), // Affichage des articles
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Text("Prix : ${priceTotal / 100}€",
                        style: const TextStyle(fontSize: 30)),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
