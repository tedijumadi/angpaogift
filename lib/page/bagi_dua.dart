import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gachaangpao/page/admin.dart';
import 'package:gachaangpao/page/validasi_admin.dart';
import 'package:gachaangpao/page/validasi_player.dart';
import 'package:gachaangpao/page/player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BagiDuaPage extends StatelessWidget {
  const BagiDuaPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover),
        ),
        child: Padding(
          // padding: const EdgeInsets.all(15),
          padding: EdgeInsets.only(bottom: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Choose User :",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Salsa-Regular",
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 60),
              GestureDetector(
                onTap: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  String? storedName = preferences.getString('admin');

                  if (storedName != null && storedName.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminPage(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ValidasiAdminPage(),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 300,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/images/adminicon.png",
                          width: 50, // adjust the width as needed
                          height: 50, // adjust the height as needed
                        ),
                        Text(
                          "Admin",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Salsa-Regular",
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 40,
                        ),
                      ]),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  String? storedName = preferences.getString('user_name');

                  if (storedName != null && storedName.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerPage(userName: storedName),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ValidasiPlayerPage(),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 300,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/images/usericon.png",
                          width: 50, // adjust the width as needed
                          height: 50, // adjust the height as needed
                        ),
                        Text(
                          "User",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Salsa-Regular",
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 40,
                        ),
                      ]),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Versi 1.0.6",
                style:
                    TextStyle(fontFamily: "Salsa-Regular", color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
