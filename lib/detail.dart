import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'edit.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.productId,
  });

  // final Hotel hotel;

  final String productId;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // String productId = '';
  // ProductList? product;

  // @override
  // void initState() {
  //   // product = widget.product;
  //   productId = widget.product.docid;
  //   super.initState();
  // }

  // @override
  // void didUpdateWidget(covariant DetailScreen oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   setState(() {
  //     product = widget.product;
  //   });
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    IconData icon;

    return Consumer<ApplicationState>(builder: (context, appState, _) {
      final product = appState.products
          .firstWhere((element) => element.docid == widget.productId);

      bool isLiked() {
        for (var p in appState.likedproducts) {
          if (product.docid == p.docid) {
            return true;
          }
        }
        return false;
      }

      bool isWished = false;

      for (var p in appState.wishlist) {
        if (product.docid == p.productdocid) {
          isWished = true;
        }
      }

      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
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
              icon: const Icon(Icons.create),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditPage(productId: product.docid)));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // for (var p in appState.wishlist) {
                //   if (product.docid == p.docid) {
                //     appState.deleteFromWishlist(p);
                //   }
                // }
                appState.deleteProduct(product);

                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            product.imageurl != ''
                ? Image.file(File(product.imageurl))
                : Image.asset('assets/logo.png'),
            Row(
              children: [
                Expanded(
                  child: Text(product.name),
                ),
                IconButton(
                  icon: isLiked()
                      ? Icon(Icons.thumb_up, color: Colors.red)
                      : Icon(Icons.thumb_up_outlined, color: Colors.red),
                  onPressed: () {
                    if (!isLiked()) {
                      appState.likesIncrement(product);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('I LIKE IT!')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('You can only do it once !!')));
                    }
                  },
                ),
                Text(product.likes.toString()),
              ],
            ),
            Text('\$ ' + product.price.toString()),
            Divider(color: Colors.black, thickness: 0.7),
            Text(
              product.description,
              style: TextStyle(color: Colors.blue),
            ),
            Text('creator:  ${product.uid}'),
            Text(
                '${DateTime.fromMillisecondsSinceEpoch(product.timestamp)} Created'),
            if (product.editedtime != 0)
              Text(
                  '${DateTime.fromMillisecondsSinceEpoch(product.editedtime)} Modified'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (!isWished) {
                appState.addToWishlist(product);
              }
            },
            child: !isWished
                ? const Icon(Icons.shopping_cart)
                : const Icon(Icons.check)),
      );
    });
  }
}
