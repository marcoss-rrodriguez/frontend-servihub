import 'package:flutter/material.dart';
import 'package:frontend2/class/categorias.class.dart';
import 'package:frontend2/connection/connection.categorias.dart';

void main() {
  runApp(ServiHubApp());
}

class ServiHubApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ServiHub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PedirCategorias(),
    );
  }
}

class PedirCategorias extends StatefulWidget {
  @override
  _PedirCategoriasState createState() => _PedirCategoriasState();
}

class _PedirCategoriasState extends State<PedirCategorias> {
  late Future<List<Categorias>> futureCategorias;

  @override
  void initState() {
    super.initState();
    futureCategorias = ConnectionCategorias().getCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías de Servicios'),
      ),
      body: FutureBuilder<List<Categorias>>(
        future: futureCategorias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay categorías disponibles.'));
          } else {
            List<Categorias> categorias = snapshot.data!;
            return ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(categorias[index].nombreCategoria),
                );
              },
            );
          }
        },
      ),
    );
  }
}
