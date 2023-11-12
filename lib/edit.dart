import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'addProduct.dart';
import 'app_state.dart';

class EditPage extends StatefulWidget {
  EditPage({super.key, required this.productId});

  final String productId;

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
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      final product = appState.products
          .firstWhere((element) => element.docid == widget.productId);

      _controllername.text = product.name;
      _controllerprice.text = product.price.toString();
      _controllerdescription.text = product.description;

      // final appstate = context.read<ApplicationState>();
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
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  product_local.name = _controllername.text;
                  product_local.price = int.parse(_controllerprice.text);
                  product_local.description = _controllerdescription.text;
                  if (_image != null) {
                    product_local.imageurl = _image!.path;
                  }
                  appState.editProduct(product_local, product);
                  Navigator.pop(context);
                },
              )
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
    });
  }

  Widget _buildPhotoArea() {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      final product = appState.products
          .firstWhere((element) => element.docid == widget.productId);
      return _image != null
          ? Container(
              width: 300,
              height: 300,
              child: Image.file(File(_image!.path)),
            )
          : product.imageurl != ''
              ? Image.file(File(product.imageurl))
              : Image.asset('assets/logo.png');
    });
  }
}
