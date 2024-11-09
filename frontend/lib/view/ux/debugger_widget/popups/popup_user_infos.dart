import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../model/clothes_user.dart';

// Widget PopupUserInfos
class PopupUserInfos extends StatelessWidget {
  const PopupUserInfos({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title:const Text("User informations"),
      content: Text(ClothesUser().toString(), textAlign: TextAlign.left),
      actions: [
        CupertinoDialogAction(
          child: const Text("Retour"),
          onPressed: () {
            Navigator.of(context).pop(); // Ferme la boîte de dialogue
          },
        ),
      ],
    );
  }

  // Méthode statique pour afficher le popup
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const PopupUserInfos();
      },
    );
  }
}
