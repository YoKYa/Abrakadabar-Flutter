import 'package:dio/dio.dart';

Dio dio() {
  return new Dio(BaseOptions(
      baseUrl: "https://abrakadabar.yokya.id/api/",
      headers: {
        'accept': 'application/json',
        'Content-Type': 'multipart/form-data'
      }));
}
