import "package:flutter/material.dart";
import "package:tradin_app/Chat/ChatHomePage.dart";
import "package:zego_zimkit/zego_zimkit.dart";




class LoginChatPage extends StatefulWidget {
  const LoginChatPage({super.key});

  @override
  State<LoginChatPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginChatPage> {
  final userId = TextEditingController();
  final username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[50],
        appBar: AppBar(
          backgroundColor: Colors.red[200],
          toolbarHeight: 100.0,
          elevation: 0,
          automaticallyImplyLeading: true,
          flexibleSpace: Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/tradin.png',
              height: 80.0,
              width: 80.0,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              TextFormField(
                controller: userId,
                decoration: InputDecoration(
                  labelText: "User Id",
                ),
              ),
              TextFormField(
                controller: username,
                decoration: InputDecoration(
                  labelText: "Username",
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(onPressed: () async {
                await ZIMKit().connectUser(id: userId.text, name: username.text);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context)=> ChatHomePage())
                );

              }, child: Text("Login"),),
            ],
          ) ,)
    );
  }
}