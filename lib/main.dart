import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:next_crib/screens/slider/slider.dart';
import 'package:next_crib/screens/splashScreen/splashScreenPage.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: HexColor("#212529"),

      systemNavigationBarIconBrightness: Brightness.light));

  runApp(NextCrib());
}


class NextCrib extends StatelessWidget {
  const NextCrib({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Next Crib',
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash':(context) => SplashScreenPage(),
        '/slider': (context) => SliderPage(),
      },
      // home: NewHomePage()
    );
  }
}

