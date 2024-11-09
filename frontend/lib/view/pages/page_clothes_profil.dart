import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projet_clothes/controller/users_controller.dart';
import 'package:projet_clothes/model/clothes_user.dart';
import 'package:projet_clothes/view/pages/page_clothes_add.dart';
import 'package:projet_clothes/view/pages/page_login.dart';
import 'package:projet_clothes/view/ux/skeleton_pages.dart';

class PageClothesProfil extends StatefulWidget {
  const PageClothesProfil({super.key});

  @override
  State<PageClothesProfil> createState() => _PageClothesProfil();
}

class _PageClothesProfil extends State<PageClothesProfil> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _cityCodeController = TextEditingController();
  DateTime? _selectedDate;

  // Méthode pour afficher le DatePicker et récupérer la date choisie
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ?? DateTime.now(), // Date initiale (aujourd'hui)
      firstDate: DateTime(2000), // Date minimale (année 2000)
      lastDate: DateTime(2101), // Date maximale (année 2101)
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // Mise à jour de la date sélectionnée
        // Utilisation de DateFormat pour formater la date sous forme de 'dd/MM/yyyy'
        _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ne pas initialiser directement le _dateController.text ici
    _passwordController.text = ClothesUser().password!;
    _addressController.text = ClothesUser().address!;
    _zipCodeController.text = ClothesUser().zipCode!;
    _cityCodeController.text = ClothesUser().city!;

    // Initialiser _dateController.text si _selectedDate est null
    if (_selectedDate == null) {
      _selectedDate = ClothesUser().birthday ?? DateTime.now();
      _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
    }

    return SkeletonPages(
      title: "Votre profil",
      isAppBarEnable: true,
      isBottomNavigationBarEnable: true,
      selectedIndex: 2,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(ClothesUser().login!),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  labelText: 'Password',
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
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: "Date d'anniversaire",
                  hintText: 'Cliquez pour choisir une date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () {
                  // Empêcher l'édition directe du champ et ouvrir le DatePicker
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectDate(context);
                },
                readOnly: true, // Empêche l'utilisateur de taper manuellement
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_on),
                  labelText: 'Adresse',
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
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.confirmation_number),
                  labelText: 'Code postal',
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
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _cityCodeController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_city),
                  labelText: 'City',
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
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PageClothesAdd()));
                },
                child: const Text('Ajouter un nouveau vêtement'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        UsersController.updateUserProfile(
                            selectedDate: _selectedDate!.millisecondsSinceEpoch,
                            addressController: _addressController.text,
                            zipCode: _zipCodeController.text,
                            cityCodeController: _cityCodeController.text);
                        if (ClothesUser().password !=
                            _passwordController.text) {
                          // flutter affichage message en bas de l'écran
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Mot de passe mis à jour avec succès'),
                            ),
                          );

                          UsersController.updatePassword(
                              _passwordController.text);
                        }
                      }
                    },
                    child: const Text('Valider'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const PageLogin(),
                          ),
                        );
                      }
                    },
                    child: const Text('Se déconnecter'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
