import 'dart:async';
import 'dart:io';
import 'package:etkinlik_takip_projesi/component/provider.dart';
import 'package:etkinlik_takip_projesi/firebase_options.dart';
import 'package:etkinlik_takip_projesi/screen/ActicityList/activitylist.dart';
import 'package:etkinlik_takip_projesi/screen/ActicityList/activitylistkullanici.dart';
import 'package:etkinlik_takip_projesi/screen/EmployeeList/employeelist.dart';
import 'package:etkinlik_takip_projesi/screen/Home/homepage.dart';
import 'package:etkinlik_takip_projesi/screen/Home/homepagekullanici.dart';
import 'package:etkinlik_takip_projesi/screen/LoginPage/loginpage.dart';
import 'package:etkinlik_takip_projesi/screen/Profile/profile.dart';
import 'package:etkinlik_takip_projesi/screen/Profile/userinfo.dart';
import 'package:etkinlik_takip_projesi/screen/Register/register.dart';
import 'package:etkinlik_takip_projesi/service/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  await NotificationService.initializeNotification();
  initializeDateFormatting();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      locale: const Locale('tr', 'TR'),
      initialRoute: "/",
      routes: {
        "/userinfo": (context) => const UserInfo(),
        "/profile": (context) => Profile(),
        "/login": (context) => LoginPage(),
        "/register": (context) => Register(),
        "/home": (context) => HomePage(),
        "/homekullanici": (context) => HomePageKullanici(),
        "/activitylist": (context) => const ActivityList(),
        "/activitylistkullanici": (context) => const ActivityListKullanici(),
        "/employeelist": (context) => const EmployeeList(),
      },

      debugShowCheckedModeBanner: false, // debug yazısını kaldırmak için
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LoginPage(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/yol.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Etkinlik Takip",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 94, 39, 176),
                      fontSize: 35,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          )),
    );
  }
}
