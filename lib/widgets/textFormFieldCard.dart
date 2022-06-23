import 'package:flutter/material.dart';

class textFormFieldCard extends StatefulWidget {
  String? header;
  Icon? icon;
  String? hintText;
  bool? obscureText;

  textFormFieldCard(
      {required this.header,
      required this.icon,
      required this.hintText,
      required this.obscureText});
  @override
  State<textFormFieldCard> createState() => _textFormFieldCardState();
}

class _textFormFieldCardState extends State<textFormFieldCard> {
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
                widget.header!,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 5),
            TextFormField(
              obscureText: widget.obscureText!,
              validator: (input) {
                if (input != null && input.isEmpty)
                  return 'Please enter some text';
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText!,
                prefixIcon: widget.icon!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
