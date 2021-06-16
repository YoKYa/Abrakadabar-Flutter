import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  final storage = new FlutterSecureStorage();
  final keyAuth = 'auth';

  Future readToken() async {
    return await storage.read(key: keyAuth);
  }

  Future saveToken(token) async {
    await storage.write(key: keyAuth, value: token);
  }

  Future deleteToken() async {
    await storage.delete(key: keyAuth);
  }
}
