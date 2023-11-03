// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_key_in_widget_constructors


import 'package:flutter/material.dart';

class ProductForm extends StatefulWidget {
  final Function(String name, double price, String imageUrl) onProductAdded;

  ProductForm({required this.onProductAdded});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  String _imageUrlError = '';
  String _formErrorMessage = ''; // Store the form-level error message
  bool _hasSubmitted = false; // Flag to track whether the form has been submitted

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _nameController, // Use the same controller for _nameController
            decoration: InputDecoration(
              labelText: 'Product Name',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(
              labelText: 'Product Price',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _imageUrlController, // Use the same controller for _nameController
            decoration: InputDecoration(
              labelText: 'Image URL',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),

          SizedBox(height: 16.0),
          Text(
            _hasSubmitted ? _formErrorMessage : '', // Display the form-level error message after submission
            style: TextStyle(color: Colors.red),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text;
              final price = double.tryParse(_priceController.text) ?? 0.0;
              final imageUrl = _imageUrlController.text;

              if (name.isEmpty || price == 0.0 || imageUrl.isEmpty) {
                setState(() {
                  _formErrorMessage = 'Please fill in all fields';
                  _hasSubmitted = true;
                });
              } else {
                setState(() {
                  _formErrorMessage = ''; // Clear the error message
                  _hasSubmitted = false;
                });

                // Close the keyboard and remove focus from text fields
                FocusScope.of(context).unfocus();

                widget.onProductAdded(name, price, imageUrl);
                _nameController.clear();
                _priceController.clear();
                _imageUrlController.clear();
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.redAccent[100]),
            ),
            child: Text(
              'Add Product',
              style: TextStyle(color: Colors.white),
            ),
          ),



        ],
      ),
    );
  }
}
