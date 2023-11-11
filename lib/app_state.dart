import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shrine/firebase_options.dart';

import 'addProduct.dart';

class ProductList {
  ProductList({
    required this.name,
    required this.price,
    required this.description,
    required this.imageurl,
    required this.docid,
    required this.uid,
    required this.timestamp,
    required this.editedtime,
    required this.likes,
  });

  String name;
  int price;
  String description;
  String imageurl;
  String docid;
  String uid;
  int timestamp;
  int editedtime;
  int likes;
}

class ApplicationState extends ChangeNotifier {
  StreamSubscription<QuerySnapshot>? _productListSubscription;
  List<ProductList> _products = [];
  List<ProductList> get products => _products;

  ApplicationState() {
    init();
  }

  bool isLiked(ProductList product) {
    bool result = false;

    FirebaseFirestore.instance
        .collection(product.docid)
        .snapshots()
        .listen((snapshot) {
      for (final document in snapshot.docs) {
        if (FirebaseAuth.instance.currentUser!.uid == document.data()['uid']) {
          result = true;
        }
      }
    });

    return result;
  }

  Future<DocumentReference> addProduct(Product product) {
    int _products = 0;
    // int get products => _products;

    return FirebaseFirestore.instance
        .collection('products')
        .add(<String, dynamic>{
      'name': product.name,
      'price': product.price,
      'description': product.description,
      'imageurl': product.imageurl,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'editedtime': 0,
      'likes': 0,
    });
  }

  Future<void> editProduct(Product productLocal, ProductList product) async {
    if (FirebaseAuth.instance.currentUser!.uid == product.uid) {
      FirebaseFirestore.instance
          .collection('products')
          .doc(product.docid)
          .update({
        'name': productLocal.name,
        'price': productLocal.price,
        'description': productLocal.description,
        if (productLocal.imageurl != '') 'imageurl': productLocal.imageurl,
        'editedtime': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  likesIncrement(ProductList product) {
    FirebaseFirestore.instance
        .collection('products')
        .doc(product.docid)
        .update({
      'likes': product.likes++,
    });

    FirebaseFirestore.instance.collection(product.docid).add(<String, dynamic>{
      'uid': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> deleteProduct(ProductList product) async {
    if (FirebaseAuth.instance.currentUser!.uid == product.uid) {
      FirebaseFirestore.instance
          .collection("products")
          .doc(product.docid)
          .delete()
          .then(
            (doc) => print("Document deleted"),
            onError: (e) => print("Error updating document $e"),
          );
    }
  }

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _productListSubscription = FirebaseFirestore.instance
            .collection('products')
            .snapshots()
            .listen((snapshot) {
          _products = [];
          for (final document in snapshot.docs) {
            _products.add(
              ProductList(
                name: document.data()['name'] as String,
                price: document.data()['price'] as int,
                description: document.data()['description'] as String,
                imageurl: document.data()['imageurl'] as String,
                docid: document.id,
                uid: document.data()['uid'] as String,
                timestamp: document.data()['timestamp'] as int,
                editedtime: document.data()['editedtime'] as int,
                likes: document.data()['likes'] as int,
              ),
            );
          }
          notifyListeners();
          // print(_products);
        });
      }
    });
  }
}
