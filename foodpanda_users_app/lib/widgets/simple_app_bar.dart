import 'package:flutter/material.dart';


class SimpleAppBar extends StatelessWidget with PreferredSizeWidget
{
  String? title;
  final PreferredSizeWidget? bottom;

  SimpleAppBar({this.bottom, this.title});

  @override
  Size get preferredSize => bottom==null?Size(56, AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context)
  {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
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
              tileMode: TileMode.clamp),
        ),
      ),
      centerTitle: true,
      title: Text(
        title!,
        style: const TextStyle(fontSize: 30.0, letterSpacing: 3, color: Colors.black,),
      ),
    );
  }
}
