import 'package:flutter/material.dart';
import 'package:abrakadabar/helper/Auth.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _passwordConfirmCtrl = TextEditingController();
  final _formKeySiswa = GlobalKey<FormState>();
  final _formKeyGuru = GlobalKey<FormState>();

  bool _hasError = false;
  String _errorMsg = "";

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordConfirmCtrl.dispose();
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

  Future submitRegisterMurid(BuildContext context) async {
    String _status = "2";
    var result = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(Auth().requestRegister({
              'name': _nameCtrl.text,
              'username': _usernameCtrl.text,
              'password': _passwordCtrl.text,
              'password_confirmation': _passwordConfirmCtrl.text,
              'status': _status
            })));
    if (result['status'] == true) {
      AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          dialogType: DialogType.NO_HEADER,
          showCloseIcon: true,
          title: 'Berhasil',
          desc: "Berhasil Mendaftar",
          btnOkOnPress: () {
            Navigator.pushNamed(context, '/login');
            debugPrint('OnClcik');
          },
          headerAnimationLoop: false,
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          })
        ..show();
    } else {
      setState(() {
        _errorMsg = result['error_msg'];
        _hasError = true;
      });
    }
  }
  Future submitRegisterGuru(BuildContext context) async {
    String _status = "1";
    var result = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(Auth().requestRegister({
              'name': _nameCtrl.text,
              'username': _usernameCtrl.text,
              'password': _passwordCtrl.text,
              'password_confirmation': _passwordConfirmCtrl.text,
              'status': _status
            })));
    if (result['status'] == true) {
      AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          dialogType: DialogType.NO_HEADER,
          showCloseIcon: true,
          title: 'Berhasil',
          desc: "Berhasil Mendaftar",
          btnOkOnPress: () {
            Navigator.pushNamed(context, '/login');
            debugPrint('OnClcik');
          },
          headerAnimationLoop: false,
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
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
    var isLoggedIn = context.watch<Auth>().isAuthenticated;
    if (!isLoggedIn) {
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
                        children: [Text("Daftar Sebagai")],
                      ),
                    ),
                    Text(
                      "SISWA",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
                                  formInput(_nameCtrl, "Nama Lengkap", false),
                                  Container(height: 10),
                                  formInput(_usernameCtrl, "Username", false),
                                  Container(height: 10),
                                  formInput(_passwordCtrl, "Kata Sandi", true),
                                  Container(height: 10),
                                  formInput(_passwordConfirmCtrl,
                                      "Ulangi Kata Sandi", true),
                                  Container(height: 10),
                                  Visibility(
                                      visible: _hasError,
                                      child: Column(
                                        children: [
                                          Text("$_errorMsg",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ],
                                      )
                                  ),
                                  Container(height: 10),
                                  Container(
                                    child: Column(
                                      children: [
                                        AnimatedButton(
                                          text: 'Daftar',
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          buttonTextStyle:
                                              TextStyle(fontSize: 16),
                                          pressEvent: () {
                                            submitRegisterMurid(context);
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
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        children: [
                          Text("Sudah Punya Akun?"),
                          TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/login'),
                              child: Text("Klik Disini"))
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
                        children: [Text("Daftar Sebagai")],
                      ),
                    ),
                    Text(
                      "GURU",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
                                  formInput(_nameCtrl, "Nama Lengkap", false),
                                  Container(height: 10),
                                  formInput(_usernameCtrl, "Username", false),
                                  Container(height: 10),
                                  formInput(_passwordCtrl, "Kata Sandi", true),
                                  Container(height: 10),
                                  formInput(_passwordConfirmCtrl,
                                      "Ulangi Kata Sandi", true),
                                  Container(height: 10),
                                  Visibility(
                                      visible: _hasError,
                                      child: Column(
                                        children: [
                                          Text("$_errorMsg",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ],
                                      )),
                                  Container(height: 10),
                                  Container(
                                    child: Column(
                                      children: [
                                        AnimatedButton(
                                          text: 'Daftar',
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          buttonTextStyle:
                                              TextStyle(fontSize: 16),
                                          pressEvent: () {
                                            submitRegisterGuru(context);
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
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        children: [
                          Text("Sudah Punya Akun?"),
                          TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/login'),
                              child: Text("Klik Disini"))
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
    } else {
      Navigator.pushNamed(context, '/home');
      return Scaffold();
    }
  }
}
