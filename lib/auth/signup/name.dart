import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads/auth/signup/connection_page.dart';
import 'package:threads/state/auth.state.dart';

/* import 'account.dart'; */

class NamePage extends StatefulWidget {
  final VoidCallback? loginCallback;
  const NamePage({Key? key, this.loginCallback}) : super(key: key);

  @override
  _NamePageState createState() => _NamePageState();
}

bool empt = false;
bool _isLoading = false;
final GlobalKey<ScaffoldState> globalScaffoldKey = GlobalKey<ScaffoldState>();

class _NamePageState extends State<NamePage> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    setState(() {
      _nameController.text.isNotEmpty ? empt = true : empt = false;
    });
    super.initState();
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExecptionALertDialog(
      context,
      title: 'Sign in failed',
      exception: exception,
    );
  }

  Future<void> _signInWithGoogle(context) async {
    try {
      setState(() => _isLoading = true);
      final auth = Provider.of<AuthState>(context, listen: false);
      await auth.signInWithGoogle(context);
    } on Exception catch (e) {
      _showSignInError(context, e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  children: [
                    Image.asset(
                      "assets/TOUTLAISSE.jpg",
                      height: MediaQuery.of(context).size.height / 1.5,
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topRight,
                          colors: [
                            Colors.black.withOpacity(1),
                            Colors.black.withOpacity(1),
                            Colors.black.withOpacity(1),
                            Colors.black.withOpacity(1),
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.025),
                            Colors.black.withOpacity(0.0),
                            Colors.black.withOpacity(0.0),
                            Colors.black.withOpacity(0.0),
                            Colors.black.withOpacity(0.0),
                            Colors.black.withOpacity(0.0),
                            Colors.black.withOpacity(0.0),
                            Colors.black.withOpacity(0.0),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ConnectionPage()));
                },
                child: Container(
                  height: 35,
                  width: 150,
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: Color(0xff0a0a0a),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Login with Email",
                      style: TextStyle(
                          color: Color.fromARGB(255, 123, 123, 123),
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )),
            Container(
              height: 10,
            ),
            LoginButton(
              socialText: "Google",
              socialImage: "assets/Google.png",
              touch: () {
                _signInWithGoogle(context);
              },
            ),
            Container(
              height: 10,
            ),
            LoginButton(
              socialText: "Apple",
              socialImage: "assets/apple.png",
              touch: () {},
            ),
            Container(
              height: 10,
            ),
            LoginButton(
              socialText: "Facebook",
              socialImage: "assets/facebook.png",
              touch: () {},
            ),
            Container(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.socialText,
    required this.socialImage,
    required this.touch,
  });
  final String socialText;
  final String socialImage;
  final VoidCallback touch;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: touch,
      child: Container(
        height: 70,
        width: 330,
        padding: EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          color: Color(0xff0a0a0a),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Log in on " + socialText,
                  style: TextStyle(
                      color: Color.fromARGB(255, 123, 123, 123),
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                Container(
                  height: 3,
                ),
                Text(
                  socialText + " account",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Container(
              width: 50,
            ),
            Padding(
                padding:
                    EdgeInsets.only(left: 14, top: 14, bottom: 14, right: 4),
                child: Image.asset(socialImage))
          ],
        ),
      ),
    );
  }
}
