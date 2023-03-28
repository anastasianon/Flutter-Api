import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../utils/url.dart';
import '../models/user.dart';
import '../screens/signIn_screen.dart';
import '../interceptors/custom_interceptor.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  Dio DIO = Dio();

  Future<void> register() async {
    try {
      String userName = controllerUsername.text;
      String email = controllerEmail.text;
      String password = controllerPassword.text;

      DIO.interceptors.add(CustomInterceptor());
      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
      await DIO.put(URL.token.value, data: User(userName: userName, email: email, password: password));
    } on DioError {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Логин уже занят', textAlign: TextAlign.center)));
    }
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
                        validator: ((value) {
                          if (value == null || value.isEmpty) {
                            return "Логин не должен быть пустым";
                          }
                          if (value.length < 7 || value.length >= 10) {
                            return "Логин должен быть от 7 до 10 символов";
                          }
                          return null;
                        }),
                        decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "Логин"),
                        style: TextStyle(fontSize: 22),
                      ),
                      const Padding(padding: EdgeInsets.fromLTRB(25, 5, 25, 20)),
                      TextFormField(
                        controller: controllerEmail,
                        validator: ((value) {
                          if (value == null || value.isEmpty) {
                            return "Email не должен быть пустым";
                          }
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return "Email введен неправильно";
                          }
                          return null;
                        }),
                        decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "Email"),
                        style: TextStyle(fontSize: 22),
                      ),
                      const Padding(padding: EdgeInsets.fromLTRB(25, 5, 25, 20)),
                      TextFormField(
                        controller: controllerPassword,
                        validator: ((value) {
                          if (value == null || value.isEmpty) {
                            return "Пароль не должен быть пустым";
                          }
                          if (value.length < 7 || value.length >= 10) {
                            return "Пароль должен быть от 7 до 10 символов";
                          }
                          return null;
                        }),
                        decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "Пароль"),
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
                        onPressed: () async {
                          if (!key.currentState!.validate()) return;
                          register();
                        },
                        child: const Text("Зарегистрироваться"),
                        style: ElevatedButton.styleFrom(
                primary: Colors.purple,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold)),),
                    const Padding(padding: EdgeInsets.fromLTRB(25, 5, 25, 5)),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                        },
                        child: const Text("Назад"),
                        style: ElevatedButton.styleFrom(
                primary: Colors.purple,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold)),),
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
