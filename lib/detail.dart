import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'edit.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({super.key, required this.product});

  // final Hotel hotel;
  final ProductList product;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    IconData icon;

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
            IconButton(
              icon: Icon(Icons.create),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditPage(product: widget.product)));
              },
            ),
            Consumer<ApplicationState>(
              builder: (context, appState, _) => IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  appState.deleteProduct(widget.product);
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
        body: ListView(
          children: [
            widget.product.imageurl != ''
                ? Image.file(File(widget.product.imageurl))
                : Image.asset('assets/logo.png'),
            Row(
              children: [
                Expanded(
                  child: Text(widget.product.name),
                ),
                Consumer<ApplicationState>(
                  builder: (context, appState, _) => IconButton(
                    icon: appState.isLiked(widget.product)
                        ? Icon(Icons.thumb_up, color: Colors.red)
                        : Icon(Icons.thumb_up_outlined, color: Colors.red),
                    onPressed: () {
                      if (!appState.isLiked(widget.product)) {
                        appState.likesIncrement(widget.product);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('I LIKE IT!')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('You can only do it once !!')));
                      }
                    },
                  ),
                ),
                Text(widget.product.likes.toString()),
              ],
            ),
            Text('\$ ' + widget.product.price.toString()),
            Divider(color: Colors.black, thickness: 0.7),
            Text(
              widget.product.description,
              style: TextStyle(color: Colors.blue),
            ),
            Text('creator:  ${widget.product.uid}'),
            Text(
                '${DateTime.fromMillisecondsSinceEpoch(widget.product.timestamp)} Created'),
            if (widget.product.editedtime != 0)
              Text(
                  '${DateTime.fromMillisecondsSinceEpoch(widget.product.editedtime)} Modified'),
          ],
        ));
  }
}
