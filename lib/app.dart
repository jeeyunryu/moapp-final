// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'login.dart';
import 'signup.dart';
import 'search.dart';
import 'favorites.dart';
import 'profile.dart';
import 'addProduct.dart';
import 'wishlist.dart';

class MyAppState extends ChangeNotifier {
  var favorites = <Hotel>[];

  void toggleFavorite([Hotel? hotel]) {
    if (favorites.contains(hotel)) {
      favorites.remove(hotel);
    } else {
      favorites.add(hotel!);
    }
    notifyListeners();
  }
}

// TODO: Convert ShrineApp to stateful widget (104)
class ShrineApp extends StatelessWidget {
  const ShrineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp(
          title: 'Shrine',
          initialRoute: '/login',
          routes: {
            '/login': (BuildContext context) => const LoginPage(),
            '/': (BuildContext context) => const HomePage(),
            '/signUp': (BuildContext context) => const SignUpPage(),
            '/search': (BuildContext context) => const SearchPage(),
            '/favorites': (BuildContext context) => const FavoritePage(),
            '/profile': (BuildContext context) => const MyPage(),
            '/addProduct': (BuildContext context) => const AddProduct(),
            '/wish': (BuildContext context) => const WishlistPage(),
          },
          // TODO: Customize the theme (103)
          theme: ThemeData.light(useMaterial3: true),
        ));
  }
}

// TODO: Build a Shrine Theme (103)
// TODO: Build a Shrine Text Theme (103)
