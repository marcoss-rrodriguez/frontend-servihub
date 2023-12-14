import 'package:flutter/material.dart';
import 'package:frontend2/widgets/Login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ServiHub',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Fondo con imagen que se ajusta al tamaño de la pantalla
        Image.network(
          'https://i.pinimg.com/564x/ef/93/9a/ef939a43058730369b18d477331b28cc.jpg',
          fit: BoxFit.cover,
        ),
        // Contenido de la aplicación
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Frase de bienvenida
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Bienvenido a ServiHub,\n" +
                    "tu aplicación de confianza\n" +
                    "para contratar o dar un servicio",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  fontFamily:
                      'Roboto', // Cambia 'Roboto' por la fuente que desees usar
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
                height: 50), // Agrega un espacio entre el texto y el botón
            // Botón "Continuar"
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text("Continuar >"),
            ),
          ],
        ),
      ],
    );
  }
}
