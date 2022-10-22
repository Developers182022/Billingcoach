// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:search_choices/search_choices.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/services.dart';
// import 'package:toggle_list/toggle_list.dart';
// import 'package:uuid/uuid.dart';
// import '../api/firebase_api.dart';
// import '../main.dart';
// class Location extends StatelessWidget {
//   // Using "static" so that we can easily access it later
//   static final ValueNotifier<ThemeMode> themeNotifier =
//   ValueNotifier(ThemeMode.light);
//
//   const Location({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<ThemeMode>(
//         valueListenable: themeNotifier,
//         builder: (_, ThemeMode currentMode, __) {
//           return MaterialApp(
//             // Remove the debug banner
//             debugShowCheckedModeBanner: false,
//             title: 'DashBoard',
//             theme: ThemeData(primarySwatch: Colors.amber),
//             darkTheme: ThemeData.dark(),
//             themeMode: ThemeMode.system,
//             home: FirebaseAuth.instance.currentUser == null
//                 ? const LoginUser()
//                 : const LocationPage(user: "userid"),
//           );
//         });
//   }
// }
// class LocationPage extends StatefulWidget {
//   const LocationPage({Key? key, required this.user}) : super(key: key);
//
//   final String user;
//
//   @override
//   State<LocationPage> createState() => _itemPageState();
// }
// class _itemPageState extends State<LocationPage> {
//  Completer<GoogleMapController> _completer= Completer();
//  GoogleMapController? newGoogleMapController;
//  GlobalKey<ScaffoldState> scaffoldkey= new GlobalKey<ScaffoldState>();
//  Position? currentposition;
//  var geolocator= Geolocator();
//
//  void locateposition() async{
//    Position position= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//    currentposition= position;
//
//    LatLng latLngposition= LatLng(position.latitude, position.longitude);
//
//    CameraPosition cameraPosition= new CameraPosition(target: latLngposition, zoom: 14);
//    newGoogleMapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
//  }
//
//   String userid="";
//   User? user;
//   static final CameraPosition _kgoogleplex= CameraPosition(target: LatLng(37.42796133580664, -122.085749655962),
//   zoom: 14.4,);
//
//   @override
//   Widget build(BuildContext context) {
//     List<int> selectedItemsMultiMenu = [];
//     return WillPopScope(
//       onWillPop: () async {
//         final shouldPop = await showDialog<bool>(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: const Text('Do you want to go back?'),
//               actionsAlignment: MainAxisAlignment.spaceBetween,
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     SystemNavigator.pop();
//                   },
//                   child: const Text('Yes'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context, false);
//                   },
//                   child: const Text('No'),
//                 ),
//               ],
//             );
//           },
//         );
//         return false;
//       },
//       child: Scaffold(
//         key: scaffoldkey,
//         body: Stack(
//           children: [
//             GoogleMap(
//               padding: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
//               mapType: MapType.normal,
//               myLocationButtonEnabled: true,
//               initialCameraPosition: _kgoogleplex,
//               myLocationEnabled: true,
//               zoomControlsEnabled: true,
//               zoomGesturesEnabled: true,
//               onMapCreated: (GoogleMapController controller){
//               _completer.complete(controller);
//               newGoogleMapController= controller;
//               setState((){  });
//               locateposition();
//               },
//             ),
//             Positioned(child: GestureDetector(onTap: (){},))
//
//           ],
//         )
//
//       ),
//     );
//   }
//   circleAvatarIconButton({required Icon icon, required Null Function() onPressed}) {}
// }
