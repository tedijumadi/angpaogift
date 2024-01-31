import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:gachaangpao/page/upload_list_gift.dart';

class ListHadiahPage extends StatefulWidget {
  @override
  State<ListHadiahPage> createState() => _ListHadiahPageState();
}

class _ListHadiahPageState extends State<ListHadiahPage> {
  bool isStartGift = false;
  bool isStartVisibility = false;
  // int countdown = 3;
  int countdown = 0;
  String memberId = "";

  Future<void> deleteMember(memberId) async {
    await FirebaseFirestore.instance
        .collection('hadiah')
        .doc(memberId)
        .delete();
  }

// update checkbox
  Future<void> updateCheckField(String memberId, bool? value) async {
    String newValue = value?.toString() ?? 'false'; // Convert boolean to string
    await FirebaseFirestore.instance
        .collection('hadiah')
        .doc(memberId)
        .update({'check': newValue});
  }

//allfalse
//tes lose
  Future<void> updateAllUncheckedFields() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('hadiah').get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await FirebaseFirestore.instance
          .collection('hadiah')
          .doc(doc.id)
          .update({'check': 'false'});
    }
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
                  .collection('hadiah')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                List<DataRow> rows = [];

                snapshot.data!.docs.forEach((document) {
                  String memberId = document.id;
                  String check = document['check'];
                  String image_url = document['image_url'];
                  String status = document['status'];

                  rows.add(DataRow(
                    cells: [
                      DataCell(
                        Checkbox(
                          value: check == 'true',
                          onChanged: (bool? value) async {
                            await updateAllUncheckedFields();
                            await updateCheckField(memberId, value);
                          },
                        ),
                      ),
                      DataCell(
                        Image.network(
                          image_url,
                          width: 40,
                        ),
                      ),
                      DataCell(Text(
                        status,
                        style: TextStyle(
                            color: Colors.white, fontFamily: "Salsa-Regular"),
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
                          "List Hadiah",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Salsa-Regular",
                            fontSize: 25,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UploadListGift(),
                              ),
                            );
                          },
                          child: Text(
                            'Add New',
                            style: TextStyle(fontFamily: "Salsa-Regular"),
                          ),
                        ),
                        SizedBox(
                          height: 500,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(
                                    label: Text(
                                  'Check',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Salsa-Regular"),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Image',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Salsa-Regular"),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Name',
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
