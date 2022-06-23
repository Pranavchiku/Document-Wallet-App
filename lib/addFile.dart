import 'dart:io';
import 'dart:typed_data';

import 'package:document_wallet/index.dart';
import 'package:document_wallet/widgets/bottomNavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddFile extends StatefulWidget {
  const AddFile({Key? key}) : super(key: key);

  @override
  State<AddFile> createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _fileName;
  double? _progress = 0;
  // selectFile() async {
  //   FilePickerResult? file = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
  //   );
  //   // loadingController.forward();
  //   if (file != null) {
  //     final destination =
  //         '${FirebaseAuth.instance.currentUser!.displayName}/Aadhar';
  //     Uint8List? fileBytes = file.files.first.bytes;
  //     String fileName = file.files.first.name;

  //     await FirebaseStorage.instance.ref(destination).putData(fileBytes!);
  //   }
  // }
  late File _image;
  bool show = false;
  selectFile() async {
    if (_formKey != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      setState(() {
        _image = File(pickedFile!.path);
      });
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
          '${FirebaseAuth.instance.currentUser!.displayName}/${_fileName}');
      UploadTask uploadTask = firebaseStorageRef.putFile(_image);

      uploadTask.snapshotEvents.listen((event) {
        setState(() {
          show = true;
          _progress =
              event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
          print(_progress.toString());
        });
        if (event.state == TaskState.success) {
          _progress = 100;
          Fluttertoast.showToast(msg: 'File added to the library');
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Index()),
              (route) => false);
        }
      }).onError((error) {
        // do something to handle error
      });
      // var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      // setState(() {
      //   _imageURL = dowurl.toString();
      // });

      // print(_imageURL);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: size.height * 0.2,
            top: size.height * 0.1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Add Document",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Container(
                  height: 105,
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
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      top: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 15,
                          ),
                          child: Text(
                            "Document Name",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        TextFormField(
                          obscureText: false,
                          validator: (input) {
                            if (input != null && input.isEmpty)
                              return 'Please enter some text';
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Aadhar Card",
                            prefixIcon: Icon(FeatherIcons.file),
                          ),
                          onSaved: (input) => _fileName = input!,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: GestureDetector(
                  onTap: selectFile,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width / 20,
                      vertical: 20.0,
                    ),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(10),
                      dashPattern: [10, 4],
                      strokeCap: StrokeCap.round,
                      color: Colors.blue.shade400,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.blue.shade50.withOpacity(.3),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_open,
                              color: Colors.blue,
                              size: 40,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Select Document',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey.shade400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              (show == false || _progress == 100)
                  ? Container()
                  : LinearProgressIndicator(
                      value: _progress,
                      color: Colors.red,
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavBar(),
    );
  }
}
