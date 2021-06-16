import 'dart:convert';
import 'package:abrakadabar/helper/dio.dart';
import 'package:abrakadabar/model/Materi.dart';
import 'package:abrakadabar/model/NilaiUser.dart';
import 'package:abrakadabar/model/Soals.dart';
import 'package:abrakadabar/model/User.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:abrakadabar/helper/Storage.dart';
import 'package:flutter/material.dart';
import 'package:abrakadabar/model/AllMateri.dart';

class MateriAPI extends ChangeNotifier {
  Future<AllMateri> fetchAll(credentials) async {
    final token = await Storage().readToken();
    final res = await dio().post('materi/all',
        data: credentials,
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
    if (res.statusCode == 200) {
      // print(res.data);
      return AllMateri.fromJson(res.data);
    } else {
      AllMateri list = AllMateri(allmateri: []);
      return list;
    }
  }

  Future<NilaisUser> fetchNilai(credentials) async {
    final token = await Storage().readToken();
    final res = await dio().post('nilai',
        data: credentials,
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
    if (res.statusCode == 200) {
      return NilaisUser.fromJson(res.data);
    } else {
      NilaisUser list = NilaisUser(nilaiuser: []);
      return list;
    }
  }

  Future<Soals> fetchAllSoal(credentials) async {
    final token = await Storage().readToken();
    final res = await dio().post('soal/all',
        data: credentials,
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
    if (res.statusCode == 200) {
      return Soals.fromJson(json.decode(res.data.toString()));
    } else {
      Soals list = Soals(soals: []);
      return list;
    }
  }

  Future<Users> fetchAllUsers(credentials) async {
    final token = await Storage().readToken();
    final res = await dio().post('users',
        data: credentials,
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
    if (res.statusCode == 200) {
      return Users.fromJson(json.decode(res.data.toString()));
    } else {
      Users list = Users(users: []);
      return list;
    }
  }

  Future<Materi> fetchMateri(credentials) async {
    final token = await Storage().readToken();
    final res = await dio().post('materi',
        data: credentials,
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
    return Materi.input(res.data);
  }

  Future<Soal> fetchSoal(credentials) async {
    final token = await Storage().readToken();
    final res = await dio().post('soal',
        data: credentials,
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
    return Soal.fromJson(res.data);
  }
}
