import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:foodpanda_users_app/assistantMethods/assistant_methods.dart';
import 'package:foodpanda_users_app/global/global.dart';
import 'package:foodpanda_users_app/models/menus.dart';
import 'package:foodpanda_users_app/models/sellers.dart';
import 'package:foodpanda_users_app/splashScreen/splash_screen.dart';
import 'package:foodpanda_users_app/widgets/menus_design.dart';
import 'package:foodpanda_users_app/widgets/sellers_design.dart';
import 'package:foodpanda_users_app/widgets/my_drawer.dart';
import 'package:foodpanda_users_app/widgets/progress_bar.dart';
import 'package:foodpanda_users_app/widgets/text_widget_header.dart';
import 'package:staggered_grid_view_flutter/widgets/sliver.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';


class MenusScreen extends StatefulWidget
{
  final Sellers? model;
  MenusScreen({this.model});

  @override
  _MenusScreenState createState() => _MenusScreenState();
}



class _MenusScreenState extends State<MenusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: ()
          {
            clearCartNow(context);

            Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
          },
        ),
        title: const Text(
          "YOF FOOD",
          style: TextStyle(fontSize: 45, fontFamily: "Acme",color: Colors.black),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: widget.model!.sellerName.toString() + " Menüler",),),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(widget.model!.sellerUID)
                .collection("menus")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                child: Center(child: circularProgress(),),
              )
                  : SliverStaggeredGrid.countBuilder(
                crossAxisCount: 1,
                staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                itemBuilder: (context, index)
                {
                  Menus model = Menus.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );
                  return MenusDesignWidget(
                    model: model,
                    context: context,
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            },
          ),
        ],
      ),
    );
  }
}
