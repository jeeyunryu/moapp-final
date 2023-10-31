import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shrine/app.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('Favorite Hotels',
                style: TextStyle(color: Colors.white)),
          ),
          body: Container(
            alignment: Alignment.center,
            child: Text('No favorites yet.'),
          ));
    } else
      return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            centerTitle: true,
            title: const Text('Favorite Hotels',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.blue,
          ),
          body: Column(children: [
            for (var hotel in appState.favorites)
              Dismissible(
                  background: Container(
                    color: Colors.red,
                  ),
                  key: Key(hotel.name),
                  onDismissed: (direction) {
                    appState.favorites.remove(hotel);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                        title: Text(hotel.name,
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ))
          ]));
  }
}
