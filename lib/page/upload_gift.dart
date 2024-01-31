import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadGift extends StatefulWidget {
  const UploadGift({Key? key}) : super(key: key);

  @override
  State<UploadGift> createState() => _UploadGiftState();
}

class _UploadGiftState extends State<UploadGift> {
  String status = "";
  File? imageFile;

  Stream<QuerySnapshot> getGiftData() {
    return FirebaseFirestore.instance.collection('gameplay').snapshots();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void uploadToFirestore(String status, File? imageFile) async {
    try {
      if (imageFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('images')
            .child(DateTime.now().toString() + '.jpg');
        await storageRef.putFile(imageFile);

        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('gameplay')
            .doc('bl9jZHO3b695M2aUUSqb')
            .set({
          'status': status,
          'image_url': imageUrl,
          'lose_image_url':
              'https://firebasestorage.googleapis.com/v0/b/gachaangpao.appspot.com/o/images%2Femojisedih-removebg-preview.png?alt=media&token=958efb14-9572-48bd-a756-0b8caae0b35c',
          'timestamp': FieldValue.serverTimestamp(),
        });

        print('Status dan gambar berhasil diunggah ke Firestore.');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengunggah ke Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: getGiftData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('Tidak ada data hadiah.');
                  }

                  var giftName = snapshot.data!.docs[0]['status'];
                  var imageUrl = snapshot.data!.docs[0]['image_url'];

                  return Column(
                    children: [
                      Text("Recent"),
                      Row(
                        children: [
                          Image.network(
                            imageUrl,
                            height: 80,
                          ),
                          Text("Nama Hadiah: $giftName"),
                        ],
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20),
              TextField(
                maxLength: 20,
                decoration: InputDecoration(labelText: "Gift Name"),
                onChanged: (value) {
                  setState(() {
                    status = value;
                  });
                },
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey[200],
                  child: imageFile != null
                      ? Image.file(imageFile!, fit: BoxFit.cover)
                      : Icon(Icons.add_photo_alternate,
                          size: 50, color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  uploadToFirestore(status, imageFile);
                },
                child: Text("Simpan",
                    style: TextStyle(fontFamily: "Salsa-Regular")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
