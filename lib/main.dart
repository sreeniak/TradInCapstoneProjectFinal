// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tradin_app/Chat/ChatHomePage.dart';
import 'package:tradin_app/Chat/LoginChatPage.dart';
import 'package:tradin_app/Pages/Home.dart';
import 'package:tradin_app/Pages/OrderPage.dart';
import 'package:tradin_app/Pages/Search.dart';
import 'package:tradin_app/Pages/Cart.dart';
import 'package:tradin_app/Pages/Profile.dart';
import 'package:tradin_app/Pages/Trade.dart';
import 'package:tradin_app/Pages/order_placed_page.dart';
import 'package:tradin_app/auth/MainPage.dart';
import 'package:tradin_app/Pages/SellPage.dart';
import 'package:tradin_app/Pages/BuyPage.dart';
import 'package:tradin_app/components/cart_manager.dart';
import 'package:tradin_app/Pages/LiveChatPage.dart';
import 'package:tradin_app/models/Item.dart' as ModelItem;
import 'package:tradin_app/utils.dart';

import 'Login Register/FirstPage.dart';
import 'Login Register/LoginPage.dart';
import 'Login Register/RegisterPage.dart';
import 'Pages/OrderConfirmationPage.dart';
import 'Pages/SellersListPage.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey = "pk_test_51NrrsuFWZAngHL0KDL31PRmiUhPU4BB9uNwE8EMeFwzECGyvoxwuUKedJRZVR2PMtg6qIZqXgRCqs5nmBvcwnOnt00HG9CD6lK";

  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    print("Error loading .env file: $e");
  }
  final cartManager = CartManager();
  final FirebaseAuth auth = FirebaseAuth.instance;
  ZIMKit().init(
    appID: Utils.id,
    appSign: Utils.SignIn,
  );
  runApp(MyApp(cartManager: cartManager, auth: auth));
}



class MyApp extends StatefulWidget {
  final CartManager cartManager;
  final FirebaseAuth auth;

  MyApp({required this.cartManager, required this.auth, Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TradIN',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.redAccent,
            unselectedItemColor: Colors.grey,
          ),
        ),
        home: Scaffold(
          body: _isLogin
              ? LoginPage(showRegisterPage: _showRegisterPage)
              : RegisterPage(showLoginPage: _showLoginPage),
        ),

        initialRoute: '/firstpage',
        routes: {
          '/firstpage': (context) => FirstPage(),
          '/loginpage': (context) => LoginPage(
            showRegisterPage: () {
              Navigator.of(context).pushReplacementNamed('/registerpage');
            },
          ),
          '/registerpage': (context) => RegisterPage(
            showLoginPage: () {
              Navigator.of(context).pushReplacementNamed('/loginpage');
            },
          ),
          '/mainpage': (context) => MainPage(),
          '/home': (context) => Home(cartManager: widget.cartManager, auth: widget.auth),
          '/searchpage': (context) => SearchPage(),
          '/cartpage': (context) => CartPage(cartManager: widget.cartManager, auth: widget.auth),
          '/profilepage': (context) => ProfilePage(),
          '/buypage': (context) => BuyPage(cartManager: widget.cartManager, auth: widget.auth),
          //'/buypage': (context) => BuyPage(),
          '/productlist': (context) => ProductList(),
          '/tradepage': (context) => TradePage(auth: widget.auth),
          '/orderpage': (context) => OrderPage(orderItems: [], cartItems: [],),
          '/livechatpage': (context) => LiveChatPage(),
          '/placedorder': (context) => PlacedOrderPage(orders: [],),
          "/orderConfirmationPage": (context) => OrderConfirmationPage(),
          '/sellerslist': (context) => SellersList(cartManager: widget.cartManager, auth: widget.auth),
          '/loginchatpage': (context) => LoginChatPage(),
        },
      ),
    );
  }

  void _showRegisterPage() {
    setState(() {
      _isLogin = false;
    });
  }

  void _showLoginPage() {
    setState(() {
      _isLogin = true;
    });
  }
}
