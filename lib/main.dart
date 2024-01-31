import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gachaangpao/firebase_options.dart';
import 'package:gachaangpao/page/bagi_dua.dart';
import 'package:gachaangpao/page/upload_gift.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: false),
      debugShowCheckedModeBanner: false, // Menyembunyikan banner mode debug
      // home: UploadGift(),
      // home: AnimasiPage(),
      home: BagiDuaPage(),
    ),
  );
}
