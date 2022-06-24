import 'package:flutter/material.dart';

class profileCard extends StatefulWidget {
  String? name;
  String? occupation;
  String? imagePath;

  profileCard({
    required this.imagePath,
    required this.name,
    required this.occupation,
  });

  @override
  State<profileCard> createState() => _profileCardState();
}

class _profileCardState extends State<profileCard> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      height: 260,
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
          top: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: size.height / 8,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.all(Radius.circular(10)),
                //   image: DecorationImage(
                //     image: NetworkImage(
                //       widget.imagePath!,
                //     ),
                //   ),
                // ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                  child: Image.network(
                    widget.imagePath!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: size.width - 40,
                ),
                child: Text(
                  widget.name!,
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                widget.occupation!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // expenditure(amount: "\$8900", as: "Income"),
                // expenditure(amount: "\$5500", as: "Expenses"),
                // expenditure(amount: "\$890", as: "Loan"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
