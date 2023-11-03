// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isNotificationsEnabled = true;
  String _selectedLanguage = 'English';
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // No need
    } else if (index == 1) {
      print('Navigating to Search');
      Navigator.pushNamed(context, '/searchpage');
    } else if (index == 2) {
      print('Navigating to Cart');
      Navigator.pushNamed(context, '/cartpage');
    } else if (index == 3) {
      print('Navigating to Profile');
      Navigator.pushNamed(context, '/profilepage');
    }
  }


  @override
  void initState() {
    super.initState();

    _loadPreferences();
  }


  void _onLanguageSelected(String language) {
    setState(() {
      _selectedLanguage = language;
    });

    _saveLanguagePreference(language);
  }


  void _toggleNotifications(bool isEnabled) {
    setState(() {
      _isNotificationsEnabled = isEnabled;
    });

    _saveNotificationsPreference(isEnabled);
  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
      _isNotificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }


  Future<void> _saveLanguagePreference(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
  }


  Future<void> _saveNotificationsPreference(bool isEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', isEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        toolbarHeight: 120.0,
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: Image.asset(
            'assets/tradin.png',
            height: 80.0,
            width: 80.0,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text('Selected language: $_selectedLanguage'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Select Language'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text('English'),
                          onTap: () {
                            _onLanguageSelected('English');
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Spanish'),
                          onTap: () {
                            _onLanguageSelected('Spanish');
                            Navigator.pop(context);
                          },
                        ),
                        // Add more language options here
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            subtitle: Text(_isNotificationsEnabled ? 'Enabled' : 'Disabled'),
            onTap: () {
              _toggleNotifications(!_isNotificationsEnabled);
            },
          ),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[800],
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
