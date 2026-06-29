//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'routes.dart';
import 'core.dart';


Future main() async {
  // if (kReleaseMode) {
  //   // This effectively disables all debugPrint statements in release mode
  //   debugPrint = (String? message, {int? wrapWidth}) {};
  // }

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Preserve the splash screen while loading resources
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initialize();

  await initializeDb();

  // 3. Perform initialization tasks (APIs, Firebase, etc.) here
  await Future.delayed(const Duration(seconds: 2));

  runApp(const MyApp());

  // 4. Remove the splash screen once the first frame is ready
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(homePageBackgroundImage, context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'FranklinGothicURW'),
      initialRoute: homePage,
      routes: routes,
    );
  }
}
