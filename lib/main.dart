import 'package:flutter/material.dart';
import 'package:flutter_progect/pages/light.dart';
import 'package:flutter_progect/user_data.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_progect/pages/booking.dart';
import 'package:flutter_progect/pages/hall.dart';
import 'package:flutter_progect/pages/home.dart';
import 'package:flutter_progect/pages/login.dart';
import 'package:flutter_progect/pages/myBooking.dart';
import 'package:flutter_progect/pages/register.dart';
import 'package:flutter_progect/pages/thenks.dart';
import 'package:flutter_progect/pages/ap/ap.dart';
import 'package:flutter_progect/pages/ap/editHall.dart';
import 'package:flutter_progect/pages/ap/addHall.dart';
import 'package:flutter_progect/pages/ap/editLight.dart';
import 'package:flutter_progect/pages/ap/addLight.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru_RU', null);

  runApp(UserDataProvider(
      userData: UserData(
        userName: 'user',
        userStatus: 'guest', 
        userId: -1,
      ),
      child:MaterialApp(
        theme: ThemeData(
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/hall': (context) => HallPage(),
          '/light': (context) => LightPage(),
          '/booking': (context) => BookingPage(),
          '/myBooking': (context) => MyBookingsPage(),
          '/thanks': (context) => ThanksPage(),
          '/ap': (context) => AdminPage(),
          // '/editHall': (context) => EditHallPage(hallId: -1,),
          '/addHall': (context) => AddHallPage(),
          // '/eidtLight': (context) => EditLightPage(lightId: -1,),
          '/addLight': (context) => AddLightPage(),

      }
  ))
  );
}

// UserDataProvider.of(context)?.userData.userName
// UserDataProvider.of(context)?.userData.changeUserName(name)