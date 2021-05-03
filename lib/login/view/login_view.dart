import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/login_service.dart';
import '../viewmodel/login_cubit.dart';
import 'login_detail_view.dart';

class LoginView extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final String baseUrl = 'https://reqres.in/api';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        formKey,
        emailController,
        passwordController,
        service: LoginService(Dio(BaseOptions(baseUrl: baseUrl))),
      ),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginComplete) {
            state.navigate(context);
          }
        },
        builder: (context, state) {
          return buildScaffold(context, state);
        },
      ),
    );
  }

  Scaffold buildScaffold(BuildContext context, LoginState state) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Form(
        key: formKey,
        autovalidateMode: autovalidateMode(state),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTextFormFieldLogin(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            buildTextFormFieldPassword(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            buildElevatedButtonLogin(context)
          ],
        ),
      ),
    );
  }

  Widget buildElevatedButtonLogin(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoginComplete) {
          return Card(
            child: Icon(Icons.check),
          );
        }
        return ElevatedButton(
          onPressed: context.watch<LoginCubit>().isLoading
              ? null
              : () {
                  context.read<LoginCubit>().postUserModel();
                },
          child: Text('Save'),
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Cubit Login'),
      leading: Visibility(
          visible: context.watch<LoginCubit>().isLoading, child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator())),
    );
  }

  AutovalidateMode autovalidateMode(LoginState state) =>
      state is LoginValidateState ? (state.isValidate ? AutovalidateMode.always : AutovalidateMode.disabled) : AutovalidateMode.disabled;

  TextFormField buildTextFormFieldLogin() {
    return TextFormField(
      controller: emailController,
      validator: (value) => (value ?? '').length > 6 ? null : '6 ten kucuk',
      decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Email'),
    );
  }

  TextFormField buildTextFormFieldPassword() {
    return TextFormField(
      controller: passwordController,
      validator: (value) => (value ?? '').length > 5 ? null : '5 ten kucuk',
      decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Password'),
    );
  }
}

extension LoginCompleteExtension on LoginComplete {
  void navigate(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LoginDetialView(
        model: model,
      ),
    ));
  }
}
