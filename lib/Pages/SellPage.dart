import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final CollectionReference productsCollection =
  FirebaseFirestore.instance.collection('products');

  String productName = '';
  String itemTransactionType = '';
  String price = '';
  String tradeItem = "";
  String description = '';
  String city = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  File? _image;
  final picker = ImagePicker();

  int _selectedIndex = 0;

  bool _nameIsEmpty = false;
  bool _priceIsEmpty = false;
  bool _descriptionIsEmpty = false;
  bool _cityIsEmpty = false;
  bool _isForTrade = false;
  bool _isForSell = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/searchpage');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/cartpage');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/profilepage');
    }
  }

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void checkEmptyTextFields() {
    setState(() {
      _nameIsEmpty = productName.isEmpty;
      if (_isForTrade) {
        _priceIsEmpty = tradeItem.isEmpty;
      } else {
        _priceIsEmpty = price.isEmpty;
      }
      _descriptionIsEmpty = description.isEmpty;
      _cityIsEmpty = city.isEmpty;
    });
  }

  Future<void> uploadProduct() async {
    if (_image != null &&
        user != null &&
        productName.isNotEmpty &&
        description.isNotEmpty &&
        city.isNotEmpty &&
        (!_nameIsEmpty &&
            !_priceIsEmpty &&
            !_descriptionIsEmpty &&
            !_cityIsEmpty)) {
      Reference storageReference =
      FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');
      UploadTask uploadTask = storageReference.putFile(_image!);

      await uploadTask.whenComplete(() async {
        final fileURL = await storageReference.getDownloadURL();
        await productsCollection.add({
          'imageUrl': fileURL,
          'userId': user!.uid,
          'name': productName,
          'description': description,
          'itemTransactionType': _isForSell ? 'Sell' : 'Trade',
          _isForSell ? 'price' : 'tradeItem': _isForSell ? price : tradeItem,
          'city': city,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item uploaded successfully'),
          ),
        );

        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushNamed(context, '/home');
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sellers Form to Sell your Items'),
        ),
      );
    }
  }

  Future<void> cancelUpload() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Upload Cancelled'),
      ),
    );
    Future.delayed(Duration(seconds: 0), () {
      Navigator.pushNamed(context, '/home');
    });
  }


  TextFormField buildTextFormField({
    required String labelText,
    required bool isEmpty,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: isEmpty ? 'Enter $labelText' : null,
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isEmpty ? Colors.red : Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text('S E L L'),
        centerTitle: true,
        backgroundColor: Colors.red[200],
        toolbarHeight: 100.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20.0),
              const Text(
                "Fill In The Information",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30.0),
              buildTextFormField(
                labelText: 'Product Name',
                isEmpty: _nameIsEmpty,
                onChanged: (value) {
                  setState(() {
                    productName = value;
                    _nameIsEmpty = productName.isEmpty;
                  });
                },
              ),
              const SizedBox(height: 15.0),
              CheckboxListTile(
                title: Text('Sell'),
                value: _isForSell,
                onChanged: (value) {
                  setState(() {
                    _isForSell = value!;
                    _isForTrade = !value;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Trade'),
                value: _isForTrade,
                onChanged: (value) {
                  setState(() {
                    _isForTrade = value!;
                    _isForSell = !value;
                  });
                },
              ),
              const SizedBox(height: 15.0),
              !_isForTrade
                  ? buildTextFormField(
                labelText: 'Price',
                isEmpty: _priceIsEmpty,
                onChanged: (value) {
                  setState(() {
                    price = value;
                    _priceIsEmpty = price.isEmpty;
                  });
                },
              )
                  : buildTextFormField(
                labelText: 'Item Wanted',
                isEmpty: _priceIsEmpty,
                onChanged: (value) {
                  setState(() {
                    tradeItem = value;
                    _priceIsEmpty = tradeItem.isEmpty;
                  });
                },
              ),
              const SizedBox(height: 15.0),
              buildTextFormField(
                labelText: 'Description',
                isEmpty: _descriptionIsEmpty,
                onChanged: (value) {
                  setState(() {
                    description = value;
                    _descriptionIsEmpty = description.isEmpty;
                  });
                },
              ),
              const SizedBox(height: 15.0),
              buildTextFormField(
                labelText: 'City',
                isEmpty: _cityIsEmpty,
                onChanged: (value) {
                  setState(() {
                    city = value;
                    _cityIsEmpty = city.isEmpty;
                  });
                },
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          getImage(ImageSource.camera);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                        child: Icon(Icons.camera_alt, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text('Open Camera'),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                        child: Icon(Icons.photo_library, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text('Upload from gallery'),
                    ],
                  ),
                  const SizedBox(width: 20),
                  _image == null
                      ? const Text('No image selected.')
                      : Image.file(_image!, width: 100, height: 100),
                ],
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        checkEmptyTextFields();
                        uploadProduct();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red[300],
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Center(
                        child: Text(
                          'Upload Product',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: cancelUpload,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey[400],
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/sellerslist');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Go to Sellers List'),
              ),
            ],
          ),
        ),
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