import 'package:demo_hce1/LoginScreen.dart';
import 'package:flutter/material.dart';

import 'Layout.dart';
import 'package:provider/provider.dart';
import 'chat_provider.dart';
import 'chat_screen.dart';
import 'Layout.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'LoginScreenFB.dart';

// void main() =>
//     runApp(

//         MaterialApp(debugShowCheckedModeBanner: false, home: Layout()));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: LoginScreen(),
  //   );
  // }
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child:
          MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreenFB()),
    );
  }
}
