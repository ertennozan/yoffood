import 'package:flutter/material.dart';

import 'login.dart';
import 'register.dart';



class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}


class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                 colors: [
                Colors.yellow,
                Colors.red,
              ],
              begin: FractionalOffset(0.5, 0.0),
              end: FractionalOffset(1.0, .0),
              stops: [0.0, 0.5],
                tileMode: TileMode.clamp,
              )
            ),
          ),
          automaticallyImplyLeading: false,
          title: const Text(
              "YOF FOOD",
            style: TextStyle(
              fontSize: 50,
              color: Colors.white,
              
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.lock, color: Colors.white,),
                text: "GİRİŞ",
              ),
              Tab(
                icon: Icon(Icons.person, color: Colors.white,),
                text: "KAYIT OL",
              ),
            ],
            indicatorColor: Colors.white38,
            indicatorWeight: 6,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              
             colors: [
                Colors.yellow,
                Colors.red,
              ],
              begin: FractionalOffset(0.5, 0.0),
              end: FractionalOffset(1.0, .0),
              stops: [0.0, 0.5],
                tileMode: TileMode.clamp,
            )
          ),
          child: const TabBarView(
            children: [
              LoginScreen(),
              RegisterScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
