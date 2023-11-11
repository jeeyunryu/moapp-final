import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'app_state.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class Product {
  String name;
  int price;
  String description;
  String imageurl;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.imageurl,
  });
}

Product product = Product(description: '', name: '', price: 0, imageurl: '');

class _AddProductState extends State<AddProduct> {
  final _controllername = TextEditingController();
  final _controllerprice = TextEditingController();
  final _controllerdescription = TextEditingController();

  XFile? _image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add'),
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        actions: [
          Consumer<ApplicationState>(
            builder: (context, appState, _) => TextButton(
              onPressed: () {
                product.name = _controllername.text;
                product.price = int.parse(_controllerprice.text);
                product.description = _controllerdescription.text;
                if (_image != null) {
                  product.imageurl = _image!.path;
                } else {
                  product.imageurl = '';
                }
                appState.addProduct(product);
                _controllername.clear();
                _controllerprice.clear();
                _controllerdescription.clear();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          )
        ],
      ),
      body: ListView(children: [
        Consumer<ApplicationState>(
            builder: (context, appState, _) => Form(
                  child: Column(
                    children: [
                      _buildPhotoArea(),
                      Container(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                              onPressed: () {
                                getImage(ImageSource.gallery);
                              },
                              icon: const Icon(Icons.camera_alt))),
                      TextFormField(
                        controller: _controllername,
                        decoration:
                            const InputDecoration(hintText: 'Product Name'),
                      ),
                      TextFormField(
                        controller: _controllerprice,
                        decoration: const InputDecoration(hintText: 'Price'),
                      ),
                      TextFormField(
                        controller: _controllerdescription,
                        decoration:
                            const InputDecoration(hintText: 'Description'),
                      ),
                    ],
                  ),
                )),
      ]),
    );
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? Container(
            width: 300,
            height: 300,
            child: Image.file(File(_image!.path)),
          )
        : Container(
            width: 300,
            height: 300,
            child: Image.asset('assets/logo.png'),
          );
  }
}
