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
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          centerTitle: true,
          title: const Text(
            'Detail',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: <Widget>[
            Hero(
              tag: hotel.name,
              child: Material(
                  child: InkWell(
                child: Container(
                  // height: 300,
                  child: Image.asset(
                    // fit: BoxFit.fitWidth,
                    hotel.imagePath,
                  ),
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
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10.0, 0, 8.0),
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
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 4,
                  pause: const Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                      ),
                    ),
                    Container(
                      width: 250,
                      child: Text(hotel.address,
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: const Icon(
                        Icons.phone_enabled,
                        color: Colors.blue,
                      ),
                    ),
                    Text(hotel.phone, style: TextStyle(color: Colors.blue)),
                  ]),
                ),
                Divider(color: Colors.black, thickness: 0.7),
                Text(
                  hotel.description,
                  style: TextStyle(color: Colors.blue),
                )
              ],
            ),
          )
        ])));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final List<String> hotelNames = <String>[
  'Polonia hotel',
  'Gyeongju Hilton',
  'The Westin Grand Berlin',
  'Marina Bay Sands Hotel',
  'Shila Hotel',
  'Avanti Cove',
];

final List<String> listOfAddress = <String>[
  'al. Jerozolimskie 45, 00-692 Warszawa',
  '484-7 Bomun-ro Gyeongju-si Gyeongsangbuk-do KR',
  'FriedreichstraBe 158/164, 10117 Berlin',
  'I10 Bayfront Ave, 018956',
  'I10 Bayfront Ave, 018956',
  'I10 Bayfront Ave, 018956',
];

final List<String> descriptions = <String>[
  'Hotel Polonia offers all the facilities you would expect from a 3 star hotel in Krakow: restaurant, room service, bar, front desk open 24 hours, laundry, TV. Located in the south east of Krakow, on Basztowa 25, 6 minutes by car from the hotel. Polonia Hotel Room is ALL DOUBLE',
  'Hotel Polonia offers all the facilities you would expect from a 3 star hotel in Krakow: restaurant, room service, bar, front desk open 24 hours, laundry, TV. Located in the south east of Krakow, on Basztowa 25, 6 minutes by car from the hotel. Polonia Hotel Room is ALL DOUBLE',
  'Hotel Polonia offers all the facilities you would expect from a 3 star hotel in Krakow: restaurant, room service, bar, front desk open 24 hours, laundry, TV. Located in the south east of Krakow, on Basztowa 25, 6 minutes by car from the hotel. Polonia Hotel Room is ALL DOUBLE',
  'Hotel Polonia offers all the facilities you would expect from a 3 star hotel in Krakow: restaurant, room service, bar, front desk open 24 hours, laundry, TV. Located in the south east of Krakow, on Basztowa 25, 6 minutes by car from the hotel. Polonia Hotel Room is ALL DOUBLE',
  'Hotel Polonia offers all the facilities you would expect from a 3 star hotel in Krakow: restaurant, room service, bar, front desk open 24 hours, laundry, TV. Located in the south east of Krakow, on Basztowa 25, 6 minutes by car from the hotel. Polonia Hotel Room is ALL DOUBLE',
  'Hotel Polonia offers all the facilities you would expect from a 3 star hotel in Krakow: restaurant, room service, bar, front desk open 24 hours, laundry, TV. Located in the south east of Krakow, on Basztowa 25, 6 minutes by car from the hotel. Polonia Hotel Room is ALL DOUBLE',
];

final List<String> phoneNumbers = <String>[
  '+48 22 318 28 00',
  '+48 22 318 28 00',
  '+48 22 318 28 00',
  '+48 22 318 28 00',
  '+48 22 318 28 00',
  '+48 22 318 28 00',
];

class _HomePageState extends State<HomePage> {
  final List<bool> _selectedView = <bool>[false, true];

  bool isGridView = true;

  final hotels = List.generate(
      6,
      (i) => Hotel(
            hotelNames[i],
            listOfAddress[i],
            phoneNumbers[i],
            descriptions[i],
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        hotel.imagePath,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
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
                  Text(hotel.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Container(
                        width: 130,
                        child: Text(
                          hotel.address,
                        ),
                      ),
                      TextButton(
                        child: const Text('more'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen(hotel: hotel)));
                        },
                      )
                    ],
                  )
                ],
              ),
            ],
          ));
    }).toList();
  }

  List<Card> _buildGridCards(BuildContext context) {
    if (hotels.isEmpty) {
      return const <Card>[];
    }

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
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 10,
                      ),
                    ),
                    Container(
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 4.0, bottom: 0.0),
                            child: Row(children: [
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
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              hotel.name,
                              // style: theme.textTheme.bodySmall,
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),

                              maxLines: 1,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 35,
                                child: Text(
                                  hotel.address,
                                  style: TextStyle(fontSize: 4),
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
                                            builder: (context) =>
                                                DetailScreen(hotel: hotel)));
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
                    leading: const Icon(Icons.location_city,
                        color: Colors.lightBlue),
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
                  Icons.menu,
                  semanticLabel: 'menu',
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
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
                Icons.search,
                semanticLabel: 'search',
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.language,
                semanticLabel: 'language',
                color: Colors.white,
              ),
              onPressed: _launchUrl,
            ),
          ],
        ),
        body: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0, top: 10.0),
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(5),
                  selectedBorderColor: Colors.blue,
                  selectedColor: Colors.blue,
                  fillColor: Colors.white10,
                  direction: Axis.horizontal,
                  onPressed: (int index) {
                    setState(() {
                      isGridView = index == 1;
                      // for (int i = 0; i < _selectedView.length; i++) {
                      //   _selectedView[i] = i == index;
                      // }
                    });
                  },
                  children: icons,
                  isSelected: [!isGridView, isGridView],
                ),
              ),
            ],
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
                      );
                    })
                  : ListView(
                      padding: const EdgeInsets.all(8),
                      children: _buildListCards(context),
                    )),
        ]));
  }
}
