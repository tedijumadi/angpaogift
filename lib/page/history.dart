import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool isStartGift = false;
  bool isStartVisibility = false;
  // int countdown = 3;
  int countdown = 0;
  String memberId = "";

  Future<void> deleteMember(memberId) async {
    await FirebaseFirestore.instance
        .collection('history')
        .doc(memberId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff0C092A),
              Color.fromARGB(255, 97, 86, 212),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('history')
                  .where('room', isEqualTo: "19902")
                  .where('isdelete', isEqualTo: "aktif")
                  .orderBy('CreatedAt', descending: true)
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
                  String image_url = document['image_url'];
                  String gift = document['gift'];

                  rows.add(DataRow(
                    cells: [
                      DataCell(Text(
                        member_name,
                        style: TextStyle(
                            color: Colors.white, fontFamily: "Salsa-Regular"),
                      )),
                      DataCell(Row(
                        children: [
                          Image.network(
                            image_url,
                            width: 40,
                          ),
                          SizedBox(width: 5),
                          SizedBox(
                            width: 50,
                            child: Text(
                              gift,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Salsa-Regular"),
                            ),
                          ),
                        ],
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
                                          fontSize: 20,
                                          fontFamily: "Salsa-Regular",
                                        ),
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
                                    style:
                                        TextStyle(fontFamily: "Salsa-Regular"),
                                  ),
                                  actions: <Widget>[
                                    // Hapus pertanyaan permanen delete

                                    // Tombol Hapus Permanent
                                    TextButton(
                                      onPressed: () {
                                        // Lakukan aksi penghapusan permanen
                                        deleteMember(memberId);
                                        Navigator.of(context)
                                            .pop(); // Tutup dialog konfirmasi
                                      },
                                      child: Text(
                                        'Hapus Permanen',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: "Salsa-Regular"),
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "History Winners",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Salsa-Regular",
                              fontSize: 25),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          height: 500,
                          child: SingleChildScrollView(
                            child: DataTable(
                              headingRowHeight: 30,
                              headingRowColor: MaterialStateColor.resolveWith(
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
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
