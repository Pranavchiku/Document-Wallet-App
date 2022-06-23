import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class documentCard extends StatefulWidget {
  String? documentName;
  // String? description;
  Icon? icon;
  Reference? ref;

  documentCard({
    required this.documentName,
    // required this.description,
    required this.ref,
    required this.icon,
  });
  @override
  State<documentCard> createState() => _documentCardState();
}

class _documentCardState extends State<documentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Color.fromRGBO(0, 0, 0, 0.1),
            )
          ]),
      child: Container(
        padding: EdgeInsets.only(
          left: 20,
          top: 10,
          bottom: 10,
          right: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.indigo[100],
              ),
              child: widget.icon!,
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.documentName!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                // SizedBox(height: 5),
                // Text(
                //   widget.description!,
                //   style: TextStyle(fontSize: 10, color: Colors.grey),
                // ),
              ],
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                widget.ref!.delete();
                setState(() {});
              },
              icon: Icon(Icons.delete, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
