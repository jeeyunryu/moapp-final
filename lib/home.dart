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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shrine/app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'detail.dart';
import 'model/product.dart';
import 'model/products_repository.dart';

const List<String> list = <String>['ASC', 'DESC'];

const List<Widget> icons = <Widget>[
  Icon(Icons.list),
  Icon(Icons.grid_view),
];

class Hotel {
  final String name;
  final String address;
  final String phone;
  final String description;
  final String imagePath;

  const Hotel(
      this.name, this.address, this.description, this.phone, this.imagePath);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  // final List<ProductList> products;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<bool> _selectedView = <bool>[false, true];

  bool isGridView = true;

  List<Card> _buildGridCards(BuildContext context, List<ProductList> products,
      List<LikedProduct> likedproducts) {
    return products.map((product) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Hero(
                tag: product.name,
                child: product.imageurl != ''
                    ? Image.file(File(product.imageurl))
                    : Image.asset('assets/logo.png'),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              product.name,

                              // style: theme.textTheme.bodySmall,
                              style: TextStyle(fontWeight: FontWeight.bold),

                              maxLines: 1,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 35,
                                child: Text(
                                  '\$ ${product.price.toString()}',
                                  // style: TextStyle(fontSize: 4),
                                ),
                              ),
                              Container(
                                height: 35,
                                width: 60,
                                child: TextButton(
                                  child: Text(
                                    'more',
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailScreen(
                                                product: product,
                                                likedproduct: likedproducts)));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  final Uri _url = Uri.parse('https://www.handong.edu/');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
          ),
          child: ListView(padding: EdgeInsets.zero, children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 90, 0, 0),
                child: Text('Pages',
                    style: TextStyle(color: Colors.white, fontSize: 25)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ListTile(
                  leading: const Icon(Icons.home, color: Colors.lightBlue),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pushNamed(context, '/');
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ListTile(
                  leading: const Icon(Icons.search, color: Colors.lightBlue),
                  title: const Text('Search'),
                  onTap: () {
                    Navigator.pushNamed(context, '/search');
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ListTile(
                  leading:
                      const Icon(Icons.location_city, color: Colors.lightBlue),
                  title: const Text('Favorite Hotel'),
                  onTap: () {
                    Navigator.pushNamed(context, '/favorites');
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.lightBlue),
                  title: const Text('My Page'),
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.lightBlue),
                  title: const Text('Log Out'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/login');
                  }),
            ),
          ])),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.person,
                semanticLabel: 'profile',
                color: Colors.white,
              ),
              onPressed: () {
                // Scaffold.of(context).openDrawer();
                Navigator.pushNamed(context, '/profile');
              },
            );
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('Main', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              semanticLabel: 'add',
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/addProduct');
            },
          ),
        ],
      ),
      body:
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.only(right: 18.0, top: 10.0),
          //       child: ToggleButtons(
          //         borderRadius: BorderRadius.circular(5),
          //         selectedBorderColor: Colors.blue,
          //         selectedColor: Colors.blue,
          //         fillColor: Colors.white10,
          //         direction: Axis.horizontal,
          //         onPressed: (int index) {
          //           setState(() {
          //             isGridView = index == 1;
          //             // for (int i = 0; i < _selectedView.length; i++) {
          //             //   _selectedView[i] = i == index;
          //             // }
          //           });
          //         },
          //         children: icons,
          //         isSelected: [!isGridView, isGridView],
          //       ),
          //     ),
          //   ],
          // ),
          Consumer<ApplicationState>(
              builder: (context, appState, _) =>
                  OrientationBuilder(builder: (context, orientation) {
                    return GridView.count(
                        crossAxisCount:
                            orientation == Orientation.portrait ? 2 : 3,
                        padding: const EdgeInsets.all(16.0),
                        childAspectRatio: 8.0 / 9.0,
                        children: _buildGridCards(context, appState.products,
                            appState.likedproducts));
                  })),
    );
  }
}

class StarRank extends StatelessWidget {
  const StarRank({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: 20.0,
        ),
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: 20.0,
        ),
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: 20.0,
        ),
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: 20.0,
        ),
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: 20.0,
        ),
      ],
    );
  }
}
