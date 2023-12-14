import 'package:flutter/material.dart';
import 'package:frontend2/widgets/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend2/widgets/Notificaciones.dart';
import 'package:frontend2/widgets/Ofrecer_Servicios.dart';
import 'package:frontend2/widgets/Perfil.dart';
import 'package:frontend2/widgets/ServiceRatingPage.dart';
import 'package:frontend2/widgets/Servicios.dart';

class Principal extends StatefulWidget {
  const Principal({Key? key}) : super(key: key);

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  String nombreUsuario = '';

  @override
  void initState() {
    super.initState();
    _cargarNombreUsuario();
  }

  Future<void> _cargarNombreUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nombreUsuario = prefs.getString('nombre') ?? 'Usuario';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido $nombreUsuario'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: <Widget>[
            _buildGridButton(
              context,
              'Ofrecer Servicio',
              const Ofrecer_Servicio2(),
              Colors.orange,
            ),
            _buildGridButton(
              context,
              'Contratar Servicio',
              ContratarServicioPage(),
              Colors.green,
            ),
            _buildGridButton(
              context,
              'Evaluar Trabajo',
              ServiceRatingPage(
                  service: null), // Asegúrate de pasar un servicio válido
              Colors.red,
            ),
            // Agrega más botones si es necesario
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Notificaciones()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PerfilPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton(
      BuildContext context, String text, Widget page, Color color) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }
}
