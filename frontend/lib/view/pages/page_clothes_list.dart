import 'package:flutter/material.dart';
import 'package:projet_clothes/controller/articles_controller.dart';
import '../../model/article.dart';
import '../ux/item_list.dart';
import '../ux/skeleton_pages.dart';

class PageClothesList extends StatefulWidget {
  const PageClothesList({super.key});

  @override
  State<PageClothesList> createState() => _PageClothesList();
}

class _PageClothesList extends State<PageClothesList> {
  // Fonction asynchrone pour récupérer les articles et créer les widgets associés
  Future<List<Widget>> getArticlesWidgets() async {
    List<Widget> result = [];
    List<Article> articles = await ArticleController.getAllArticles();

    for (int i = 0; i < articles.length; i++) {
      result.add(ItemList(
        article: articles[i],
        inkWellEnable: true,
        isClosable: false,
        setStateParent: () {
          setState(() {});
        },
      ));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonPages(
      title: "Liste des vétements",
      isAppBarEnable: true,
      isBottomNavigationBarEnable: true,
      selectedIndex: 0,
      child: FutureBuilder<List<Widget>>(
        future:
            getArticlesWidgets(), // Attendre que les articles soient récupérés
        builder: (context, snapshot) {
          // Vérification de l'état de la requête
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Affichage d'un indicateur de chargement
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Erreur : ${snapshot.error}')); // Affichage d'un message d'erreur
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const  Center(
                child: Text(
                    'Aucun article trouvé')); // Affichage si aucune donnée n'est récupérée
          } else {
            // Affichage de la liste des articles une fois les données chargées
            return ListView(children: snapshot.data!);
          }
        },
      ),
    );
  }
}
