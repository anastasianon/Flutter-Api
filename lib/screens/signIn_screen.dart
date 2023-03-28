import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/url.dart';
import '../models/user.dart';
import '../screens/user_sceen.dart';
import '../screens/signUp_screen.dart';
import '../interceptors/custom_interceptor.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  SharedPreferences? sharedPreferences;
  Dio DIO = Dio();

  Future<void> initSharedPreferences() async =>
      sharedPreferences = await SharedPreferences.getInstance();

  void setTokenSharedPreferences(String token) async =>
      await sharedPreferences!.setString('token', token);

  Future<void> auth() async {
    try {
      String userName = controllerUsername.text;
      String password = controllerPassword.text;

      DIO.interceptors.add(CustomInterceptor());

      Response response = await DIO.post(URL.token.value,
          data: User(userName: userName, password: password));
      setTokenSharedPreferences(response.data['data']['accessToken']);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const UserScreen()));
    } on DioError {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Неверный логин или пароль', textAlign: TextAlign.center)));
    }
  }

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(160, 200, 300, 400),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
              child: Center(
                child: Form(
                  key: key,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controllerUsername,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(), labelText: "Логин"),
                            style: TextStyle(fontSize: 22),
                      ),
                      const Padding(
                          padding: EdgeInsets.fromLTRB(25, 5, 25, 20)),
                      TextFormField(
                        controller: controllerPassword,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(), labelText: "Пароль"),
                            style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 5, 25, 10),
              child: Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async => auth(),
                      child: const Text("Войти"),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(25, 5, 25, 5)),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen())),
                      child: const Text("Зарегистрироваться"),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
