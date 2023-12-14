import 'package:flutter/material.dart';
import 'package:frontend2/connection/connection.users.dart';
import 'package:frontend2/widgets/Principal.dart';
import 'package:frontend2/widgets/Registro.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _handleLogin(context);
                        },
                        style: ButtonStyle(
                          // Agrega bordes visibles al botón de Iniciar sesión
                          side: MaterialStateProperty.all(
                            BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        child: const Text('Iniciar sesión'),
                      ),
                    ),
                    const SizedBox(
                        width: 8.0), // Añade un espacio entre los botones
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          side: BorderSide(color: Colors.white, width: 2),
                        ),
                        child: const Text('Registrarse'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    Map<String, dynamic> response =
        await Connection().verifyCredentials(username, password);

    bool loginSuccess = response['success'] ?? false;
    int? userId = response['id_usuario'];

    if (loginSuccess && userId != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', response['token']);
      await prefs.setInt('id_usuario', userId);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Principal()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error de inicio de sesión'),
            content: const Text('Nombre de usuario o contraseña incorrectos.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
