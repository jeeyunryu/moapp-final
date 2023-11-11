import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'addProduct.dart';
import 'app_state.dart';

class EditPage extends StatefulWidget {
  EditPage({super.key, required this.product});

  final ProductList product;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late Product product_local =
      Product(name: '', price: 0, description: '', imageurl: '');

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
    _controllername.text = widget.product.name;
    _controllerprice.text = widget.product.price.toString();
    _controllerdescription.text = widget.product.description;

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          centerTitle: true,
          title: const Text(
            'Detail',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          actions: [
            Consumer<ApplicationState>(
                builder: (context, appstate, _) => TextButton(
                      child: const Text('Save'),
                      onPressed: () {
                        product_local.name = _controllername.text;
                        product_local.price = int.parse(_controllerprice.text);
                        product_local.description = _controllerdescription.text;
                        if (_image != null) {
                          product_local.imageurl = _image!.path;
                        }
                        appstate.editProduct(product_local, widget.product);
                        Navigator.pop(context);
                      },
                    ))
          ],
        ),
        body: ListView(
          children: [
            _buildPhotoArea(),
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () {
                getImage(ImageSource.gallery);
              },
            ),
            TextFormField(controller: _controllername),
            TextFormField(controller: _controllerprice),
            // Text(widget.product.name),

            Divider(color: Colors.black, thickness: 0.7),
            TextFormField(controller: _controllerdescription),
          ],
        ));
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? Container(
            width: 300,
            height: 300,
            child: Image.file(File(_image!.path)),
          )
        : widget.product.imageurl != ''
            ? Image.file(File(widget.product.imageurl))
            : Image.asset('assets/logo.png');
  }
}
