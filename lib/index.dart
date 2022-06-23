import 'dart:typed_data';
import 'dart:convert';
import 'package:document_wallet/addFile.dart';
import 'package:document_wallet/viewDocument.dart';
import 'package:document_wallet/widgets/documentCard.dart';
import 'package:document_wallet/widgets/profileCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String>? nameOfDocuments = [];
  int i = 0;
  getCountOfDocs() async {
    var data = await FirebaseStorage.instance
        .ref()
        .child("${FirebaseAuth.instance.currentUser!.displayName}")
        .listAll();
    data.items.forEach(
      (element) => {
        setState(() {
          i = i + 1;
          nameOfDocuments!.insert(0, element.name);
        }),
      },
    );
  }

  @override
  void initState() {
    this.getCountOfDocs();
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: Container(
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            backgroundColor: Colors.indigo,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddFile()));
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: size.height * 0.2,
            top: size.height * 0.08,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileCard(
                imagePath: _auth.currentUser!.photoURL!,
                name: _auth.currentUser!.displayName!,
                occupation: "Welcome!!",
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Documents",
                style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                    )
                  ],
                ),
                child: TextFormField(
                  obscureText: false,
                  validator: (input) {
                    if (input != null && input.isEmpty) {
                      return "Please enter some text";
                    }
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      FeatherIcons.search,
                    ),
                    hintText: "Search",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              //search bar remaining
              for (var a = 0; a < i; a++)
                GestureDetector(
                  onTap: () async {
                    FirebaseStorage storage = FirebaseStorage.instance;
                    Reference ref = storage.ref().child(
                        "${_auth.currentUser!.displayName}/${nameOfDocuments![a]}");
                    final String fileUrl = await ref.getDownloadURL();
                    final String path = await ref.fullPath;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => viewDocument(
                          documentName: nameOfDocuments![a],
                          documentUrl: fileUrl,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      documentCard(
                        documentName: nameOfDocuments![a],
                        ref: FirebaseStorage.instance.ref().child(
                            "${_auth.currentUser!.displayName}/${nameOfDocuments![a]}"),
                        icon: Icon(
                          FeatherIcons.file,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
