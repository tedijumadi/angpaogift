import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gachaangpao/page/bagi_dua.dart';
import 'package:gachaangpao/page/validasi_admin.dart';
import 'package:gachaangpao/page/validasi_player.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:confetti/confetti.dart';

class PlayerPage extends StatefulWidget {
  final userName;

  //

  PlayerPage({required this.userName});
  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _controllerGift;
  late AnimationController _MicrofonController;
  String ambilWin = "Kosong";

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));

    // Inisialisasi AnimationController untuk animasi pada gambar kado
    _MicrofonController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
    // _controllerGift = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 5),
    // )..repeat(reverse: false);
    _controllerGift = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
    _controllerGift.dispose();
  }

  void onPressed() {
    _confettiController.play();
  }

  //--
  void _startAnimation() {
    // Periksa apakah animasi sedang berjalan, jika ya, hentikan terlebih dahulu
    if (_controllerGift.isAnimating) {
      _controllerGift.stop();
    }

    // Mulai ulang animasi dari awal
    _controllerGift.reset();
    _controllerGift.forward();
  }

  //--

  //fungsi sound efek
  void _playSound(String soundFileName) async {
    final player = AudioPlayer();
    await player.play(AssetSource('$soundFileName'));
  }

//
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press
        // Navigate to the "HomePage"
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              // bagi
              builder: (context) => BagiDuaPage(),
            ),
            (Route route) =>
                false); // Replace '/' with the route name of your HomePage
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [
          //       Color(0xff0C092A),
          //       Color.fromARGB(255, 97, 86, 212),
          //     ],
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //   ),
          // ),
          width: double.maxFinite,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover),
          ),
          child: Center(
            child: Column(
              children: [
                //Mengembalikan widget ConfettiWidget tanpa memainkan efek konfeti
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ],
                  createParticlePath: drawStar,
                ),
                StreamBuilder<QuerySnapshot>(
                  // Mendapatkan stream dari query Firestore
                  stream: FirebaseFirestore.instance
                      .collection('member_room')
                      .where('member_name', isEqualTo: widget.userName)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("work");
                    } else if (snapshot.hasError) {
                      return Text("Data error");
                    } else if (snapshot.data?.docs == null ||
                        snapshot.data!.docs.isEmpty) {
                      // Text("error");
                      return Container(
                        width: double.maxFinite, // Mengisi lebar layar
                        height: 500,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Panggil fungsi clearUserName ketika tombol ditekan
                            await clearUserName();

                            // Navigasi ke halaman utama
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    BagiDuaPage(), // Ganti dengan widget halaman utama Anda
                              ),
                            );
                          },
                          child: Text(
                            'Input Your Name Again!',
                            style: TextStyle(
                                fontFamily: "Salsa-Regular",
                                color: Colors.black,
                                fontSize: 30),
                          ),
                        ),
                      );

                      //
                    }

                    // // ---
                    //JIKA SNAPSHOT TIDAK DITEMUKAN
                    // if (snapshot.data?.docs == null ||
                    //     snapshot.data!.docs.isEmpty) {
                    //   // Call the clearUserName function when the button is pressed
                    //   clearUserName();

                    //   // Navigate to the home page
                    //   Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(
                    //       builder: (context) =>
                    //           XBagiDua(), // Replace with your home page widget
                    //     ),
                    //   );
                    // }
                    // Mengakses data hasil query untuk kado dan empty
                    var documents = snapshot.data?.docs ?? [];
                    List<String> giftList =
                        documents.map((doc) => doc['gift'] as String).toList();
                    String cekGift = giftList.first;
                    String imagePath;
                    if (cekGift == "aktif") {
                      imagePath = 'assets/images/giftmerahkuning.json';
                      _startAnimation();
                    } else {
                      imagePath = 'assets/images/blank.json';
                    }

                    //confetti adalah data confetti warna-warni
                    List<String> cekConfetti = documents
                        .map((doc) => doc['status'] as String)
                        .toList();
                    String cekGift2 = cekConfetti.first;
                    ambilWin = cekConfetti.first;
                    // if (cekGift2 == "aktif") {
                    //   _confettiController.play();
                    // } else {}
                    //POPUP
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (cekGift2 == "win") {
                        _confettiController.play();
                        _playSound('sfk/win.mp3');

                        // Call the callback function after the frame is painted
                        showDialog(
                          context: context,
                          // barrierDismissible:
                          //     false, // Mencegah penutupan dialog saat menyentuh area luar atau menekan tombol back
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: () async =>
                                  false, // Mencegah penutupan dialog saat menekan tombol back
                              child: _PopUpMenang(),
                            );
                          },
                        );
                      } else if (cekGift2 == "lose") {
                        _confettiController.play();

                        //

                        //menghapus pop up lose
                        // showDialog(
                        //   context: context,
                        //   barrierDismissible:
                        //       false, // Mencegah penutupan dialog saat menyentuh area luar atau menekan tombol back

                        //   builder: (BuildContext context) {
                        //     return WillPopScope(
                        //       onWillPop: () async =>
                        //           false, // Mencegah penutupan dialog saat menekan tombol back
                        //       child: _PopUpKalah(),
                        //     );
                        //   },
                        // );
                      }
                    });

                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // SizedBox(height: 40),
                          // Text(
                          //   'Gift Data:',
                          //   style: TextStyle(
                          //     fontSize: 20,
                          //     fontWeight: FontWeight.bold,
                          //     fontFamily: "Salsa-Regular",
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
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
                          ),
                          Spacer(),

                          // Gunakan ListView.builder untuk menampilkan daftar gift
                          Stack(
                            children: [
                              Container(
                                // color: Colors.green,
                                height:
                                    MediaQuery.of(context).size.height * 0.70,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        //
                                        FractionalTranslation(
                                          translation: Offset(
                                            -0.5,
                                            0.05,
                                          ),
                                          child: Transform.rotate(
                                            angle: 785398,
                                            child: AnimatedBuilder(
                                              animation: _MicrofonController,
                                              builder: (context, child) {
                                                return Transform.rotate(
                                                  angle: 0.1 *
                                                      _MicrofonController.value,
                                                  child: Transform.translate(
                                                    offset: Offset(
                                                        5 *
                                                            _MicrofonController
                                                                .value,
                                                        0),
                                                    child: child,
                                                  ),
                                                );
                                              },
                                              child: Image.asset(
                                                'assets/images/microfon.png',
                                                height: 300,
                                              ),
                                            ),
                                            // Image.asset(
                                            //   'assets/images/microfon.png',
                                            //   height: 300,
                                            // ),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 100,
                                        // ),
                                        FractionalTranslation(
                                          translation: Offset(
                                            0.4,
                                            0.06,
                                          ),
                                          child: AnimatedBuilder(
                                            animation: _MicrofonController,
                                            builder: (context, child) {
                                              return Transform.rotate(
                                                angle: 0.1 *
                                                    _MicrofonController.value,
                                                child: Transform.translate(
                                                  offset: Offset(
                                                      5 *
                                                          _MicrofonController
                                                              .value,
                                                      0),
                                                  child: child,
                                                ),
                                              );
                                            },
                                            child: Image.asset(
                                              'assets/images/microfon2.png',
                                              height: 300,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // AnimatedBuilder(
                              //   animation: _controller,
                              //   builder: (context, child) {
                              //     return Transform.rotate(
                              //       angle: 0.1 * _controller.value,
                              //       child: Transform.translate(
                              //         offset: Offset(60 * _controller.value, 0),
                              //         child: child,
                              //       ),
                              //     );
                              //   },
                              //   child: Lottie.asset(imagePath,
                              //       width: 280, fit: BoxFit.fitWidth),
                              // ),
                              // GIFT

                              if (ambilWin == "win") ...{
                                Center(
                                  child: Column(
                                    children: [
                                      Lottie.asset(
                                          'assets/images/giftmerahkuning.json',
                                          width: 280,
                                          fit: BoxFit.fitWidth),
                                      SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              } else ...{
                                AnimatedBuilder(
                                  animation: _controllerGift,
                                  builder: (context, child) {
                                    // Mulai dari posisi jauh sebelah kiri (misalnya, -1000) dan bergerak ke kanan
                                    return Transform.translate(
                                      offset: Offset(
                                          -500 + 1000 * _controllerGift.value,
                                          0),
                                      child: child,
                                    );
                                  },
                                  // child: Lottie.asset(imagePath,
                                  //     width: 280, fit: BoxFit.fitWidth),
                                  child: Lottie.asset(
                                      'assets/images/giftmerahkuning.json',
                                      width: 280,
                                      fit: BoxFit.fitWidth),
                                ),
                                SizedBox(height: 15),
                              }
                              // AnimatedBuilder(
                              //   animation: _controllerGift,
                              //   builder: (context, child) {
                              //     // Mulai dari posisi jauh sebelah kiri (misalnya, -1000) dan bergerak ke kanan
                              //     return Transform.translate(
                              //       offset: Offset(
                              //           -500 + 1000 * _controllerGift.value, 0),
                              //       child: child,
                              //     );
                              //   },
                              //   // child: Lottie.asset(imagePath,
                              //   //     width: 280, fit: BoxFit.fitWidth),
                              //   child: Lottie.asset(
                              //       'assets/images/giftmerahkuning.json',
                              //       width: 280,
                              //       fit: BoxFit.fitWidth),
                              // ),

                              //----
                              // ElevatedButton(
                              //   onPressed: () {
                              //     // Panggil fungsi untuk memulai animasi saat tombol ditekan
                              //     _startAnimation();
                              //   },
                              //   child: Text('Jalankan Animasi'),
                              // )
                              //----
                            ],
                          ),

                          // Text(
                          //   cekGift,
                          //   style: TextStyle(
                          //       color: Colors.white, fontFamily: "Salsa-Regular"),
                          // ),
                          // Text(
                          //   'Welcome..... ${widget.userName}', // Menggunakan data nama pengguna di sini
                          //   style: TextStyle(
                          //       fontSize: 5,
                          //       color: Colors.white,
                          //       fontFamily: "Salsa-Regular"),
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     ElevatedButton(
                          //       onPressed: () async {
                          //         // Call the clearUserName function when the button is pressed
                          //         await clearUserName();

                          //         // Navigate to the home page
                          //         Navigator.of(context).pushReplacement(
                          //           MaterialPageRoute(
                          //             builder: (context) =>
                          //                 XBagiDua(), // Replace with your home page widget
                          //           ),
                          //         );
                          //       },
                          //       child: Text(
                          //         'Log out',
                          //         style: TextStyle(
                          //           fontFamily: "Salsa-Regular",
                          //         ),
                          //       ),
                          //     ),
                          //     ElevatedButton(
                          //       onPressed: () async {
                          //         // Navigate to the home page
                          //         Navigator.of(context).pushReplacement(
                          //           MaterialPageRoute(
                          //             builder: (context) =>
                          //                 XBagiDua(), // Replace with your home page widget
                          //           ),
                          //         );
                          //       },
                          //       child: Text(
                          //         'Log Out2SS',
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    );
                  },
                ),

                /// NEW CODE
                ///
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> clearUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}

class _PopUpMenang extends StatefulWidget {
  const _PopUpMenang({
    super.key,
  });

  @override
  State<_PopUpMenang> createState() => _PopUpMenangState();
}

class _PopUpMenangState extends State<_PopUpMenang> {
  // final hadiahListener = FirebaseFirestore.instance
  //     .doc('/gameplay/bl9jZHO3b695M2aUUSqb')
  //     .snapshots();

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void onPressed() {
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AlertDialog(
          elevation: 0,
          content: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('hadiah')
                .where("check", isEqualTo: "true")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox();
              } else {
                final dataDb = snapshot.data!.docs;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent, //nilai opacity sesuai kebutuhan
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/pitawin.png',
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        padding: EdgeInsets.only(
                            top: 0,
                            left: 20,
                            right: 20,
                            bottom: 0), // Adjust the value as needed
                        child: Column(
                          children: [
                            Text(
                              'Congratulations!',
                              style: TextStyle(
                                fontFamily: "Salsa-Regular",
                                fontSize: 15,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Image.network(
                              dataDb.first['image_url'],
                              fit: BoxFit.cover,
                              width: 200,
                              height: 200,
                            ),
                            Text(
                              dataDb.first['status'],
                              style: TextStyle(
                                fontFamily: "Salsa-Regular",
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Konten yang sudah ada sebelumnya

                      Center(
                        child: ConfettiWidget(
                          confettiController: _confettiController,
                          blastDirectionality: BlastDirectionality.explosive,
                          shouldLoop: false,
                          colors: const [
                            Colors.green,
                            Colors.blue,
                            Colors.pink,
                            Colors.orange,
                            Colors.purple,
                          ],
                          createParticlePath: drawStar,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          actionsPadding: EdgeInsets.zero,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _confettiController.stop();
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(fontFamily: "Salsa-Regular", fontSize: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}

//popupkalah

class _PopUpKalah extends StatefulWidget {
  const _PopUpKalah({
    super.key,
  });

  @override
  State<_PopUpKalah> createState() => _PopUpKalahState();
}

class _PopUpKalahState extends State<_PopUpKalah> {
  final hadiahListener = FirebaseFirestore.instance
      .doc('/gameplay/bl9jZHO3b695M2aUUSqb')
      .snapshots();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void onPressed() {
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AlertDialog(
          // Mengatur background menjadi transparan

          elevation: 0,
          content: StreamBuilder(
            stream: hadiahListener,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox();
              } else {
                final dataDb = snapshot.data!.data();
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/pitalose.png',
                    ),
                    Image.network(dataDb!['lose_image_url']),
                    Text(
                      "Zonk!!",
                      style:
                          TextStyle(fontFamily: "Salsa-Regular", fontSize: 30),
                    ),
                    Text(
                      'Opps.. Your Lose.',
                      style:
                          TextStyle(fontFamily: "Salsa-Regular", fontSize: 15),
                    ),
                    Center(
                      child: ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        shouldLoop: false,
                        colors: const [
                          Colors.green,
                          Colors.blue,
                          Colors.pink,
                          Colors.orange,
                          Colors.purple
                        ],
                        createParticlePath: drawStar,
                      ),
                    ),
                    // Lottie.asset('assets/images/openbox.json',
                    //     width: 200, fit: BoxFit.fitWidth),
                  ],
                );
              }
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _confettiController
                    .stop(); // Berhenti Confetti saat dialog ditutup
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: Text(
                'OK',
                style: TextStyle(fontFamily: "Salsa-Regular", fontSize: 15),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
