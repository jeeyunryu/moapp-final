import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, '/login');
            },
          )
        ]),
        body: Column(
          children: [
            Consumer<ApplicationState>(
              builder: (context, appState, _) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: Column(
                  children: [
                    Image.network(appState.imageurl),
                    Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(FirebaseAuth.instance.currentUser!.uid)),
                    Divider(
                      color: Colors.black,
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text('email: ${appState.email}'),
                    ),
                    Container(
                        alignment: Alignment.bottomLeft,
                        child: Text('Jeeyun Ryu')),
                    Text('I promise to take the test honestly before GOD .')
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
