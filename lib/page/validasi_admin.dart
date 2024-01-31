import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gachaangpao/page/admin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ValidasiAdminPage extends StatefulWidget {
  @override
  _ValidasiAdminPageState createState() => _ValidasiAdminPageState();
}

class _ValidasiAdminPageState extends State<ValidasiAdminPage> {
  final TextEditingController _nameController = TextEditingController();

  String PasswordAdmin = "";

  // Metode untuk mendapatkan PasswordAdmin dari Firestore
  Future<void> _getPasswordAdmin() async {
    try {
      // Gantilah 'nama_dokumen' dengan nama dokumen yang sesuai di Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('admin')
          .doc('zRrwuWaE2XhB6wOUKMiY')
          .get();

      // Ambil nilai field 'password' dari dokumen Firestore
      setState(() {
        PasswordAdmin = snapshot['password'];
      });
    } catch (e) {
      print('Error fetching PasswordAdmin: $e');
      // Handle error, misalnya dengan menampilkan pesan kesalahan
    }
  }

  @override
  void initState() {
    super.initState();
    _getPasswordAdmin();
  }

// Fungsi untuk menambahkan pengguna ke Firestore
  void _pindahAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = _nameController.text;
    if (name == PasswordAdmin) {
      // Periksa apakah input adalah "4444"
      try {
        await prefs.setString('admin', name);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminPage(),
          ),
        );
        _nameController.clear();
      } catch (e) {
        print('Error moving to XInPlayerPlay: $e');
        // Handle error, misalnya dengan menampilkan pesan kesalahan
      }
    } else if (name.isNotEmpty) {
    } else {
      print('Semua field harus diisi');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      body: Container(
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Center(
                        child: Text(
                      "Admin PIN",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Salsa-Regular"),
                    )),
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
                                fontFamily: "Salsa-Regular"), // Warna label
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 170, 170,
                                      170)), // Warna garis tepi ketika input tidak aktif
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 107, 107, 107),
                              ),
                            )
                            // Bisa menambahkan properti lain sesuai kebutuhan
                            ),
                        style: const TextStyle(
                            color: Colors.black), // Warna teks input
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: 160,
                      child: ElevatedButton(
                        onPressed: _pindahAdmin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 153, 139, 255),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                              fontFamily: "Salsa-Regular",
                              fontWeight: FontWeight.bold),
                        ),
                      ),
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
