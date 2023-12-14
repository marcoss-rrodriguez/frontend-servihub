import 'package:flutter/material.dart';
import 'package:frontend2/widgets/Perfil.dart';
import 'package:frontend2/widgets/Principal.dart';

class Notificaciones extends StatelessWidget {
  const Notificaciones({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Notificación 1'),
            subtitle: const Text('Contenido de la notificación 1'),
            onTap: () {
              // Acción al hacer clic en la notificación 1
              print('Notificación 1 clicada');
            },
          ),
          ListTile(
            title: const Text('Notificación 2'),
            subtitle: const Text('Contenido de la notificación 2'),
            onTap: () {
              // Acción al hacer clic en la notificación 2
              print('Notificación 2 clicada');
            },
          ),
          ListTile(
            title: const Text('Notificación 3'),
            subtitle: const Text('Contenido de la notificación 3'),
            onTap: () {
              // Acción al hacer clic en la notificación 3
              print('Notificación 3 clicada');
            },
          ),
          // Agrega más notificaciones según sea necesario
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Notificaciones()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Principal()),
                );
              },
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
}
