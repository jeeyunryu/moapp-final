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
import 'package:intl/intl.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shrine/app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'model/product.dart';
import 'model/products_repository.dart';

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
      this.name, this.address, this.phone, this.description, this.imagePath);
}

// class MyAppState extends ChangeNotifier {
//   var favorites = <Hotel>[];

//   void toggleFavorite([Hotel? hotel]) {
//     if (favorites.contains(hotel)) {
//       favorites.remove(hotel);
//     } else {
//       favorites.add(hotel!);
//     }
//     notifyListeners();
//   }
// }

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.hotel});

  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    IconData icon;
    if (appState.favorites.contains(hotel)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Detail',
          ),
          backgroundColor: Colors.blue,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: <Widget>[
            Hero(
              tag: hotel.name,
              child: Material(
                  child: InkWell(
                child: Image.asset(
                  hotel.imagePath,
                ),
                onDoubleTap: () {
                  appState.toggleFavorite(hotel);
                },
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Icon(
                  icon,
                  color: Colors.red,
                ),
              ),
            )
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                  child: Row(children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                  ]),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      hotel.name,
                      textStyle: const TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                      speed: const Duration(milliseconds: 2000),
                    ),
                  ],
                  totalRepeatCount: 4,
                  pause: const Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
                // Text(
                //   hotel.name,
                // ),
                Row(children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.blue,
                  ),
                  Text(
                    hotel.address,
                  ),
                ]),
                Row(children: [
                  Icon(
                    Icons.phone,
                    color: Colors.blue,
                  ),
                  Text(
                    hotel.phone,
                  ),
                ]),
                Text('description')
              ],
            ),
          )
        ]));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<bool> _selectedView = <bool>[false, true];

  final hotels = List.generate(
      6,
      (i) => Hotel(
            'Hotel name ${i + 1}',
            'address ${i + 1}',
            'phone ${i + 1}',
            'description ${i + 1}',
            'assets/hotel${i + 1}.jpg',
          ));

  List<Card> _buildListCards(BuildContext context) {
    return hotels.map((hotel) {
      return Card(
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              Container(
                height: 130,
                width: 130,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Hero(
                    tag: hotel.name,
                    child: Image.asset(
                      hotel.imagePath,
                      // fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
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
                  ),
                  Text(
                    hotel.name,
                  ),
                  Text(
                    hotel.address,
                  )
                ],
              ),
              TextButton(
                child: Text('more'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailScreen(hotel: hotel)));
                },
              )
            ],
          ));
    }).toList();
  }

  List<Card> _buildGridCards(BuildContext context) {
    // List<Product> products = ProductsRepository.loadProducts(Category.all);

    if (hotels.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return hotels.map((hotel) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Hero(
                tag: hotel.name,
                child: Image.asset(
                  hotel.imagePath,
                  // package: product.assetPackage,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 10.0,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 10.0,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 10.0,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 10.0,
                      ),
                    ]),
                    Text(
                      hotel.name,
                      // style: theme.textTheme.bodySmall,
                      style: TextStyle(fontSize: 4),
                      maxLines: 1,
                    ),
                    Text(
                      // formatter.format(product.price),

                      hotel.address,
                      style: TextStyle(fontSize: 4),
                      // style: theme.textTheme.bodySmall,
                    ),
                    TextButton(
                      child: Text(
                        'more',
                        // style: DefaultTextStyle.of(context)
                        //     .style
                        //     .apply(fontSizeFactor: 0.9),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(hotel: hotel)));
                      },
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
            child: ListView(padding: EdgeInsets.zero, children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Pages'),
          ),
          ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/');
              }),
          ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search'),
              onTap: () {
                Navigator.pushNamed(context, '/search');
              }),
          ListTile(
              leading: const Icon(Icons.location_city),
              title: const Text('Favorite Hotel'),
              onTap: () {
                Navigator.pushNamed(context, '/favorites');
              }),
          ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Page'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              }),
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              }),
        ])),
        appBar: AppBar(
          // leading: IconButton(
          //   icon: const Icon(
          //     Icons.menu,
          //     semanticLabel: 'menu',
          //   ),
          //   onPressed: () {
          //     print('Menu button');
          //   },
          // ),
          title: const Text('Main'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.search,
                semanticLabel: 'search',
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.language,
                semanticLabel: 'language',
              ),
              onPressed: _launchUrl,
            ),
          ],
        ),
        body: Column(children: [
          ToggleButtons(
            direction: Axis.horizontal,
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < _selectedView.length; i++) {
                  _selectedView[i] = i == index;
                }
              });
            },
            children: icons,
            isSelected: _selectedView,
          ),
          Expanded(
              child: _selectedView[1]
                  ? OrientationBuilder(builder: (context, orientation) {
                      return GridView.count(
                        crossAxisCount:
                            orientation == Orientation.portrait ? 2 : 3,
                        padding: const EdgeInsets.all(16.0),
                        childAspectRatio: 8.0 / 9.0,
                        children: _buildGridCards(context),
                        // children: [
                        //   Expanded(
                        //     child: Card(
                        //         child: Expanded(
                        //             child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: <Widget>[
                        //         AspectRatio(
                        //           aspectRatio: 18 / 11,
                        //           child: Image.asset(
                        //             'assets/hotel1.jpg',
                        //             fit: BoxFit.fill,
                        //           ),
                        //         ),
                        //         Expanded(
                        //             child: Padding(
                        //                 padding: const EdgeInsets.fromLTRB(
                        //                     16.0, 0.0, 16.0, 8.0),
                        //                 child: Column(
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.start,
                        //                     children: <Widget>[
                        //                       const Row(
                        //                         children: [
                        //                           Icon(
                        //                             Icons.star,
                        //                             color: Colors.yellow,
                        //                             size: 15.0,
                        //                           ),
                        //                           Icon(
                        //                             Icons.star,
                        //                             color: Colors.yellow,
                        //                             size: 15.0,
                        //                           ),
                        //                           Icon(Icons.star,
                        //                               color: Colors.yellow,
                        //                               size: 15.0),
                        //                           Icon(Icons.star,
                        //                               color: Colors.yellow,
                        //                               size: 15.0),
                        //                         ],
                        //                       ),
                        //                       const Text(
                        //                         'Polonia hotel',
                        //                         style: TextStyle(
                        //                           fontWeight: FontWeight.bold,
                        //                         ),
                        //                       ),
                        //                       Row(
                        //                         children: [
                        //                           Icon(
                        //                             Icons.location_on,
                        //                           ),
                        //                           Text(
                        //                             'al. Jerozolimskie 45, 00-692 Warszawa',
                        //                             style: DefaultTextStyle.of(
                        //                                     context)
                        //                                 .style
                        //                                 .apply(
                        //                                     fontSizeFactor:
                        //                                         0.77),
                        //                             // textAlign: TextAlign.justify,
                        //                           ),
                        //                         ],
                        //                       ),
                        //                       TextButton(
                        //                           child: const Text('more'),
                        //                           onPressed: () {}),
                        //                     ])))
                        //       ],
                        //     ))),
                        //   ),
                        //   const Card(
                        //       child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: <Widget>[
                        //       Expanded(
                        //           child: Padding(
                        //               padding: EdgeInsets.fromLTRB(
                        //                   16.0, 12.0, 16.0, 8.0),
                        //               child: Column(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.start,
                        //                   children: <Widget>[
                        //                     Text('hello'),
                        //                     SizedBox(height: 8.0),
                        //                     Text('hello'),
                        //                   ])))
                        //     ],
                        //   )),
                        //   const Card(
                        //       child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: <Widget>[
                        //       Expanded(
                        //           child: Padding(
                        //               padding: EdgeInsets.fromLTRB(
                        //                   16.0, 12.0, 16.0, 8.0),
                        //               child: Column(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.start,
                        //                   children: <Widget>[
                        //                     Text('hello'),
                        //                     SizedBox(height: 8.0),
                        //                     Text('hello'),
                        //                   ])))
                        //     ],
                        //   )),
                        //   const Card(
                        //       child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: <Widget>[
                        //       Expanded(
                        //           child: Padding(
                        //               padding: EdgeInsets.fromLTRB(
                        //                   16.0, 12.0, 16.0, 8.0),
                        //               child: Column(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.start,
                        //                   children: <Widget>[
                        //                     Text('hello'),
                        //                     SizedBox(height: 8.0),
                        //                     Text('hello'),
                        //                   ])))
                        //     ],
                        //   )),
                        //   const Card(
                        //       child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: <Widget>[
                        //       Expanded(
                        //           child: Padding(
                        //               padding: EdgeInsets.fromLTRB(
                        //                   16.0, 12.0, 16.0, 8.0),
                        //               child: Column(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.start,
                        //                   children: <Widget>[
                        //                     Text('hello'),
                        //                     SizedBox(height: 8.0),
                        //                     Text('hello'),
                        //                   ])))
                        //     ],
                        //   )),
                        //   const Card(
                        //       child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: <Widget>[
                        //       Expanded(
                        //           child: Padding(
                        //               padding: EdgeInsets.fromLTRB(
                        //                   16.0, 12.0, 16.0, 8.0),
                        //               child: Column(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.start,
                        //                   children: <Widget>[
                        //                     Text('hello'),
                        //                     SizedBox(height: 8.0),
                        //                     Text('hello'),
                        //                   ])))
                        //     ],
                        //   ))
                        // ],
                      );
                    })
                  : ListView(
                      padding: const EdgeInsets.all(8),
                      children: _buildListCards(context),
                      // <Widget>[
                      //   Card(
                      //     child: Row(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: <Widget>[
                      //         Expanded(
                      //           child: Image.asset(
                      //             'assets/hotel1.jpg',
                      //             fit: BoxFit.fill,
                      //           ),
                      //         ),
                      //         Expanded(
                      //           child: Padding(
                      //             padding: const EdgeInsets.fromLTRB(
                      //                 16.0, 12.0, 16.0, 8.0),
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: <Widget>[
                      //                 const Row(
                      //                   children: [
                      //                     Icon(
                      //                       Icons.star,
                      //                       color: Colors.yellow,
                      //                     ),
                      //                     Icon(
                      //                       Icons.star,
                      //                       color: Colors.yellow,
                      //                     ),
                      //                     Icon(
                      //                       Icons.star,
                      //                       color: Colors.yellow,
                      //                     ),
                      //                     Icon(
                      //                       Icons.star,
                      //                       color: Colors.yellow,
                      //                     ),
                      //                   ],
                      //                 ),
                      //                 const Text(
                      //                   'Polonia hotel',
                      //                   style: TextStyle(
                      //                     fontWeight: FontWeight.bold,
                      //                   ),
                      //                 ),
                      //                 const SizedBox(height: 8.0),
                      //                 Text(
                      //                   'al. Jerozolimskie 45, 00-692 Warszawa',
                      //                   // textAlign: TextAlign.justify,
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //         Row(
                      //           crossAxisAlignment: CrossAxisAlignment.end,
                      //           children: [
                      //             TextButton(
                      //               child: Padding(
                      //                 padding:
                      //                     const EdgeInsets.only(top: 100.0),
                      //                 child: const Text(
                      //                   'more',
                      //                 ),
                      //               ),
                      //               onPressed: () {},
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      //   Card(
                      //       child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       Expanded(
                      //           child: Padding(
                      //               padding: EdgeInsets.fromLTRB(
                      //                   16.0, 12.0, 16.0, 8.0),
                      //               child: Column(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: <Widget>[
                      //                     Text('hello'),
                      //                     SizedBox(height: 8.0),
                      //                     Text('hello'),
                      //                   ])))
                      //     ],
                      //   )),
                      //   Card(
                      //       child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       Expanded(
                      //           child: Padding(
                      //               padding: EdgeInsets.fromLTRB(
                      //                   16.0, 12.0, 16.0, 8.0),
                      //               child: Column(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: <Widget>[
                      //                     Text('hello'),
                      //                     SizedBox(height: 8.0),
                      //                     Text('hello'),
                      //                   ])))
                      //     ],
                      //   )),
                      //   Card(
                      //       child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       Expanded(
                      //           child: Padding(
                      //               padding: EdgeInsets.fromLTRB(
                      //                   16.0, 12.0, 16.0, 8.0),
                      //               child: Column(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: <Widget>[
                      //                     Text('hello'),
                      //                     SizedBox(height: 8.0),
                      //                     Text('hello'),
                      //                   ])))
                      //     ],
                      //   )),
                      //   Card(
                      //       child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       Expanded(
                      //           child: Padding(
                      //               padding: EdgeInsets.fromLTRB(
                      //                   16.0, 12.0, 16.0, 8.0),
                      //               child: Column(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: <Widget>[
                      //                     Text('hello'),
                      //                     SizedBox(height: 8.0),
                      //                     Text('hello'),
                      //                   ])))
                      //     ],
                      //   )),
                      //   Card(
                      //       child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       Expanded(
                      //           child: Padding(
                      //               padding: EdgeInsets.fromLTRB(
                      //                   16.0, 12.0, 16.0, 8.0),
                      //               child: Column(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: <Widget>[
                      //                     Text('hello'),
                      //                     SizedBox(height: 8.0),
                      //                     Text('hello'),
                      //                   ])))
                      //     ],
                      //   )),
                      // ],
                    )),
        ]
            // resizeToAvoidBottomInset: false,
            ));
  }
}
