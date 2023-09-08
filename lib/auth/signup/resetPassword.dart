import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:threads/auth/signup/connection_page.dart';
/* import 'package:provider/provider.dart'; */

TextEditingController emailCtrl = TextEditingController();
final user = FirebaseAuth.instance.currentUser!;
bool _isLoading = false;

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
/*   @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  } */

  @override
  Widget build(BuildContext context) {
/*     Future<void> resetPassword(context) async {
      try {
        setState(() => _isLoading = true);
        final auth = Provider.of<AuthBase>(context, listen: false);
        await auth.resetPassword(emailCtrl.text);
      } on FirebaseAuthException catch (e) {
        print(e.toString());
        showExecptionALertDialog(
          context,
          title: 'reset password failed',
          exception: e,
        );
      } finally {
        setState(() => _isLoading = false);
        resetPasswordCustumAlertDialog(context,
            title: "Check your mailbox",
            content:
                "We have sent you a link in your mailbox to allow you to reset your password",
            defaultActionText: "OK");
        /*  */
      }
    } */

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
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
          SizedBox(height: 25),
          textFild(
              hintTxt: "Email",
              controller: emailCtrl,
              keyBordType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              enabled: true,
              prefixIcon: Icons.login),
          SizedBox(height: 25),
          Mainbutton(
            onTap: () {
              if (emailCtrl.text.isNotEmpty) {
                /* resetPassword(context); */
              } else {
                showAlertDialog(context,
                    title: "Email ",
                    content: "Make sure Email Field is not empty before Submit",
                    defaultActionText: "OK");
              }
            },
            text: "Reset Password",
            btnColor: Colors.black,
            loading: _isLoading,
          ),
        ]),
      ),
    );
  }
}

Future resetPasswordCustumAlertDialog(
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
            color: Colors.black,
          ),
          title: Text(
            title,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          content: Text(
            content,
            style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          ),
          actions: [
            if (cancelActionText != null)
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(cancelActionText),
              ),
            TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => ConnectionPage())),
              child: Text(defaultActionText),
            ),
          ],
        );
      });
}
