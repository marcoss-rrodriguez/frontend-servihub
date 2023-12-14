import 'package:flutter/material.dart';
import 'package:frontend2/class/contrataciones.class.dart';
import 'package:frontend2/class/servicios.class.dart';
import 'package:frontend2/connection/connection.contrataciones.dart';
import 'package:frontend2/connection/connection.foto.dart';
import 'package:frontend2/class/fotos.class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServicioDetalladoPage extends StatefulWidget {
  final Servicios servicio;

  const ServicioDetalladoPage({Key? key, required this.servicio})
      : super(key: key);

  @override
  _ServicioDetalladoPageState createState() => _ServicioDetalladoPageState();
}

class _ServicioDetalladoPageState extends State<ServicioDetalladoPage> {
  late Future<Fotos> _fotoFuture;

  @override
  void initState() {
    super.initState();
    _fotoFuture = ConnectionFotos().getFotoById(widget.servicio.idFotoServicio);
  }

  void _mostrarDialogoDetalles() {
    TextEditingController _detallesController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ingresa los detalles adicionales'),
          content: TextField(
            controller: _detallesController,
            decoration:
                InputDecoration(hintText: 'Detalles adicionales del servicio'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Enviar'),
              onPressed: () {
                _contratarServicio(_detallesController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _contratarServicio(String detallesAdicionales) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idComprador = prefs.getInt('id_usuario');
    if (idComprador == null) {
      _mostrarMensajeEmergente(
          'Error', 'Debes iniciar sesión para contratar un servicio.');
      return;
    }

    Contrataciones nuevaContratacion = Contrataciones(
      idComprador: idComprador,
      idVendedor: widget.servicio.idVendedor,
      fechaContratacion: DateTime.now(),
      detallesAdicionales: detallesAdicionales,
    );

    try {
      ConnectionContrataciones connectionContrataciones =
          ConnectionContrataciones();
      await connectionContrataciones.crearContratacion(nuevaContratacion);
      _mostrarMensajeEmergente(
          'Éxito', 'El servicio ha sido contratado con éxito.');
    } catch (e) {
      _mostrarMensajeEmergente(
          'Error', 'Ocurrió un error al contratar el servicio: $e');
    }
  }

  void _mostrarMensajeEmergente(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.servicio.tituloServicio),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.blue,
        child: FutureBuilder<Fotos>(
          future: _fotoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.network(snapshot.data!.ubicacionFoto,
                          fit: BoxFit.cover),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Título: ${widget.servicio.tituloServicio}',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            Text(
                                'Descripción: ${widget.servicio.descripcionServicio}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            Text('Precio: ${widget.servicio.precio}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            Text(
                                'Ubicación: ${widget.servicio.ubicacionServicio}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            // Aquí deberías agregar la lógica para mostrar la categoría del servicio
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed:
                                  _mostrarDialogoDetalles, // Modificado para mostrar el diálogo
                              child: Text('Contratar Servicio'),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Error al cargar la foto del servicio'));
              }
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
