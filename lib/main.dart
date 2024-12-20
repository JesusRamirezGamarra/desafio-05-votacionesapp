import 'package:appvotacionesg10/firebase_options.dart';
import 'package:appvotacionesg10/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// void main() {
//   runApp(
//     MaterialApp(
//       home: HomePage(),
//       debugShowCheckedModeBanner: false,
//     ),
//   );
// }


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "dev project",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

