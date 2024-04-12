import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

void main() {
  runApp(MyApp());
}

class Contact {
  String name;
  String phoneNumber;

  Contact({required this.name, required this.phoneNumber});
}

class MyApp extends StatelessWidget {
  final List<Contact> contacts = [
    Contact(name: "Aya Mabouj", phoneNumber: "+21656416068"),
    Contact(name: "Mohamed Taher Mabaouj", phoneNumber: "+21697497166"),
    // Ajoutez d'autres contacts ici
  ];

  void _sendMessage(String phoneNumber, String message) {
    final Telephony telephony = Telephony.instance;
    telephony.sendSms(
      to: phoneNumber,
      message: message,
    );
  }

  Future<void> _sendLocationMessage(String phoneNumber) async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    String message =
        "Ma position actuelle : ${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}";

    _sendMessage(phoneNumber, message);
  }

  void _makePhoneCall(String phoneNumber) {
    FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact List',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contact List'),
        ),
        body: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.blue,
              child: ListTile(
                leading: Icon(Icons.person_pin, color: Colors.white, size: 30,),
                title: Text(
                  contacts[index].name,
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  contacts[index].phoneNumber,
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  //_sendMessage(contacts[index].phoneNumber, "Cette personne part");
                  //_sendLocationMessage(contacts[index].phoneNumber);
                  _makePhoneCall(contacts[index].phoneNumber); // Appel téléphonique
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
