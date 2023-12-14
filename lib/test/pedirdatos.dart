import 'package:flutter/material.dart';
import 'package:frontend2/class/usuarios.class.dart';
import 'package:frontend2/connection/connection.users.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ServiHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          const UsuariosPage(), // Establece UsuariosPage como la pantalla de inicio
    );
  }
}

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({Key? key}) : super(key: key);

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  late Future<List<Usuarios>> _futureUsuarios;

  @override
  void initState() {
    super.initState();
    _futureUsuarios =
        Connection().getUsuarios(); // Obtiene los usuarios al iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
      ),
      body: FutureBuilder<List<Usuarios>>(
        future: _futureUsuarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final usuarios = snapshot.data!;
            return ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarios[index];
                return ListTile(
                  title: Text(usuario.nombreUsuario),
                  subtitle: Text(usuario.email),
                  // Añade más campos si es necesario
                );
              },
            );
          } else {
            return const Center(child: Text('No hay usuarios disponibles'));
          }
        },
      ),
    );
  }
}
