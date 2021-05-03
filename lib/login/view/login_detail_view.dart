import 'package:flutter/material.dart';

import '../model/login_response.dart';

class LoginDetialView extends StatelessWidget {
  final LoginResponeModel model;

  const LoginDetialView({Key? key, required this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.token ?? ''),
      ),
    );
  }
}
