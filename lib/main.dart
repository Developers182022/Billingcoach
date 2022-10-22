import 'package:amplify_api/amplify_api.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/HomePage.dart';
import 'firebase_options.dart';
import 'Screens/Orders.dart';
import 'Screens/login/login.dart';
import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';
import 'models/Suppliers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 /* AwesomeNotifications().initialize(
      'resource://drawable/logofront',
      [
        NotificationChannel(
            channelGroupKey: 'basic_tests',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white,
            importance: NotificationImportance.High
        ),
        NotificationChannel(
            channelGroupKey: 'basic_tests',
            channelKey: 'badge_channel',
            channelName: 'Badge indicator notifications',
            channelDescription: 'Notification channel to activate badge indicator',
            channelShowBadge: true,
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.yellow),
        NotificationChannel(
            channelGroupKey: 'category_tests',
            channelKey: 'call_channel',
            channelName: 'Calls Channel',
            channelDescription: 'Channel with call ringtone',
            defaultColor: Color(0xFF9D50DD),
            importance: NotificationImportance.Max,
            ledColor: Colors.white,
            channelShowBadge: true,
            locked: true,
            defaultRingtoneType: DefaultRingtoneType.Ringtone),
        NotificationChannel(
            channelGroupKey: 'category_tests',
            channelKey: 'alarm_channel',
            channelName: 'Alarms Channel',
            channelDescription: 'Channel with alarm ringtone',
            defaultColor: Color(0xFF9D50DD),
            importance: NotificationImportance.Max,
            ledColor: Colors.white,
            onlyAlertOnce: true,
            channelShowBadge: true,
            locked: true,
            vibrationPattern: lowVibrationPattern,
            defaultRingtoneType: DefaultRingtoneType.Alarm),
        NotificationChannel(
            channelGroupKey: 'channel_tests',
            channelKey: 'updated_channel',
            channelName: 'Channel to update',
            channelDescription: 'Notifications with not updated channel',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white),
        NotificationChannel(
          channelGroupKey: 'chat_tests',
          channelKey: 'chats',
          channelName: 'Chat groups',
          channelDescription: 'This is a simple example channel of a chat group',
          channelShowBadge: true,
          importance: NotificationImportance.Max,
          ledColor: Colors.white,
          defaultColor: Color(0xFF9D50DD),
        ),
        NotificationChannel(
            channelGroupKey: 'vibration_tests',
            channelKey: 'low_intensity',
            channelName: 'Low intensity notifications',
            channelDescription:
            'Notification channel for notifications with low intensity',
            defaultColor: Colors.green,
            ledColor: Colors.green,
            vibrationPattern: lowVibrationPattern),
        NotificationChannel(
            channelGroupKey: 'vibration_tests',
            channelKey: 'medium_intensity',
            channelName: 'Medium intensity notifications',
            channelDescription:
            'Notification channel for notifications with medium intensity',
            defaultColor: Colors.yellow,
            ledColor: Colors.yellow,
            vibrationPattern: mediumVibrationPattern
        ),
        NotificationChannel(
            channelGroupKey: 'vibration_tests',
            channelKey: 'high_intensity',
            channelName: 'High intensity notifications',
            channelDescription:
            'Notification channel for notifications with high intensity',
            defaultColor: Colors.red,
            ledColor: Colors.red,
            vibrationPattern: highVibrationPattern
        ),
        NotificationChannel(
            channelGroupKey: 'privacy_tests',
            channelKey: "private_channel",
            channelName: "Privates notification channel",
            channelDescription: "Privates notification from lock screen",
            playSound: true,
            defaultColor: Colors.red,
            ledColor: Colors.red,
            vibrationPattern: lowVibrationPattern,
            defaultPrivacy: NotificationPrivacy.Private),
        NotificationChannel(
            channelGroupKey: 'sound_tests',
            icon: 'resource://drawable/res_power_ranger_thunder',
            channelKey: "custom_sound",
            channelName: "Custom sound notifications",
            channelDescription: "Notifications with custom sound",
            playSound: true,
            soundSource: 'resource://raw/res_morph_power_rangers',
            defaultColor: Colors.red,
            ledColor: Colors.red,
            vibrationPattern: lowVibrationPattern
        ),
        NotificationChannel(
            channelGroupKey: 'sound_tests',
            channelKey: "silenced",
            channelName: "Silenced notifications",
            channelDescription: "The most quiet notifications",
            playSound: false,
            enableVibration: false,
            enableLights: false),
        NotificationChannel(
            channelGroupKey: 'media_player_tests',
            icon: 'resource://drawable/res_media_icon',
            channelKey: 'media_player',
            channelName: 'Media player controller',
            channelDescription: 'Media player controller',
            defaultPrivacy: NotificationPrivacy.Public,
            enableVibration: false,
            enableLights: false,
            playSound: false,
            locked: true),
        NotificationChannel(
            channelGroupKey: 'image_tests',
            channelKey: 'big_picture',
            channelName: 'Big pictures',
            channelDescription: 'Notifications with big and beautiful images',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Color(0xFF9D50DD),
            vibrationPattern: lowVibrationPattern,
            importance: NotificationImportance.High),
        NotificationChannel(
            channelGroupKey: 'layout_tests',
            channelKey: 'big_text',
            channelName: 'Big text notifications',
            channelDescription: 'Notifications with a expandable body text',
            defaultColor: Colors.blueGrey,
            ledColor: Colors.blueGrey,
            vibrationPattern: lowVibrationPattern
        ),
        NotificationChannel(
            channelGroupKey: 'layout_tests',
            channelKey: 'inbox',
            channelName: 'Inbox notifications',
            channelDescription: 'Notifications with inbox layout',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Color(0xFF9D50DD),
            vibrationPattern: mediumVibrationPattern
        ),
        NotificationChannel(
          channelGroupKey: 'schedule_tests',
          channelKey: 'scheduled',
          channelName: 'Scheduled notifications',
          channelDescription: 'Notifications with schedule functionality',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Color(0xFF9D50DD),
          vibrationPattern: lowVibrationPattern,
          importance: NotificationImportance.High,
          defaultRingtoneType: DefaultRingtoneType.Alarm,
          criticalAlerts: true,
        ),
        NotificationChannel(
            channelGroupKey: 'layout_tests',
            icon: 'resource://drawable/res_download_icon',
            channelKey: 'progress_bar',
            channelName: 'Progress bar notifications',
            channelDescription: 'Notifications with a progress bar layout',
            defaultColor: Colors.deepPurple,
            ledColor: Colors.deepPurple,
            vibrationPattern: lowVibrationPattern,
            onlyAlertOnce: true),
        NotificationChannel(
            channelGroupKey: 'grouping_tests',
            channelKey: 'grouped',
            channelName: 'Grouped notifications',
            channelDescription: 'Notifications with group functionality',
            groupKey: 'grouped',
            groupSort: GroupSort.Desc,
            // groupAlertBehavior: GroupAlertBehavior.Children,
            defaultColor: Colors.lightGreen,
            ledColor: Colors.lightGreen,
            vibrationPattern: lowVibrationPattern,
            importance: NotificationImportance.High)
      ],
      channelGroups: [
        NotificationChannelGroup(channelGroupkey: 'basic_tests', channelGroupName: 'Basic tests'),
        NotificationChannelGroup(channelGroupkey: 'category_tests', channelGroupName: 'Category tests'),
        NotificationChannelGroup(channelGroupkey: 'image_tests', channelGroupName: 'Images tests'),
        NotificationChannelGroup(channelGroupkey: 'schedule_tests', channelGroupName: 'Schedule tests'),
        NotificationChannelGroup(channelGroupkey: 'chat_tests', channelGroupName: 'Chat tests'),
        NotificationChannelGroup(channelGroupkey: 'channel_tests', channelGroupName: 'Channel tests'),
        NotificationChannelGroup(channelGroupkey: 'sound_tests', channelGroupName: 'Sound tests'),
        NotificationChannelGroup(channelGroupkey: 'vibration_tests', channelGroupName: 'Vibration tests'),
        NotificationChannelGroup(channelGroupkey: 'privacy_tests', channelGroupName: 'Privacy tests'),
        NotificationChannelGroup(channelGroupkey: 'layout_tests', channelGroupName: 'Layout tests'),
        NotificationChannelGroup(channelGroupkey: 'grouping_tests', channelGroupName: 'Grouping tests'),
        NotificationChannelGroup(channelGroupkey: 'media_player_tests', channelGroupName: 'Media Player tests')
      ],

      debug: true
  );

  // NotificationActionButton(key: "key", label: "label");

  AwesomeNotifications().isNotificationAllowed().then((value){
    if(!value){
      AwesomeNotifications().requestPermissionToSendNotifications();
    }});*/
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _amplifyConfigured = false, loggedin=false;
  AuthUser? user;
  String userid="", restroname="", username="", suppliername="",
      paystatus="", paymode= "", deliverymode="", shpname="", shpid="";

  @override
  void initState() {
    super.initState();
      getuserdetails();
  }
  getuserdetails() async {
    final userPool = CognitoUserPool(
      'ap-south-1_8euTR5YQA',
      '59jiqdmbtdabj6tqrd7ce4u796',
    );
    try {
      var useri = await userPool.getCurrentUser();
      var  attributes = await useri?.getSignInUserSession();
      print("  object      0---     $attributes");
    } catch (e) {
      print(e);runApp(LoginScreen());
    }
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DashBoard',
        theme: ThemeData(primarySwatch: Colors.blue,
            primaryColor: Colors.black87,
            primaryColorDark:Colors.white,
            fontFamily: 'RobotoMono'),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: Home()
/*:LoadingView()*/);
  }
}
