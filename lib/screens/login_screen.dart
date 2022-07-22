import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login_mysql/providers/login_form_provider.dart';
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
                paddingHorizontal: 30,
                paddingContainer: 20,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Inicio de Sesion', style:Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _LoginForm(),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),
              CardContainer(
                paddingHorizontal: 5,
                paddingContainer: 5,
                child: TextButton(
                  onPressed: (() =>
                      Navigator.pushReplacementNamed(context, 'register')),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child: const Text(
                    'Crear una nueva cuenta',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black87),
                  ),
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
  final userController = TextEditingController();
  final pwdController = TextEditingController();

  Future userLogin() async {
    //Login API URL
    //use your local IP address instead of localhost or use Web API
    var url = "http://192.168.0.77/login_api/login.php";

    // Showing LinearProgressIndicator.
    setState(() {
    });

    // Getting username and password from Controller
    var data = {
      'username': userController.text,
      'password': pwdController.text,
    };

    //Starting Web API Call.
    var response = await http.post(Uri.parse(url), body: json.encode(data));
    if (response.statusCode == 200) {
      //Server response into variable
      // ignore: avoid_print
      print(response.body);
      var msg = jsonDecode(response.body);

      //Check Login Status
      if (msg['loginStatus'] == true) {
        setState(() {
          //hide progress indicator
        });

        // Navigate to Home Screen
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, 'home');
      } else {
        setState(() {
          //hide progress indicator

          //Show Error Message Dialog
          showMessage(msg["message"]);
        });
      }
    } else {
      setState(() {
        //hide progress indicator

        //Show Error Message Dialog
        showMessage("Error during connecting to Server.");
      });
    }
  }

  Future<dynamic> showMessage(String msg) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msg),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              controller: userController,
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
              controller: pwdController,
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
                if (loginForm.formKey.currentState!.validate()) {userLogin()}
              },
              color: Colors.grey,
              elevation: 0,
              disabledColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                      loginForm.isLoading ? 'Espere...' : 'Iniciar sesión',
                      style: const TextStyle(color: Colors.black,  fontSize: 17))),
            )
          ],
        ),
      ),
    );
  }
}
