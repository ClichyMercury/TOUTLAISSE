import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads/animation/loader.dart';
import 'package:threads/auth/signup/resetPassword.dart';
import 'package:threads/auth/signup/signup.dart';
import 'package:threads/state/auth.state.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController pwCtrl = TextEditingController();
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> globalScaffoldKey = GlobalKey<ScaffoldState>();

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

  void _submit(context) async {
    try {
      setState(() => _isLoading = true);
      final auth = Provider.of<AuthState>(context, listen: false);
      await auth.signIn(emailCtrl.text, pwCtrl.text, context,
          scaffoldKey: globalScaffoldKey);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      showExecptionALertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
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
        elevation: 0.0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const ResetPassword()));
              },
              child: Text(
                "Forgot Password ?",
                style: TextStyle(color: Colors.black, fontSize: 13),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
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
            textFild(
                hintTxt: "Email",
                controller: emailCtrl,
                enabled: true,
                keyBordType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.login),
            SizedBox(height: 10),
            PWtextFild(
                controller: pwCtrl,
                enabled: true,
                hintTxt: "password",
                textInputAction: TextInputAction.done,
                keyBordType: TextInputType.visiblePassword),
            SizedBox(height: 11.5),
            SizedBox(height: 11.5),
            Mainbutton(
              onTap: () {
                if (emailCtrl.text.isNotEmpty && pwCtrl.text.isNotEmpty) {
                  _submit(context);
                } else {
                  showAlertDialog(context,
                      title: "Email or Password",
                      content:
                          "Make sure Email Field and Password Field is not empty before Submit",
                      defaultActionText: "OK");
                }
              },
              text: "L  O  G  I  N",
              btnColor: Colors.black,
              loading: _isLoading,
            ),
            SizedBox(height: 20.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account ?  ",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const Signup()));
                  },
                  child: const Text(
                    "Create here",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Mainbutton extends StatelessWidget {
  final Function() onTap;
  final String text;
  final String? image;
  final Color? txtColor;
  final Color btnColor;
  final bool loading;
  const Mainbutton({
    Key? key,
    required this.onTap,
    required this.text,
    this.image,
    this.txtColor,
    required this.btnColor,
    required this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        height: 52.0,
        width: 320,
        decoration: BoxDecoration(
          color: btnColor,
          border: Border.all(width: 1.0, color: Colors.white),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null)
              Image.asset(
                'assets/images/$image',
                height: 25.0,
                width: 60.0,
              ),
            loading
                ? const Loader()
                : Text(
                    text,
                    style: TextStyle(
                        fontWeight: FontWeight.w800, color: Colors.white),
                  )
          ],
        ),
      ),
    );
  }
}

Future showAlertDialog(
  BuildContext context, {
  required String title,
  required String content,
  String? cancelActionText,
  required String defaultActionText,
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            Icons.warning,
            color: Colors.white,
          ),
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            content,
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
          ),
          actions: [
            if (cancelActionText != null)
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(cancelActionText),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(defaultActionText),
            ),
          ],
        );
      });
}

Future<void> showExecptionALertDialog(
  BuildContext context, {
  required String title,
  required Exception exception,
}) =>
    showAlertDialog(context,
        title: title, content: _message(exception), defaultActionText: "OK");

String _message(Exception exception) {
  if (exception is FirebaseException) {
    return exception.message!;
  }
  return exception.toString();
}

Widget textFild({
  required String hintTxt,
  required TextEditingController controller,
  bool isObs = false,
  TextInputType? keyBordType,
  TextInputAction? textInputAction,
  FocusNode? focusNode,
  String? errorText,
  required bool enabled,
  IconData? prefixIcon,
}) {
  return Container(
    height: 45.0,
    width: 310,
    decoration: BoxDecoration(
      color: Colors.black,
      border: Border.all(width: 1.0, color: Colors.white),
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 45,
          width: 300.0,
          child: TextField(
            showCursor: true,
            focusNode: focusNode,
            textInputAction: textInputAction,
            autocorrect: false,
            controller: controller,
            textAlignVertical: TextAlignVertical.center,
            obscureText: isObs,
            keyboardType: keyBordType,
            decoration: InputDecoration(
                prefixIcon: Icon(
                  prefixIcon,
                  color: Colors.white,
                ),
                enabled: enabled,
                errorText: errorText,
                border: InputBorder.none,
                hintText: hintTxt,
                hintStyle: TextStyle(fontSize: 15, color: Colors.white)),
          ),
        ),
      ],
    ),
  );
}

// ignore: must_be_immutable
class PWtextFild extends StatefulWidget {
  PWtextFild({
    Key? key,
    required this.controller,
    required this.enabled,
    required this.hintTxt,
    this.textInputAction,
    required this.keyBordType,
  }) : super(key: key);

  FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextEditingController controller;
  bool isObs = false;
  final TextInputType keyBordType;
  String? errorText;
  final bool enabled;
  final String hintTxt;

  @override
  State<PWtextFild> createState() => _PWtextFildState();
}

class _PWtextFildState extends State<PWtextFild> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      width: 310,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(width: 1.0, color: Colors.white),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            width: 300.0,
            child: TextField(
              showCursor: true,
              focusNode: widget.focusNode,
              textInputAction: widget.textInputAction,
              autocorrect: false,
              controller: widget.controller,
              textAlignVertical: TextAlignVertical.center,
              obscureText: widget.isObs,
              keyboardType: widget.keyBordType,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.key,
                    color: Colors.white,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.isObs = !widget.isObs;
                      });
                    },
                    child: widget.isObs
                        ? Icon(
                            Icons.visibility,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.visibility_off,
                            color: Colors.white,
                          ),
                  ),
                  enabled: widget.enabled,
                  errorText: widget.errorText,
                  border: InputBorder.none,
                  hintText: widget.hintTxt,
                  hintStyle: TextStyle(fontSize: 15, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
