import 'package:document_wallet/index.dart';
import 'package:document_wallet/widgets/textFormFieldCard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // await availableCameras();
  // await FlutterDownloader.initialize(
  //     debug: true // optional: set false to disable printing logs to console
  // );

  runApp(
    MaterialApp(
      home: LandingPage(),
      theme: new ThemeData(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User user;
  bool isloggedin = false;
  getUser() async {
    User? firebaseUser = _auth.currentUser;
    await firebaseUser!.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser!;
        this.isloggedin = true;
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Index()), (route) => false);
      });
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _email, _password;
  Future<UserCredential> googleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        final UserCredential user =
            await _auth.signInWithCredential(credential);

        await Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Index()), (route) => false);

        return user;
      } else {
        throw StateError('Missing Google Auth Token');
      }
    } else
      throw StateError('Sign in Aborted');
  }

  login() async {
    if (_formKey != null &&
        _formKey.currentState != null &&
        _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _auth.signInWithEmailAndPassword(
            email: _email!, password: _password!);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Index()), (route) => false);
      } catch (e) {
        showError("Error here");
      }
    }
  }

  showError(String errormessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ERROR'),
          content: Text(errormessage),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // this.checkAuthentification();
    this.getUser();
  }

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
          width: size.width,
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/logo.png'),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
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
                                "Email Address",
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
                                hintText: "Username@gmail.com",
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              onSaved: (input) => _email = input!,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
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
                                "Password",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              obscureText: true,
                              validator: (input) {
                                if (input != null && input.isEmpty)
                                  return 'Please enter some text';
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "********",
                                prefixIcon: Icon(Icons.lock),
                              ),
                              onSaved: (input) => _password = input!,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: login,
                elevation: 0,
                padding: EdgeInsets.all(18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: Colors.indigo[700],
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              // SizedBox(height: 40),
              Row(children: <Widget>[
                Expanded(child: Divider()),
                Text("  OR SIGN IN WITH  "),
                Expanded(child: Divider()),
              ]),
              // SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20,
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.apple,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: googleSignIn,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20,
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // child: Icon(
                      //   FeatherIcons.github,
                      //   color: Colors.black,
                      // ),
                      child: SvgPicture.asset(
                        'assets/google icon.svg',
                        height: 10,
                        width: 10,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.facebook,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 30),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Sign up",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(width: size.width / 2.1),
                  Text(
                    "Forgot password?",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
