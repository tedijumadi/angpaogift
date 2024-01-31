import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:gachaangpao/page/bagi_dua.dart';
import 'package:gachaangpao/page/history.dart';
import 'package:gachaangpao/page/list_hadiah.dart';
import 'package:gachaangpao/page/upload_gift.dart';

class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool isStartGift = false;
  bool isStartVisibility = false;
  // int countdown = 3;
  // int countdown = 5;
  int countdown = 20;
  String memberId = "";

  Future<void> deleteMember(memberId) async {
    await FirebaseFirestore.instance
        .collection('member_room')
        .doc(memberId)
        .delete();
  }

  //confetti
  Future<void> statusMember(memberId) async {
    await FirebaseFirestore.instance
        .collection('member_room')
        .doc(memberId)
        .update({
      'status': 'win',
    });
  }

  Future<void> softDeleteMember(memberId) async {
    await FirebaseFirestore.instance
        .collection('member_room')
        .doc(memberId)
        .update({
      'isdelete': 'nonaktif',
    });
  }

  Future<void> activateAllMembers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('member_room').get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await FirebaseFirestore.instance
          .collection('member_room')
          .doc(doc.id)
          .update({'isdelete': 'aktif'});
    }
  }

//tes lose
  Future<void> loseAllMember() async {
    // Mengambil seluruh dokumen dari koleksi 'member_room'
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('member_room').get();

    // Iterasi melalui setiap dokumen dalam hasil kueri
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // Memeriksa apakah nilai 'status' sudah 'win'
      if (doc['status'] != 'win') {
        // Jika 'status' bukan 'win', maka perbarui nilai 'status' menjadi 'lose'
        await FirebaseFirestore.instance
            .collection('member_room')
            .doc(doc.id)
            .update({'status': 'lose'});
      }
      // Jika 'status' sudah 'win', biarkan saja tanpa melakukan perubahan
    }
  }

  Future<void> giftReset() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('member_room').get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await FirebaseFirestore.instance
          .collection('member_room')
          .doc(doc.id)
          .update({'gift': '', 'status': ''});
    }
  }

  Future<void> DeleteAllStatus() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('member_room').get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await FirebaseFirestore.instance
          .collection('member_room')
          .doc(doc.id)
          .update({'status': ''});
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press
        // Navigate to the "HomePage"
        setState(() {
          isStartGift = false;
          isStartVisibility = false;
        });
        //
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BagiDuaPage(),
            ),
            (Route route) =>
                false); // Replace '/' with the route name of your HomePage
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              // BAACKGROUND
              // color: Colors.purple,
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
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                height: 900,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('member_room')
                          .where('room', isEqualTo: "19902")
                          .where('isdelete', isEqualTo: "aktif")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }

                        List<DataRow> rows = [];

                        snapshot.data!.docs.forEach((document) {
                          String memberId = document.id;
                          String member_name = document['member_name'];
                          String gift = document['gift'];

                          rows.add(DataRow(
                            cells: [
                              DataCell(Text(
                                member_name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Salsa-Regular"),
                              )),
                              DataCell(Text(
                                gift,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Salsa-Regular"),
                              )),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    // Tampilkan dialog konfirmasi saat tombol delete ditekan
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Konfirmasi Delete',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontFamily:
                                                        "Salsa-Regular"),
                                              ),
                                              // Ikon Silang di Pojok Kanan Atas
                                              IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  // Lakukan aksi yang diperlukan saat ikon Silang ditekan

                                                  Navigator.of(context)
                                                      .pop(); // Tutup dialog
                                                },
                                              ),
                                            ],
                                          ),
                                          content: Text(
                                            'Anda yakin ingin menghapus?',
                                            style: TextStyle(
                                                fontFamily: "Salsa-Regular"),
                                          ),
                                          actions: <Widget>[
                                            // Tombol Skip
                                            TextButton(
                                              onPressed: () {
                                                // Menampilkan dialog konfirmasi
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        'Konfirmasi',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Salsa-Regular"),
                                                      ),
                                                      content: Text(
                                                        'Apakah Anda yakin ingin menghapus ini? Anda bisa mengembalikan data ini jika menekan tombol reset',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Salsa-Regular"),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Tutup dialog konfirmasi
                                                          },
                                                          child: Text(
                                                            'Batal',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Salsa-Regular"),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            // Lakukan aksi penghapusan jika konfirmasi diterima
                                                            softDeleteMember(
                                                                memberId);
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Tutup dialog konfirmasi
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Tutup dialog utama
                                                          },
                                                          child: Text(
                                                            'Ya, Hapus',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Salsa-Regular"),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Text(
                                                'Soft Delete',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontFamily:
                                                        "Salsa-Regular"),
                                              ),
                                            ),

                                            // Tombol Hapus Permanent
                                            TextButton(
                                              onPressed: () {
                                                // Menampilkan dialog konfirmasi
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        'Konfirmasi',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Salsa-Regular"),
                                                      ),
                                                      content: Text(
                                                        'Apakah Anda yakin ingin menghapus ini secara permanen? data yang dihapus tidak dapat dikembalikan',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Salsa-Regular"),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Tutup dialog konfirmasi
                                                          },
                                                          child: Text(
                                                            'Batal',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Salsa-Regular"),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            // Lakukan aksi penghapusan permanen jika konfirmasi diterima
                                                            deleteMember(
                                                                memberId);
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Tutup dialog konfirmasi
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Tutup dialog utama
                                                          },
                                                          child: Text(
                                                            'Ya, Hapus Permanen',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Salsa-Regular"),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Text(
                                                'Permanent Delete',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontFamily:
                                                        "Salsa-Regular"),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ));
                        });

                        return Expanded(
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  children: [
                                    Text(
                                      "Welcome Admin,",
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.green,
                                          fontFamily: "Salsa-Regular"),
                                    ),

                                    //TERAKHIR DISINIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
                                    StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('hadiah')
                                          .where("check", isEqualTo: "true")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data!.docs.isNotEmpty) {
                                          // Ambil data dari snapshot
                                          var data = snapshot.data!.docs.first;
                                          return Container(
                                            padding: EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              left: 20,
                                              right: 20,
                                            ), // Menambahkan padding sebesar 16.0 pada semua sisi
                                            color:
                                                Color.fromARGB(255, 31, 43, 61),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Your Gift',
                                                  style: TextStyle(
                                                    fontFamily: "Salsa-Regular",
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        8.0), // Memberikan sedikit jarak vertikal antara teks dan baris berikutnya
                                                Row(
                                                  children: [
                                                    Image.network(
                                                      data['image_url'],
                                                      width: 40,
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Text(
                                                      data['status'],
                                                      style: TextStyle(
                                                        fontFamily:
                                                            "Salsa-Regular",
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        // Navigasi ke halaman edit gift
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ListHadiahPage(),
                                                          ),
                                                        );
                                                      },
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Text('error');
                                        }
                                      },
                                    ),

                                    // Row(
                                    //   children: [
                                    //     Image.asset(
                                    //       "assets/images/usericon.png",
                                    //       height: 100,
                                    //     ),
                                    //     Text('Gift'),
                                    //   ],
                                    // ),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ListHadiahPage(),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            // Menentukan warna latar belakang tombol
                                            primary: Colors.blue,

                                            // Menentukan warna bayangan tombol
                                            shadowColor: Colors.black,

                                            // Menentukan tinggi bayangan tombol
                                            elevation: 5,

                                            // Menentukan warna teks tombol
                                            onPrimary: Colors.white,

                                            // Menentukan bentuk tepi tombol
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          child: Text(
                                            'Edit your gift',
                                            style: TextStyle(
                                              fontFamily: "Salsa-Regular",
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        SizedBox(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Pindah ke halaman baru
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HistoryPage()),
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'History',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Salsa-Regular"),
                                                ),
                                                SizedBox(
                                                    width:
                                                        8), // Spasi antara teks dan ikon
                                                Icon(Icons
                                                    .error), // Ganti dengan ikon tanda seru atau ikon yang diinginkan
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        //Mengatur visibility
                                        if (isStartVisibility == false) ...[
                                          //Akan menampilkan tombol Start
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.all(0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () async {
                                              // await DeleteAllStatus();
                                              //menghapus semua aktif
                                              await giftReset();
                                              final cekData =
                                                  snapshot.data!.docs;
                                              cekData.forEach((document) {
                                                memberId = document.id;
                                              });

                                              if (cekData.isNotEmpty) {
                                                if (isStartVisibility ==
                                                    false) {
                                                  isStartVisibility = true;
                                                  setState(() {});
                                                }

                                                if (isStartGift == false) {
                                                  isStartGift = true;
                                                }

                                                while (isStartGift) {
                                                  for (final data
                                                      in snapshot.data!.docs) {
                                                    // Mengecek apakah isStartGift masih true

                                                    await data.reference.update(
                                                        {'gift': "aktif"});

                                                    await Future.delayed(
                                                      Duration(
                                                          milliseconds: 1000),
                                                    );

                                                    if (!isStartGift) {
                                                      break;
                                                    } else {
                                                      await data.reference
                                                          .update({'gift': ""});
                                                    }
                                                  }
                                                }
                                              }
                                            },
                                            child: Ink(
                                              decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                          colors: [
                                                        Colors.cyan,
                                                        Colors.green
                                                      ]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Container(
                                                width: 80,
                                                height: 40,
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Start',
                                                  style: TextStyle(
                                                    fontFamily: "Salsa-Regular",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ] else ...[
                                          // Else menampilkan tombol Stop
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.all(0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                              // countdown = 3;
                                              // countdown = 5;
                                              countdown = 20;

                                              // Start the countdown
                                              Timer.periodic(
                                                  Duration(seconds: 1),
                                                  (timer) async {
                                                if (countdown > 0) {
                                                  setState(() {
                                                    countdown--;
                                                  });
                                                } else {
                                                  timer.cancel();
                                                  // Execute isStartGift logic here
                                                  setState(() {
                                                    isStartGift = false;
                                                    isStartVisibility = false;
                                                  });

                                                  //ambil data dari member room
                                                  var dataStop =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "member_room")
                                                          .get();

                                                  var simpanSementara =
                                                      dataStop.docs.map(
                                                    (e) {
                                                      final data = e.data();
                                                      data.addAll(
                                                        {
                                                          "reference":
                                                              e.reference.id
                                                        },
                                                      );
                                                      return data;
                                                    },
                                                  ).toList();

                                                  final dataFiltered =
                                                      simpanSementara
                                                          .where((element) =>
                                                              element['gift'] ==
                                                              "aktif")
                                                          .toList();

                                                  //eksekusi status member
                                                  statusMember(dataFiltered
                                                      .first['reference']);

                                                  //mengambil gift dari hadiah list
                                                  var ambilHadiah =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("hadiah")
                                                          .where("check",
                                                              isEqualTo: "true")
                                                          .get();

                                                  var hadiahData = ambilHadiah
                                                      .docs.first
                                                      .data();

                                                  //add history
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("history")
                                                      .add({
                                                    "member_name": dataFiltered
                                                        .first['member_name'],
                                                    "gift":
                                                        hadiahData['status'],
                                                    "image_url":
                                                        hadiahData['image_url'],
                                                    "isdelete": dataFiltered
                                                        .first['isdelete'],
                                                    "room": dataFiltered
                                                        .first['room'],
                                                    "confetti": dataFiltered
                                                        .first['confetti'],
                                                    "CreatedAt": FieldValue
                                                        .serverTimestamp(),
                                                  });

                                                  await loseAllMember();
                                                }
                                              });
                                            },
                                            child: Ink(
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Colors.red,
                                                      Color.fromARGB(
                                                          255, 255, 0, 255),
                                                    ]),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                width: 140,
                                                height: 40,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Stop in $countdown seconds',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                        SizedBox(
                                          width: 10,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () async {
                                            bool confirmed = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Konfirmasi',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Salsa-Regular"),
                                                  ),
                                                  content: Text(
                                                    'Semua Data yang sebelumnya anda hapus akan dikembalikan semua',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Salsa-Regular"),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop(
                                                            false); // Tidak jadi mereset
                                                      },
                                                      child: Text(
                                                        'Batal',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Salsa-Regular"),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop(
                                                            true); // Mengkonfirmasi untuk mereset
                                                      },
                                                      child: Text(
                                                        'Reset',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Salsa-Regular"),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (confirmed) {
                                              await activateAllMembers();
                                              await giftReset();
                                            }
                                          },
                                          // child: Text(
                                          //   'Reset',
                                          //   style: TextStyle(fontFamily: "Salsa-Regular"),
                                          // ),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Colors.orange,
                                                      Colors.orange
                                                    ]),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Container(
                                              width: 80,
                                              height: 40,
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Reset',
                                                style: TextStyle(
                                                  fontFamily: "Salsa-Regular",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 400,
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    headingRowHeight: 30,
                                    headingRowColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.grey),
                                    columns: [
                                      DataColumn(
                                          label: Text(
                                        'Member',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Salsa-Regular"),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Gift',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Salsa-Regular"),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Actions',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Salsa-Regular"),
                                      )),
                                    ],
                                    rows: rows,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
