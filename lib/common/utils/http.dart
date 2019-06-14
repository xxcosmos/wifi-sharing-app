import 'package:dio/dio.dart';
BaseOptions options = new BaseOptions(
  connectTimeout: 2000,
);
Dio dio = new Dio(options);