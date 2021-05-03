import 'dart:io';

import 'package:dio/dio.dart';

import '../model/login_request_model.dart';
import '../model/login_response.dart';
import 'ILoginService.dart';

class LoginService extends ILoginService {
  LoginService(Dio dio) : super(dio);

  @override
  Future<LoginResponeModel?> postUserLogin(LoginRequestModel model) async {
    final response = await dio.post(loginPath, data: model);

    if (response.statusCode == HttpStatus.ok) {
      return LoginResponeModel.fromJson(response.data);
    } else {
      return null;
    }
  }
}
