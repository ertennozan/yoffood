import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_riders_app/assistantMethods/get_current_location.dart';
import 'package:foodpanda_riders_app/authentication/auth_screen.dart';
import 'package:foodpanda_riders_app/global/global.dart';
import 'package:foodpanda_riders_app/mainScreens/earnings_screen.dart';
import 'package:foodpanda_riders_app/mainScreens/history_screen.dart';
import 'package:foodpanda_riders_app/mainScreens/new_orders_screen.dart';
import 'package:foodpanda_riders_app/mainScreens/not_yet_delivered_screen.dart';
import 'package:foodpanda_riders_app/mainScreens/parcel_in_progress_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen>
{
  Card makeDashboardItem(String title, IconData iconData, int index)
  {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.amber,
                Colors.cyan,
              ],
              begin:  FractionalOffset(0.0, 0.0),
              end:  FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        )
            : const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.redAccent,
                Colors.amber,
              ],
              begin:  FractionalOffset(0.0, 0.0),
              end:  FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: InkWell(
          onTap: ()
          {
            if(index == 0)
            {
              //New Available Orders
              Navigator.push(context, MaterialPageRoute(builder: (c)=> NewOrdersScreen()));
            }
            if(index == 1)
            {
              //Parcels in Progress
              Navigator.push(context, MaterialPageRoute(builder: (c)=> ParcelInProgressScreen()));
            }
            if(index == 2)
            {
              //Not Yet Delivered
              Navigator.push(context, MaterialPageRoute(builder: (c)=> NotYetDeliveredScreen()));
            }
            if(index == 3)
            {
              //History
              Navigator.push(context, MaterialPageRoute(builder: (c)=> HistoryScreen()));
            }
            if(index == 4)
            {
              //Total Earnings
              Navigator.push(context, MaterialPageRoute(builder: (c)=> EarningsScreen()));
            }
            if(index == 5)
            {
              //Logout
              firebaseAuth.signOut().then((value){
                Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50.0),
              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10.0),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();
    getPerParcelDeliveryAmount();
    getRiderPreviousEarnings();
  }


  getRiderPreviousEarnings()
  {
    FirebaseFirestore.instance
        .collection("riders")
        .doc(sharedPreferences!.getString("uid"))
        .get().then((snap)
    {
      previousRiderEarnings = snap.data()!["earnings"].toString();
    });
  }
  
  getPerParcelDeliveryAmount()
  {
    FirebaseFirestore.instance
        .collection("perDelivery")
        .doc("riderpay")
        .get().then((snap)
    {
       perParcelDeliveryAmount = snap.data()!["amount"].toString();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.amber,
                ],
                begin:  FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        title: Text(
          "Hoş Geldin " +
          sharedPreferences!.getString("name")!,
          style: const TextStyle(
            fontSize: 25.0,
            color: Colors.black,
            fontFamily: "Acme",
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/back.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 1),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(2),
          children: [
            makeDashboardItem("Yeni Siparişler", Icons.assignment, 0),
            makeDashboardItem("Kabul Edilen Siparişler", Icons.airport_shuttle, 1),
            makeDashboardItem("   Teslim Edilmemiş"+"\n"+"          Siparişler", Icons.location_history, 2),
            makeDashboardItem("Geçmiş Siparişler", Icons.done_all, 3),
            makeDashboardItem("Toplam Kazanç", Icons.monetization_on, 4),
            makeDashboardItem("Çıkış Yap", Icons.logout, 5),
          ],
        ),
      ),
    );
  }
}
