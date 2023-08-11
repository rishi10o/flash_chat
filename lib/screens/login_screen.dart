import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_new/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_new/utilities/select_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'loginScreen';

  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late String email;
  late String password;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   iconTheme: const IconThemeData(color: Colors.black54),
      // ),
      backgroundColor: Colors.white,
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: const Center(
          child: SpinKitFadingCube(
            color: Colors.lightBlueAccent,
            size: 50.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'flash_logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                controller: emailTextController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: passwordTextController,
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              SelectButton(
                onTap: () async {
                  try {
                    context.loaderOverlay.show();
                    await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    context.loaderOverlay.hide();
                    if (_auth.currentUser != null) {
                      emailTextController.clear();
                      passwordTextController.clear();
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  } catch (e) {
                    debugPrint(e.toString());
                    context.loaderOverlay.hide();
                    Alert(
                            context: context,
                            title: "Oops!",
                            desc: e.toString().trim())
                        .show();
                  }
                },
                buttonColor: Colors.lightBlueAccent,
                text: 'Log in',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
