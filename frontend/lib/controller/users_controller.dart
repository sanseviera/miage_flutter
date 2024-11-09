import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/clothes_user.dart';

class UsersController {
  static Future<bool> connexion(String email, String password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String userId;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      userId = userCredential.user?.uid ?? '';
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print("--------------\nNo good bad connection : $e\n--------------");
      return false;
    }
    // Si on passe ici c'est que l'authentification à réussi
    ClothesUser();
    Map<String, dynamic>? data = await fetchUserClothes(userId);
    ClothesUser().updateUserInfo(
        id: data?['id'],
        login: email,
        password: password,
        birthday: (data?['birthday'] as Timestamp).toDate(),
        address: data?['address'],
        zipCode: data?['zipCode'],
        city: data?['city']);
    return true;
  }

  // Méthode pour récupérer les informations liées aux vêtements de l'utilisateur
  static Future<Map<String, dynamic>?> fetchUserClothes(String userId) async {
    try {
      // Effectuer une requête pour récupérer l'utilisateur dont l'ID correspond à userId
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users') // Nom de la collection
          .where('id',
              isEqualTo: userId) // Filtrer par le champ 'id' (ou 'userId')
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Assumer qu'il y a un seul utilisateur avec cet id, on récupère le premier document
        DocumentSnapshot userDoc = snapshot
            .docs.first; // Récupère le premier (et normalement seul) document
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        userData['id'] = userDoc.id;
        log("Utilisateur récupéré : ${userData['id']}");

        // Retourner les informations de l'utilisateur
        return userData;
      } else {
        log("Aucun utilisateur trouvé pour l'ID $userId");
        return null; // Aucun utilisateur trouvé
      }
    } catch (e) {
      log("Erreur lors de la récupération des informations de l'utilisateur : $e");
      return null; // Retourner null en cas d'erreur
    }
  }

  // Fonction pour mettre à jour le profil de l'utilisateur dans Firestore
  static Future<void> updateUserProfile(
      {required int selectedDate,
      required String addressController,
      required String zipCode,
      required String cityCodeController}) async {
    // Récupère l'ID de l'utilisateur (ou utilise un utilisateur connecté)
    final String userId =
        ClothesUser().id!; // Remplace avec l'ID de l'utilisateur

    // Crée une référence à Firestore
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      // Mets à jour le document de l'utilisateur
      await userRef.update({
        'birthday': Timestamp.fromMillisecondsSinceEpoch(selectedDate), // Conversion en Timestamp
        'address': addressController,
        'zipCode': zipCode,
        'city': cityCodeController,
      });

      ClothesUser().updateUserInfo(
          id: ClothesUser().id!,
          login: ClothesUser().login!,
          password: ClothesUser().password!,
          birthday: DateTime.fromMillisecondsSinceEpoch(selectedDate),
          address: addressController,
          zipCode: zipCode,
          city: cityCodeController);
    } catch (e) {
      log('error');
    }
  }

  // Fonction pour mettre à jour le mot de passe de l'utilisateur
  static Future<void> updatePassword(String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Créer un objet de credentials pour la réauthentification
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: ClothesUser().password!,
        );

        // Réauthentifier l'utilisateur
        await user.reauthenticateWithCredential(credential);

        // Si la réauthentification réussit, mettre à jour le mot de passe
        await user.updatePassword(newPassword);

        ClothesUser().password = newPassword;
        log("Mot de passe mis à jour avec succès");
      } else {
        log("Aucun utilisateur connecté.");
      }
    } on FirebaseAuthException catch (e) {
      // Gérer les erreurs spécifiques de Firebase Auth
      log("Erreur lors de la mise à jour du mot de passe : ${e.message}");
    } catch (e) {
      // Gérer d'autres erreurs
      log("Erreur lors de la mise à jour du mot de passe : $e");
    }
  }
  
  
}
