import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lupa Password"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(children: [
                Text("Silahkan Menghubungi Admin", style: TextStyle(
                  fontWeight: FontWeight.bold
                ),),
                Text("@Admin", style: TextStyle(
                    fontWeight: FontWeight.bold
                )),
              ],)

            ],
          )
        ],
      ),
    );
  }
}

