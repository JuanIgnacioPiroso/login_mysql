import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:login_mysql/providers/login_form_provider.dart';
import 'package:login_mysql/screens/home_screen.dart';
import 'package:login_mysql/ui/input_decorations.dart';
import 'package:login_mysql/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Login', style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                onPressed: (() =>
                    Navigator.pushReplacementNamed(context, 'register')),
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        Colors.indigo.withOpacity(0.1)),
                    shape: MaterialStateProperty.all(const StadiumBorder())),
                child: const Text(
                  'Crear una nueva cuenta',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  bool _visible = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String _errorMessage = '';

  Future login() async {
    var url = "http://192.168.0.77/login_mysql/login.php";
    var response = await http.post(Uri.parse(url), body: {
      "email": email.text,
      "contraseña": password.text,
    });
    var data = json.encode(response.body);
    if (data == "Success") {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Email y/o contraseña incorrecto'),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    // ignore: avoid_unnecessary_containers
    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              controller: email,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'example@gmail.com',
                  labelText: 'Correo electrónico',
                  prefixIcon: Icons.alternate_email_rounded),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'Ingrese un correo válido';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: password,
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*********',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe ser de 6 caracteres como mínimo';
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
              onPressed: () => {
                if (loginForm.formKey.currentState!.validate()) {login()}
              },
              color: Colors.deepPurple,
              elevation: 0,
              disabledColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                      loginForm.isLoading ? 'Espere...' : 'Iniciar sesión',
                      style: const TextStyle(color: Colors.white))),
            )
          ],
        ),
      ),
    );
  }
}
