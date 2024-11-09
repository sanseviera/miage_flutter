import 'package:flutter/material.dart';
import 'package:projet_clothes/controller/users_controller.dart';

import 'package:projet_clothes/view/pages/page_clothes_list.dart';
import 'package:projet_clothes/view/ux/skeleton_pages.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLogin();
}

class _PageLogin extends State<PageLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  test() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const PageClothesList(),
      ),
    );
  }

  _login(email, password) async {
    if (await UsersController.connexion(email, password)) {
      test();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonPages(
        title: "MiageClothes",
        isAppBarEnable: true,
        isBottomNavigationBarEnable: false,
        selectedIndex: 0,
        child: Column(children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Login',
                            labelStyle: TextStyle(
                                color: Colors.black87,
                                fontSize: 17,
                                fontFamily: 'AvenirLight'),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                                color: Colors.black87,
                                fontSize: 17,
                                fontFamily: 'AvenirLight'),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _login(_emailController.text.trim(),
                                  _passwordController.text.trim());
                            }
                          },
                          child: const Text('Se connecter'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ]));
  }
}
