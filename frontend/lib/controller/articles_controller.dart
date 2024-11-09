import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projet_clothes/model/clothes_user.dart';
import '../model/article.dart'; // Assure-toi de bien importer le modèle Article

class ArticleController {
  static Future<List<Article>> getAllArticles() async {
    try {
      // Accède à la collection 'articles' dans Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('articles').get();

      // Transforme chaque document en un objet Article
      List<Article> articles = querySnapshot.docs.map((doc) {
        return Article.fromMap(doc.data(), doc.id);
      }).toList();

      return articles; // Retourne la liste des articles
    } catch (e) {
      return []; // En cas d'erreur, retourne une liste vide
    }
  }

  // Fonction pour récupérer les articles dans le panier de l'utilisateur
  static Future<List<Article>> getArticlesInBasket() async {
    List<Article> result = [];
    List<String> articleIds = [];

    /* ------------------------------------
    Etape 1 : Récupérer les IDs des articles
    ------------------------------------ */
    try {
      // Accède à la collection 'baskets' dans Firestore et filtre par utilisateur
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('baskets')
              .where('idUser',
                  isEqualTo: ClothesUser()
                      .id) // Assure-toi que ClothesUser().id est bien défini
              .get();

      // Supposons que chaque document dans 'baskets' a un champ 'articleIds' qui contient une liste des IDs d'articles
      for (var doc in querySnapshot.docs) {
        String articleIdsFromBasket = doc.data()['idArticle'];
        articleIds.add(articleIdsFromBasket);
      }
    } catch (e) {
      return []; // En cas d'erreur, retourne une liste vide
    }
    log("------------------------------");
    log(articleIds.toString());

    /* ------------------------------------
    Etape 2 : Récupérer les articles correspondant aux IDs
    ------------------------------------ */
    try {
      // Si la liste des articleIds est vide, pas besoin de continuer
      if (articleIds.isEmpty) {
        return [];
      }

      // Requête pour récupérer les articles dont les IDs sont dans la liste articleIds
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('articles')
          .where(FieldPath.documentId, whereIn: articleIds)
          .get();

      // Extraction des données sous forme d'objets Article
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> elt = doc.data() as Map<String, dynamic>;
        String id = doc.id;
        result.add(Article.fromMap(elt, id));
      }
    } catch (e) {
      return [];
    }

    // Log des résultats pour vérification
    log("------------------------------");
    log(result.toString());

    return result;
  }

  // Méthode pour supprimer un article du panier de l'utilisateur
  static Future<void> removeArticleFromBasket(
      String idArticle, String idUser) async {
    try {
      // Recherche du document dans la collection 'baskets' où idArticle et idUser correspondent
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('baskets')
          .where('idArticle', isEqualTo: idArticle)
          .where('idUser', isEqualTo: idUser)
          .get();

      // Vérifie s'il y a des documents correspondants
      if (querySnapshot.docs.isEmpty) {
        return; // Aucun document trouvé, on retourne
      }

      // Si des documents sont trouvés, on les supprime
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      log('Erreur lors de la suppression de l\'article du panier: $e');
    }
  }

  // Méthode pour ajouter un article au panier de l'utilisateur
  static Future<void> addArticleToBasket(
      String idArticle, String idUser) async {
    try {
      // Vérifie si l'article est déjà dans le panier de l'utilisateur
      QuerySnapshot querySnapshot =  await FirebaseFirestore.instance
          .collection('baskets')
          .where('idArticle', isEqualTo: idArticle)
          .where('idUser', isEqualTo: idUser)
          .get();

      // Si un document existe déjà pour cet article et cet utilisateur, on ne l'ajoute pas
      if (querySnapshot.docs.isNotEmpty) {
        return; // L'article existe déjà dans le panier
      }

      // Si l'article n'est pas dans le panier, on le crée
      await FirebaseFirestore.instance.collection('baskets').add({
        'idArticle': idArticle, // ID de l'article
        'idUser': idUser, // ID de l'utilisateur
        'timestamp': FieldValue
            .serverTimestamp(), // Optionnel : ajout d'un timestamp pour l'ordre des ajouts
      });

    } catch (e) {
      log('Erreur lors de l\'ajout de l\'article au panier: $e');
    }
  }

  static Future<void> addArticle(Article article) async {
    try {
      await FirebaseFirestore.instance
          .collection('articles')
          .add(article.toMap());
    } catch (e) {
      log('Erreur lors de l\'ajout de l\'article: $e');
    }
  }
}
