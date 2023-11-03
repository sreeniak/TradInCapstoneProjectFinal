
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Login Register/FirstPage.dart';
import '../components/cart_manager.dart';
import 'AuthPage.dart';
import 'package:tradin_app/Pages/Home.dart';


class MainPage extends StatefulWidget {
  late final CartManager cartManager;
  late final FirebaseAuth auth;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _showFirstPage = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _showFirstPage = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showFirstPage) {
      return FirstPage();
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Home(cartManager: widget.cartManager, auth: widget.auth);
        } else {
          return AuthPage();
        }
      },
    );
  }
}
