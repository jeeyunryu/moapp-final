import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

List<Widget> _listcards(
    BuildContext context, List<ProductInWishlist> wishlist) {
  return wishlist.map((wish) {
    return Card(
      child: Row(
        children: [
          (wish.imageurl != '')
              ? Image.file(width: 100, height: 100, File(wish.imageurl))
              : Image.asset('assets/logo.png'),
          Expanded(child: Text(wish.name)),
          Consumer<ApplicationState>(builder: (context, appState, _) {
            return IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                appState.deleteFromWishlist(wish);
              },
            );
          })
        ],
      ),
    );
  }).toList();
}

class WishlistPage extends StatelessWidget {
  const WishlistPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      return Scaffold(
        appBar: AppBar(title: const Text('Wish List')),
        body: ListView(
          children: _listcards(context, appState.wishlist),
        ),
      );
    });
  }
}
