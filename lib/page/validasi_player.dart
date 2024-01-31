import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:gachaangpao/page/player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class ValidasiPlayerPage extends StatefulWidget {
  @override
  _ValidasiPlayerPageState createState() => _ValidasiPlayerPageState();
}

class _ValidasiPlayerPageState extends State<ValidasiPlayerPage> {
  final TextEditingController _nameController = TextEditingController();

  // Fungsi untuk menambahkan pengguna ke Firestore
  void _addUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = _nameController.text;
    if (name.isNotEmpty) {
      try {
        await prefs.setString('user_name', name);

        String date = DateTime.now().microsecondsSinceEpoch.toString();
        await FirebaseFirestore.instance
            .collection('member_room')
            .doc(date)
            .set({
          'member_name': name,
          'gift': "",
          'room': "19902",
          'isdelete': "aktif",
          'confetti': "",
          'status': "",
          'waktu': date,
        });
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerPage(
              userName: name,
            ),
          ),
        );
        _nameController.clear();
      } catch (e) {
        print('Error adding user: $e');
        // Handle error, misalnya dengan menampilkan pesan kesalahan
      }
    } else {
      // Handle validasi input
      // Misalnya, tampilkan pesan bahwa semua field harus diisi
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      body: Container(
        // color: Colors.black,
        width: double.maxFinite,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff0C092A),
              Color.fromARGB(255, 97, 86, 212),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TODO : add icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "IPOH SOHO",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: "Salsa-Regular"),
                  ),
                  Image.asset(
                    "assets/images/logo.png",
                    width: 100,
                  ),
                ],
              ),
              // SizedBox(
              //   height: 5,
              // ),
              // const SizedBox(
              //   height: 200,
              // ),
              Spacer(),
              Container(
                width: 300,
                // height: 60
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  // color: Color(0xff270C43),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 8, 0, 0).withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(
                          0, 3), // Perubahan posisi bayangan pada sumbu Y
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    // Lottie.asset('assets/images/animasi_validasi.json',
                    //     width: 80, fit: BoxFit.fitWidth),

                    // SizedBox(
                    //   height: 5,
                    // ),
                    const Center(
                      child: Text(
                        "Input Name",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: "Salsa-Regular",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 70,
                      child: TextField(
                        controller: _nameController,
                        maxLength: 20,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 126, 102, 102),
                            fontFamily: "Salsa-Regular",
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 170, 170, 170),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 107, 107, 107),
                            ),
                          ),
                          fillColor: Colors
                              .white, // Warna latar belakang ketika input aktif
                          filled:
                              true, // Mengaktifkan latar belakang diisi warna
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: 160,
                      child: ElevatedButton(
                        onPressed: _addUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 153, 139, 255),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              fontFamily: "Salsa-Regular",
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                      //     GestureDetector(
                      //   onTap:
                      //       _addUser, // Ganti sesuai dengan fungsi yang sesuai dengan aksi yang diinginkan
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(
                      //         8.0), // Sesuaikan padding sesuai kebutuhan
                      //     child: Image.asset(
                      //       'assets/images/yellowbutton.png',
                      //       width: 60,
                      //       height: 60,
                      //     ),
                      //   ),
                      // ),
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
