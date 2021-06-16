import 'package:abrakadabar/helper/Auth.dart';
import 'package:abrakadabar/screen/ForgotPasswordScreen.dart';
import 'package:abrakadabar/screen/ProfilPengembangMedia.dart';
import 'package:abrakadabar/screen/daftar/DaftarGuruAdminScreen.dart';
import 'package:abrakadabar/screen/daftar/DaftarGuruAdminUnScreen.dart';
import 'package:abrakadabar/screen/daftar/DaftarGuruScreen.dart';
import 'package:abrakadabar/screen/game/GameTigaScreen.dart';
import 'package:abrakadabar/screen/game/ModeGameScreen.dart';
import 'package:abrakadabar/screen/guru/PetunjukPengisianScreen.dart';
import 'package:abrakadabar/screen/siswa/AturanPermainanScreen.dart';
import 'package:abrakadabar/screen/siswa/DaftarSkorSiswaScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screen/WelcomeScreen.dart';
import 'screen/HomeScreen.dart';
import 'screen/RegisterScreen.dart';
import 'screen/LoginScreen.dart';
import 'screen/ForgotPasswordScreen.dart';
import 'screen/DetailScreen.dart';
import 'screen/daftar/DaftarSiswaScreen.dart';
import 'screen/materi/AddMateriScreen.dart';
import 'screen/materi/SoalGambarScreen.dart';
import 'screen/materi/ModeScreen.dart';
import 'helper/Auth.dart';
import 'screen/materi/listmode/ListSoalScreen.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => Auth(),
      child: MaterialApp(
        home: WelcomeScreen(),
        routes: {
          '/home': (context) => HomeScreen(),
          '/register': (context) => RegisterScreen(),
          '/login': (context) => LoginScreen(),
          '/forgotpassword': (context) => ForgotPasswordScreen(),
          '/detail': (context) => DetailScreen(),
          '/addMatery': (context) => AddMateriScreen(title: 'Pengisian Materi'),
          '/soalGambar': (context) => SoalGambarScreen(num: 1),
          '/modeList': (context) => ModeScreen(),
          '/soalAll': (context) => ListSoalScreen(),
          '/daftarGuru': (context) => DaftarGuruScreen(status: 'Guru'),
          '/daftarGuruAdmin': (context) =>
              DaftarGuruAdminScreen(status: 'Guru'),
          '/daftarGuruAdminUn': (context) =>
              DaftarGuruAdminUnScreen(status: 'Guru'),
          '/daftarSkorSiswa': (context) =>
              DaftarSkorSiswaScreen(status: 'Siswa'),
          '/daftarSiswaAdmin': (context) =>
              DaftarGuruAdminScreen(status: 'Siswa'),
          '/daftarSiswa': (context) => DaftarSiswaScreen(status: 'Siswa'),
          '/profilPengembang': (context) => ProfilPengembangMediaScreen(),
          '/petunjukGuru': (context) => PetunjukPengisianScreen(),
          '/modeGame': (context) => ModeGameScreen(),
          '/gameTiga': (context) => GameTigaScreen(),
          '/petunjukSiswa': (context) => AturanPermainanScreen(),
        },
        theme: ThemeData(
            fontFamily: 'Spartan',
            primaryColor: Color.fromRGBO(29, 172, 234, 1)),
      )));
}
