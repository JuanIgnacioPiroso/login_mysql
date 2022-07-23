import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login_mysql/providers/login_form_provider.dart';
import 'package:login_mysql/ui/input_decorations.dart';
import 'package:login_mysql/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
                    Text('Crear cuenta',
                        style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _RegisterForm(),
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
                      Navigator.pushReplacementNamed(context, 'login')),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.black.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child: const Text(
                    '¿Ya tienes una cuenta?',
                    style: TextStyle(fontSize: 24, color: Colors.black87),
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

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future register() async {
    var url = "http://192.168.0.77/login_api/register.php";
    var response = await http.post(Uri.parse(url), body: {
      'username': email.text,
      'password': password.text,
    });
    var data = json.decode(response.body);
    if (data == "Error") {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Este usuario ya esta registrado!'),
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(content: Text('Registro completo'));
          });
      const AlertDialog(content: Text('Registro completo'));
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushNamed(context, 'login');
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
              controller: name,
              autocorrect: false,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre y Apellido',
                  labelText: 'Nombre y Apellido',
                  prefixIcon: Icons.person),
            ),
            const SizedBox(height: 30),
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
              onPressed: () {
                register();

                // ignore: use_build_context_synchronously
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
                      loginForm.isLoading ? 'Espere...' : 'Crear cuenta',
                      style:
                          const TextStyle(color: Colors.black, fontSize: 17))),
            )
          ],
        ),
      ),
    );
  }
}
