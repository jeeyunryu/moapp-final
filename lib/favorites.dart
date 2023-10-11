import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shrine/app.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Favorite Hotels'),
          ),
          body: Container(
            alignment: Alignment.center,
            child: Text('No favorites yet.'),
          ));
    } else
      return Scaffold(
          appBar: AppBar(
            title: const Text('Favorite Hotels'),
            backgroundColor: Colors.blue,
          ),
          body: Column(children: [
            for (var hotel in appState.favorites)
              Dismissible(
                  key: Key(hotel.name),
                  onDismissed: (direction) {
                    appState.favorites.remove(hotel);
                  },
                  child: ListTile(
                      title: Text(
                    hotel.name,
                  )))
          ]));
  }
}
