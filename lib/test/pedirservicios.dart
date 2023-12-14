import 'package:flutter/material.dart';
import 'package:frontend2/class/servicios.class.dart';
import 'package:frontend2/connection/connection.services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Servicios',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListaServicios(),
    );
  }
}

class ListaServicios extends StatefulWidget {
  @override
  _ListaServiciosState createState() => _ListaServiciosState();
}

class _ListaServiciosState extends State<ListaServicios> {
  final ConnectionServices _connection = ConnectionServices();
  List<Servicios> _listaServicios = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarServicios();
  }

  Future<void> _cargarServicios() async {
    try {
      _listaServicios = await _connection.getServicios();
      setState(() {
        _cargando = false;
      });
    } catch (e) {
      // Manejar el error
      setState(() {
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Servicios'),
      ),
      body: _cargando
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _listaServicios.length,
              itemBuilder: (context, index) {
                Servicios servicio = _listaServicios[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          servicio.tituloServicio,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          servicio.descripcionServicio,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '\$${servicio.precio}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
