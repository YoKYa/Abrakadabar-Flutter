import 'package:abrakadabar/model/Materi.dart';
import 'package:dio/dio.dart' as Dio;
import 'dio.dart';
import 'dart:convert';
import 'package:abrakadabar/helper/Storage.dart';
import 'package:flutter/material.dart';
import 'package:abrakadabar/model/User.dart';

class Auth extends ChangeNotifier {
  late User _user;
  late Materi _materi;
  bool _isAuthenticated = false;

  User get user => _user;
  Materi get materi => _materi;
  bool get isAuthenticated => _isAuthenticated;

  Future requestCheckMe() async {
    try {
      final token = await Storage().readToken();
      final res = await dio().get('me',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      if (res.statusCode == 200) {
        _user = User.fromJson(json.decode(res.data));
        _isAuthenticated = true;
        notifyListeners();
      }
    } on Dio.DioError {
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  Future requestRegister(credentials) async {
    try {
      final res = await dio().post('register', data: credentials);
      if (res.statusCode == 200) {
        return {'status': true};
      }
    } on Dio.DioError catch (e) {
      var _resError = "";
      final _res = jsonDecode(e.response.toString())['errors'];
      _res.forEach((key, val) {
        _resError += "* " + val[0] + "\n";
      });
      return {
        'status': false,
        'error_msg': _resError,
      };
    }
  }

  Future requestLogin(credentials) async {
    try {
      final res = await dio().post('login', data: credentials);
      if (res.statusCode == 200) {
        final token = await json.decode(res.toString())['token'];
        await Storage().saveToken(token);
        final res2 = await dio().get('me',
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        _user = User.fromJson(json.decode(res2.data.toString()));
        notifyListeners();
        _isAuthenticated = true;
        notifyListeners();
        return {
          'status': true,
        };
      }
    } on Dio.DioError catch (e) {
      var _resError = "";
      final _res = jsonDecode(e.response.toString())['errors'];
      _res.forEach((key, val) {
        _resError += "* " + val[0] + "\n";
      });
      return {
        'status': false,
        'error_msg': _resError,
      };
    }
  }

  Future requestLogout() async {
    try {
      final token = await Storage().readToken();
      final res = await dio().post('logout',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      if (res.statusCode == 200) {
        await Storage().deleteToken();
        _isAuthenticated = false;
        notifyListeners();
        return {
          'status': true,
        };
      }
    } on Dio.DioError catch (e) {
      return {
        'status': false,
        'error_msg': e.response,
      };
    }
  }

  Future requestDetail(credentials) async {
    try {
      final token = await Storage().readToken();
      final res = await dio().post('detail',
          data: credentials,
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      final res2 = await dio().get('me',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      _user = User.fromJson(json.decode(res2.data.toString()));
      notifyListeners();
      if (res.statusCode == 200) {
        return {'status': true};
      }
    } on Dio.DioError catch (e) {
      var _resError = "";
      final _res = jsonDecode(e.response.toString())['errors'];
      _res.forEach((key, val) {
        _resError += "* " + val[0] + "\n";
      });
      return {
        'status': false,
        'error_msg': _resError,
      };
    }
  }

  Future requestAccGuru(credentials) async {
    try {
      final token = await Storage().readToken();
      final res = await dio().post('accGuru',
          data: credentials,
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      print(res.data);
      if (res.statusCode == 200) {
        return {'status': true};
      }
    } on Dio.DioError catch (e) {
      var _resError = "";
      final _res = jsonDecode(e.response.toString())['errors'];
      _res.forEach((key, val) {
        _resError += "* " + val[0] + "\n";
      });
      return {
        'status': false,
        'error_msg': _resError,
      };
    }
  }
  Future requestDelUser(credentials) async {
    try {
      final token = await Storage().readToken();
      final res = await dio().post('user/del',
          data: credentials,
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      print(res.data);
      if (res.statusCode == 200) {
        return {'status': true};
      }
    } on Dio.DioError catch (e) {
      var _resError = "";
      final _res = jsonDecode(e.response.toString())['errors'];
      _res.forEach((key, val) {
        _resError += "* " + val[0] + "\n";
      });
      return {
        'status': false,
        'error_msg': _resError,
      };
    }
  }

  // Materi
  Future requestAddMateri(credentials) async {
    try {
      final token = await Storage().readToken();
      final res = await dio().post('materi/add',
          data: await credentials,
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      if (res.statusCode == 200) {
        final res2 = await dio().post('materi',
            data: {'id': res.data['materi']},
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        _materi = Materi.input(res2.data);
        notifyListeners();
        return {'status': true, 'id': res.data['materi']};
      }
    } on Dio.DioError catch (e) {
      var _resError = "";
      final _res = jsonDecode(e.response.toString())['errors'];
      _res.forEach((key, val) {
        _resError += "* " + val[0] + "\n";
      });
      return {
        'status': false,
        'error_msg': _resError,
      };
    }
  }

  Future requestCheckGambar(credentials) async {
    try {
      final token = await Storage().readToken();
      final res = await dio().post('materi',
          data: credentials,
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      if (res.statusCode == 200) {
        _materi = Materi.input(res.data);
        notifyListeners();
        return {'status': true};
      }
    } on Dio.DioError catch (e) {
      var _resError = "";
      final _res = jsonDecode(e.response.toString())['errors'];
      _res.forEach((key, val) {
        _resError += "* " + val[0] + "\n";
      });
      return {
        'status': false,
        'error_msg': _resError,
      };
    }
  }

  Future requestAddSoal(credentials) async {
    try {
      print(credentials.toString());
      final token = await Storage().readToken();
      final res = await dio().post('soal/add',
          data: await credentials,
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      if (res.statusCode == 200) {
        return {'status': true};
      }
    } on Dio.DioError catch (e) {
      var _resError = "";
      final _res = jsonDecode(e.response.toString())['errors'];
      _res.forEach((key, val) {
        _resError += "* " + val[0] + "\n";
      });
      return {
        'status': false,
        'error_msg': _resError,
      };
    }
  }

  Future requestHapusMateri(credentials) async {
    try {
      final token = await Storage().readToken();
      final res = await dio().post('materi/del',
          data: await credentials,
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      if (res.statusCode == 200) {
        return {'status': true};
      }
    } on Dio.DioError catch (e) {
      var _resError = "";
      final _res = jsonDecode(e.response.toString())['errors'];
      _res.forEach((key, val) {
        _resError += "* " + val[0] + "\n";
      });
      return {
        'status': false,
        'error_msg': _resError,
      };
    }
  }

  // Soal
  Future requestAddJawaban(credentials) async {
    try {
      final token = await Storage().readToken();
      final res = await dio().post('jawaban/add',
          data: await credentials,
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      if (res.statusCode == 200) {
        return {'status': true};
      }
    } on Dio.DioError catch (e) {
      var _resError = "";
      final _res = jsonDecode(e.response.toString())['errors'];
      _res.forEach((key, val) {
        _resError += "* " + val[0] + "\n";
      });
      return {
        'status': false,
        'error_msg': _resError,
      };
    }
  }

  // Nilai
  Future requestNilai(credentials) async {
    try {
      final token = await Storage().readToken();
      final res = await dio().post('nilai/add',
          data: await credentials,
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      if (res.statusCode == 200) {
        return {'status': true, 'nilai': res.data['nilai']};
      }
    } on Dio.DioError catch (e) {
      var _resError = "";
      final _res = jsonDecode(e.response.toString())['errors'];
      _res.forEach((key, val) {
        _resError += "* " + val[0] + "\n";
      });
      return {
        'status': false,
        'error_msg': _resError,
      };
    }
  }
}
