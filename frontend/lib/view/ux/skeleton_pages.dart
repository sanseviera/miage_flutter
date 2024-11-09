import 'package:flutter/material.dart';
import 'package:projet_clothes/config/app_config.dart';
import 'package:projet_clothes/view/ux/debugger_widget/debugger_widget.dart';

import '../pages/page_clothes_basket.dart';
import '../pages/page_clothes_list.dart';
import '../pages/page_clothes_profil.dart';

class SkeletonPages extends StatefulWidget {
  final Widget child;
  final int selectedIndex;
  final bool isBottomNavigationBarEnable;
  final bool isAppBarEnable;
  final String title;

  const SkeletonPages(
      {super.key,
      required this.child,
      required this.selectedIndex,
      required this.isBottomNavigationBarEnable,
      required this.isAppBarEnable,
      required this.title});

  @override
  State<SkeletonPages> createState() => _SkeletonPages();
}

class _SkeletonPages extends State<SkeletonPages> {
  void _onItemTapped(int index) {
    Widget page;
    if (index == 0 && widget.selectedIndex != 0) {
      page = const PageClothesList();
    } else if (index == 1 && widget.selectedIndex != 1) {
      page = const PageClothesBasket();
    } else if (index == 2 && widget.selectedIndex != 2) {
      page = const PageClothesProfil();
    } else {
      page = const PageClothesList();
    }
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return page; // La page vers laquelle tu navigues
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return page;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.isAppBarEnable)
          ? AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.title),
                ],
              ),
            )
          : null,
      body: SafeArea(
        child: Stack(children: [
          widget.child,
          (AppConfig().isDebuggerEnabled)
              ? const DebuggerWidget()
              : const SizedBox.shrink(),
        ]),
      ),
      bottomNavigationBar: (widget.isBottomNavigationBarEnable)
          ? BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.euro),
                  label: 'Acheter',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Panier',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
              currentIndex: widget.selectedIndex,
              selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,
            )
          : null,
    );
  }
}
