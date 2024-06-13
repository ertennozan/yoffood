import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodpanda_users_app/global/global.dart';
import 'package:foodpanda_users_app/models/address.dart';
import 'package:foodpanda_users_app/widgets/simple_app_bar.dart';
import 'package:foodpanda_users_app/widgets/text_field.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class SaveAddressScreen extends StatelessWidget
{
  final _name = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _flatNumber = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _completeAddress = TextEditingController();
  final _locationController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<Placemark>? placemarks;
  Position? position;


  getUserLocationAddress() async
  {
    Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );

    position = newPosition;

    placemarks = await placemarkFromCoordinates(
        position!.latitude, position!.longitude
    );

    Placemark pMark = placemarks![0];

    String fullAddress = '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    _locationController.text = fullAddress;

    _flatNumber.text = '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}';
    _city.text = '${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}';
    _state.text = '${pMark.country}';
    _completeAddress.text = fullAddress;
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: SimpleAppBar(title: "YOF FOOD",),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("KAYDET"),
        icon: const Icon(Icons.save),
        onPressed: ()
        {
          //save address info
          if(formKey.currentState!.validate())
          {
            final model = Address(
              name: _name.text.trim(),
              state: _state.text.trim(),
              fullAddress: _completeAddress.text.trim(),
              phoneNumber: _phoneNumber.text.trim(),
              flatNumber: _flatNumber.text.trim(),
              city: _city.text.trim(),
              lat: position!.latitude,
              lng: position!.longitude,
            ).toJson();
            
            FirebaseFirestore.instance.collection("users")
                .doc(sharedPreferences!.getString("uid"))
                .collection("userAddress")
                .doc(DateTime.now().millisecondsSinceEpoch.toString())
                .set(model).then((value)
            {
              Fluttertoast.showToast(msg: "Yeni Adres Kaydedildi.");
              formKey.currentState!.reset();
            });
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 6,),
            const Align(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Yeni Adresimi Kaydet:",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                  ),
                ),
              ),
            ),

            ListTile(
              leading: const Icon(
                Icons.person_pin_circle,
                color: Colors.black,
                size: 35,
              ),
              title: Container(
                width: 250,
                child: TextField(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  controller: _locationController,
                  decoration: const InputDecoration(
                    hintText: "Adresiniz Nedir?",
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6,),

            ElevatedButton.icon(
              label: const Text(
                "Konumumu Kullan",
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(Icons.location_on, color: Colors.white,),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              onPressed: ()
              {
                //getCurrentLocationWithAddress
                getUserLocationAddress();
              },
            ),

            Form(
              key: formKey,
              child: Column(
                children: [
                  MyTextField(
                    hint: "İsim",
                    controller: _name,
                  ),
                  MyTextField(
                    hint: 'Telefon ',
                    controller: _phoneNumber,
                  ),
                  MyTextField(
                    hint: 'Şehir',
                    controller: _city,
                  ),
                  MyTextField(
                    hint: 'İlçe',
                    controller: _state,
                  ),
                  MyTextField(
                    hint: 'Daire Numarası',
                    controller: _flatNumber,
                  ),
                  MyTextField(
                    hint: 'Adres Bilgisi',
                    controller: _completeAddress,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
