import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:next_crib/screens/slider/slider.dart';
import 'package:next_crib/screens/splashScreen/splashScreenPage.dart';
import 'package:next_crib/screens/utilities/updateChecker.dart';
import 'package:upgrader/upgrader.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: HexColor("#212529"),
      systemNavigationBarIconBrightness: Brightness.light));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,  // Lock to portrait
  ]).then((_) {
    runApp(NextCrib());
  });

}

class NextCrib extends StatelessWidget {
  const NextCrib({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Next Crib',
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      // initialRoute: '/splash',
      // routes: {
      //   '/splash':(context) => SplashScreenPage(),
      //   '/slider': (context) => SliderPage(),
      // },
      //  home: Builder(
      //    builder: (context) {
      //      Future.delayed(Duration.zero, () => UpdateChecker.checkForUpdate(context));
      //      return const SplashScreenPage();
      //    }
      //  ),

      home: UpgradeAlert(
        child: const SplashScreenPage(),
      ),
    );
  }
}

