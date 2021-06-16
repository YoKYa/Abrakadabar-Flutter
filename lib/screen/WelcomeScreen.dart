import 'dart:async';

import 'package:abrakadabar/model/User.dart';
import 'package:flutter/material.dart';
import 'package:abrakadabar/helper/Auth.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    checkIsLoggedIn();
  }

  void checkIsLoggedIn() async {
    await Provider.of<Auth>(context, listen: false).requestCheckMe();
  }

  Future push(BuildContext context, cek, res) {
    if (cek) {
      if (res == 'null') {
        return Navigator.pushNamed(context, '/detail');
      } else {
        return Navigator.pushNamed(context, '/home');
      }
    } else {
      return Navigator.pushNamed(context, '/login');
    }
  }

  Future<User> cek() async {
    return await context.watch<Auth>().user;
  }

  @override
  Widget build(BuildContext context) {
    var _checkLoggedIn = context.watch<Auth>().isAuthenticated;

    return Scaffold(
      backgroundColor: Color.fromRGBO(29, 172, 234, 1),
      body: FutureBuilder<User>(
        future: cek(),
        builder: (context, ss) {
          if (ss.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (ss.hasData) {
              return Container(
                child: InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(),
                      Column(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/logo.png',
                                  width: 200,
                                  height: 200,
                                ),
                              ]),
                          Text(
                            'ABRAKADABAR',
                            style: TextStyle(
                                color: Color.fromRGBO(254, 254, 254, 1),
                                fontSize: 30,
                                fontFamily: 'Handlee'),
                          ),
                          Text('Ayo Belajar Menulis Karangan Dari Gambar',
                              style: TextStyle(
                                color: Color.fromRGBO(254, 254, 254, 1),
                              )),
                        ],
                      ),
                      Column(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('KLIK LAYAR UNTUK MELANJUTKAN',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Column(),
                    ],
                  ),
                  onTap: () {
                    push(context, _checkLoggedIn, ss.data!.detail);
                  },
                ),
              );
            } else if (ss.hasError) {
              return Container(
                child: InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(),
                      Column(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/logo.png',
                                  width: 200,
                                  height: 200,
                                ),
                              ]),
                          Text(
                            'ABRAKADABAR',
                            style: TextStyle(
                                color: Color.fromRGBO(254, 254, 254, 1),
                                fontSize: 30,
                                fontFamily: 'Handlee'),
                          ),
                          Text('Ayo Belajar Menulis Karangan Dari Gambar',
                              style: TextStyle(
                                color: Color.fromRGBO(254, 254, 254, 1),
                              )),
                        ],
                      ),
                      Column(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Silahkan Masuk Kembali \natau\n Tunggu beberapa saat jika kamu pernah login.',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        ],
                      ),
                      Column(),
                    ],
                  ),
                  onTap: () async {
                    await Future.delayed(Duration(seconds: 1));
                    push(context, _checkLoggedIn, ss.data?.detail);
                  },
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      //       body:
    );
  }
}
