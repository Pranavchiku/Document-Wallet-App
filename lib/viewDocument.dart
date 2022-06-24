import 'package:document_wallet/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class viewDocument extends StatefulWidget {
  String? documentUrl;
  String? documentName;
  viewDocument({required this.documentName, required this.documentUrl});

  @override
  State<viewDocument> createState() => _viewDocumentState();
}

class _viewDocumentState extends State<viewDocument> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: size.height * 0.03,
            top: size.height * 0.07,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Document: " + widget.documentName!,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Container(
                  // height: size.height * .8,
                  child: ClipRect(
                    child: InteractiveViewer(
                      panEnabled: false,
                      minScale: 0.5,
                      maxScale: 4.0,
                      boundaryMargin: EdgeInsets.all(10),
                      child: Image.network(
                        widget.documentUrl!,
                        fit: BoxFit.cover,
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) {
                          return child;
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Container(
                              height: size.height * 0.8,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavBar(),
    );
  }
}
