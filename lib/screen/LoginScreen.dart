import 'package:flutter/material.dart';
import 'package:abrakadabar/helper/Auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKeySiswa = GlobalKey<FormState>();
  final _formKeyGuru = GlobalKey<FormState>();

  bool _hasError = false;
  String _errorMsg = "";

  @override
  void initState() {
    super.initState();
    checkIsLoggedIn();
  }

  void checkIsLoggedIn() async {
    await Provider.of<Auth>(context, listen: false).requestCheckMe();
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  TextFormField formInput(controller, label, hidden) {
    return TextFormField(
      controller: controller,
      obscureText: hidden,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
        labelStyle: TextStyle(fontSize: 16),
      ),
    );
  }

  Future submitLoginMurid(BuildContext context) async {
    var result = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
                Provider.of<Auth>(context, listen: false).requestLogin({
              'username': _usernameCtrl.text,
              'password': _passwordCtrl.text,
            })));
    if (result['status'] == true) {
      var res = context.read<Auth>().user;
      AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          dialogType: DialogType.NO_HEADER,
          showCloseIcon: true,
          title: 'Berhasil',
          desc: "Berhasil Masuk",
          btnOkOnPress: () {
            // ignore: unnecessary_null_comparison
            if (res.detail != null) {
              Navigator.pushNamed(context, '/home');
            } else {
              Navigator.pushNamed(context, '/detail');
            }
          },
          headerAnimationLoop: false,
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint('Check $type');
          })
        ..show();
    } else {
      setState(() {
        _errorMsg = result['error_msg'];
        _hasError = true;
      });
    }
  }

  Future submitLoginGuru(BuildContext context) async {
    var result = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
                Provider.of<Auth>(context, listen: false).requestLogin({
              'username': _usernameCtrl.text,
              'password': _passwordCtrl.text,
            })));

    if (result['status'] == true) {
      var res = context.read<Auth>().user;
      AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          dialogType: DialogType.NO_HEADER,
          showCloseIcon: true,
          title: 'Berhasil',
          desc: "Berhasil Masuk",
          btnOkOnPress: () {
            // ignore: unnecessary_null_comparison
            if (res.detail != null && res.detail != '') {
              Navigator.pushNamed(context, '/home');
            } else {
              Navigator.pushNamed(context, '/detail');
            }
          },
          headerAnimationLoop: false,
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint('Check $type');
          })
        ..show();
    } else {
      setState(() {
        _errorMsg = result['error_msg'];
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // check(_checkLoggedIn);
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Container(
              child: Image.asset(
                'images/logo.png',
                width: 150,
                height: 150,
              ),
            ),
            centerTitle: true,
            toolbarHeight: 200,
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text("SISWA"),
                ),
                Tab(
                  child: Text("GURU"),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ListView(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("Masuk Sebagai")],
                    ),
                  ),
                  Text(
                    "SISWA",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    height: 1,
                    color: Colors.grey,
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        children: [
                          Form(
                            key: _formKeySiswa,
                            child: Column(
                              children: [
                                formInput(_usernameCtrl, "Username", false),
                                Container(height: 10),
                                formInput(_passwordCtrl, "Kata Sandi", true),
                                Container(height: 10),
                                Visibility(
                                    visible: _hasError,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "$_errorMsg",
                                              style:
                                                  TextStyle(color: Colors.red),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                                Container(height: 10),
                                Container(
                                  child: Column(
                                    children: [
                                      AnimatedButton(
                                        text: 'Masuk',
                                        borderRadius: BorderRadius.circular(5),
                                        buttonTextStyle:
                                            TextStyle(fontSize: 16),
                                        pressEvent: () {
                                          submitLoginMurid(context);
                                        },
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    height: 1,
                    color: Colors.grey,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Row(
                      children: [
                        Text("Belum Punya Akun?"),
                        TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/register'),
                            child: Text("Klik Disini"))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Row(
                      children: [
                        Text("Atau"),
                        TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/forgotpassword'),
                            child: Text("Lupa Password ?"))
                      ],
                    ),
                  )
                ],
              ),
              ListView(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("Masuk Sebagai")],
                    ),
                  ),
                  Text(
                    "GURU",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    height: 1,
                    color: Colors.grey,
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        children: [
                          Form(
                            key: _formKeyGuru,
                            child: Column(
                              children: [
                                formInput(_usernameCtrl, "Username", false),
                                Container(height: 10),
                                formInput(_passwordCtrl, "Kata Sandi", true),
                                Container(height: 10),
                                Visibility(
                                    visible: _hasError,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "$_errorMsg",
                                              style:
                                                  TextStyle(color: Colors.red),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                                Container(height: 10),
                                Container(
                                  child: Column(
                                    children: [
                                      AnimatedButton(
                                        text: 'Masuk',
                                        borderRadius: BorderRadius.circular(5),
                                        buttonTextStyle:
                                            TextStyle(fontSize: 16),
                                        pressEvent: () {
                                          submitLoginGuru(context);
                                        },
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    height: 1,
                    color: Colors.grey,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Row(
                      children: [
                        Text("Belum Punya Akun?"),
                        TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/register'),
                            child: Text("Klik Disini"))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Row(
                      children: [
                        Text("Atau"),
                        TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/forgotpassword'),
                            child: Text("Lupa Password ?"))
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      theme: ThemeData(fontFamily: 'Spartan'),
    );
  }
}
