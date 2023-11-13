import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

class LikedProduct {
  LikedProduct({
    required this.docid,
  });
  String docid;
}

class ProductInWishlist {
  ProductInWishlist({
    required this.name,
    required this.imageurl,
    required this.productdocid,
    required this.docid,
  });
  String name;
  String imageurl;
  String productdocid;
  String docid;
}

class ApplicationState extends ChangeNotifier {
  StreamSubscription<QuerySnapshot>? _productListSubscription;
  List<ProductList> _products = [];
  List<ProductList> get products => _products;
  List<LikedProduct> _likedproducts = [];
  List<LikedProduct> get likedproducts => _likedproducts;
  bool _isDesc = false;
  bool get isDesc => _isDesc;
  set isDesc(bool isDesc) {
    _isDesc = isDesc;
  }

  List<ProductInWishlist> _wishlist = [];
  List<ProductInWishlist> get wishlist => _wishlist;

  String _email = 'Anonymous';
  String get email => _email;
  String _imageurl = 'https://handong.edu/site/handong/res/img/logo.png';
  String get imageurl => _imageurl;

  ApplicationState() {
    init();
  }

  void addProduct(Product product) {
    int _products = 0;
    // int get products => _products;

    FirebaseFirestore.instance.collection('products').add(<String, dynamic>{
      'name': product.name,
      'price': product.price,
      'description': product.description,
      'imageurl': product.imageurl,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'editedtime': 0,
      'likes': 0,
    }).then((DocumentReference) async {
      final storageRef = FirebaseStorage.instance.ref();
      final photoRef = storageRef.child("images/${product.imageurl}");
      String filePath = product.imageurl;
      File file = File(filePath);
      await photoRef.putFile(file);
    });

//     try {
//   await photoRef.putFile(file);
// } on firebase_core.FirebaseException catch (e) {
//   // ...
// }
  }

  Future<void> editProduct(Product productLocal, ProductList product) async {
    print('edit');
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

  Future<void> likesIncrement(ProductList product) async {
    FirebaseFirestore.instance
        .collection('products')
        .doc(product.docid)
        .update({
      'likes': product.likes++,
    });

    FirebaseFirestore.instance.collection('likes').add(<String, dynamic>{
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'docid': product.docid,
    });
  }

  Future<void> deleteProduct(ProductList product) async {
    if (FirebaseAuth.instance.currentUser!.uid == product.uid) {
      FirebaseFirestore.instance
          .collection("products")
          .doc(product.docid)
          .delete()
          .then(
        (doc) {
          for (var wish in wishlist) {
            if (wish.productdocid == product.docid) {
              deleteFromWishlist(wish);
            }
          }
          return print("Document deleted");
        },
        onError: (e) => print("Error updating document $e"),
      );
    }
  }

  void deleteFromWishlist(ProductInWishlist wish) {
    FirebaseFirestore.instance.collection('wishlist').doc(wish.docid).delete();
  }

  void changeOrder() {
    FirebaseFirestore.instance
        .collection('products')
        .orderBy('price', descending: isDesc)
        .snapshots()
        .listen((snapshot) {
      print('init.listen: iscalled!');
      _products = [];
      for (final document in snapshot.docs) {
        final name = document.data()['name'];
        print('init.listen: $name');
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

  void addToWishlist(ProductList product) {
    FirebaseFirestore.instance.collection('wishlist').add(<String, dynamic>{
      'name': product.name,
      'imageurl': product.imageurl,
      'productdocid': product.docid,
      'uid': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> init() async {
    print('init.init');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseFirestore.instance
        .collection('products')
        .orderBy('price', descending: isDesc)
        .snapshots()
        .listen((snapshot) {
      print('init.listen: iscalled!');
      _products = [];
      for (final document in snapshot.docs) {
        final name = document.data()['name'];
        print('init.listen: $name');
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

    FirebaseFirestore.instance
        .collection('likes')
        .snapshots()
        .listen((snapshot) {
      _likedproducts = [];
      for (final document in snapshot.docs) {
        if (FirebaseAuth.instance.currentUser!.uid == document.data()['uid']) {
          _likedproducts.add(LikedProduct(
            docid: document.data()['docid'] as String,
          ));
        }
      }
      print(_likedproducts);
      notifyListeners();
    });

    FirebaseAuth.instance.userChanges().listen((user) {
      bool isSaved = false;

      if (user != null) {
        if (user.email != null) {
          _email = user.email!;
        } else {
          _email = 'Anonymous';
        }

        if (user.photoURL != null) {
          _imageurl = user.photoURL!;
        } else {
          _imageurl = 'https://handong.edu/site/handong/res/img/logo.png';
        }

        print('email: ${user.email}');
        print('image url: ${user.photoURL}');

        FirebaseFirestore.instance
            .collection('user')
            .snapshots()
            .listen((snapshot) {
          for (final document in snapshot.docs) {
            if (user.uid == document.data()['uid']) {
              isSaved = true;
            }
          }
          if (!isSaved) {
            if (user.email != null) {
              final docdata = {
                'name': user.displayName,
                'email': user.email,
                'status_message':
                    'I promise to take the test honestly before GOD.',
                'uid': FirebaseAuth.instance.currentUser!.uid,
              };
              FirebaseFirestore.instance
                  .collection('user')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .set(docdata)
                  .onError((e, _) => print("Error writing document: $e"));
              ;
            } else {
              final docdata = {
                'status_message':
                    'I promise to take the test honestly before GOD.',
                'uid': FirebaseAuth.instance.currentUser!.uid,
              };
              FirebaseFirestore.instance
                  .collection('user')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .set(docdata)
                  .onError((e, _) => print("Error writing document: $e"));
              ;
            }
          }
        });

        FirebaseFirestore.instance
            .collection('wishlist')
            .snapshots()
            .listen((snapshot) {
          _wishlist = [];
          for (final document in snapshot.docs) {
            if (FirebaseAuth.instance.currentUser!.uid ==
                document.data()['uid']) {
              _wishlist.add(
                ProductInWishlist(
                  name: document.data()['name'] as String,
                  imageurl: document.data()['imageurl'] as String,
                  productdocid: document.data()['productdocid'] as String,
                  docid: document.id,
                ),
              );
            }
          }
          notifyListeners();
          // print(_products);
        });

        FirebaseFirestore.instance
            .collection('likes')
            .snapshots()
            .listen((snapshot) {
          _likedproducts = [];
          for (final document in snapshot.docs) {
            if (FirebaseAuth.instance.currentUser!.uid ==
                document.data()['uid']) {
              _likedproducts.add(LikedProduct(
                docid: document.data()['docid'] as String,
              ));
            }
          }
          print(_likedproducts);
          notifyListeners();
        });

        // _productListSubscription = FirebaseFirestore.instance
        //     .collection('products')
        //     .orderBy('price', descending: isDesc)
        //     .snapshots()
        //     .listen((snapshot) {
        //   _products = [];
        //   for (final document in snapshot.docs) {
        //     _products.add(
        //       ProductList(
        //         name: document.data()['name'] as String,
        //         price: document.data()['price'] as int,
        //         description: document.data()['description'] as String,
        //         imageurl: document.data()['imageurl'] as String,
        //         docid: document.id,
        //         uid: document.data()['uid'] as String,
        //         timestamp: document.data()['timestamp'] as int,
        //         editedtime: document.data()['editedtime'] as int,
        //         likes: document.data()['likes'] as int,
        //       ),
        //     );
        //   }
        //   notifyListeners();
        //   // print(_products);
        // });
      }
    });
  }
}
