// import 'package:flutter/services.dart';
// import 'package:purchases_flutter/models/offering_wrapper.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
//
// class PurchaseApi{
//   static const _apiKey='goog_sacKHVLbHMSZjrWCnrDQmlvXshj';
//   static Future init()async{
//     await Purchases.setDebugLogsEnabled(true);
//     await Purchases.setup(_apiKey);
//   }
//   static Future<List<Offering>> fetchOffers() async{
//     try {
//       final offerings = await Purchases.getOfferings();
//       final current = offerings.current;
//       print("offferrrcredcf   $current");
//       return current == null ? [] : [current];
//     }on PlatformException catch(e){
//       return [];
//     }
//   }
//
//   static Future<bool> purchasePackage(Package package, String user)async{
//     try {
//       await Purchases.purchasePackage(package);
//       await Purchases.setup(_apiKey, appUserId: user);
//       return true;
//     }catch(e){
//       return false;
//     }
//   }
//
//
// }