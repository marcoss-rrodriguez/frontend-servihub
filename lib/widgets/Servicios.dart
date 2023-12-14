import 'package:flutter/material.dart';
import 'package:frontend2/connection/connection.services.dart';
import 'package:frontend2/connection/connection.foto.dart';
import 'package:frontend2/class/servicios.class.dart';
import 'package:frontend2/class/fotos.class.dart';
import 'package:frontend2/widgets/servicio_detallado.dart';

class ContratarServicioPage extends StatefulWidget {
  const ContratarServicioPage({Key? key}) : super(key: key);

  @override
  _ContratarServicioPageState createState() => _ContratarServicioPageState();
}

class _ContratarServicioPageState extends State<ContratarServicioPage> {
  late Future<List<Servicios>> _serviciosFuture;

  @override
  void initState() {
    super.initState();
    _serviciosFuture = ConnectionServices().getServicios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contratar Servicio'),
      ),
      body: FutureBuilder<List<Servicios>>(
        future: _serviciosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Servicios servicio = snapshot.data![index];
                  return FutureBuilder<Fotos>(
                    future:
                        ConnectionFotos().getFotoById(servicio.idFotoServicio),
                    builder: (context, snapshotFoto) {
                      if (snapshotFoto.connectionState ==
                          ConnectionState.done) {
                        if (snapshotFoto.hasData) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ServicioDetalladoPage(servicio: servicio),
                                ),
                              );
                            },
                            child: GridTile(
                              footer: GridTileBar(
                                backgroundColor: Colors.black45,
                                title: Text(servicio.tituloServicio),
                              ),
                              child: Image.network(
                                  snapshotFoto.data!.ubicacionFoto,
                                  fit: BoxFit.cover),
                            ),
                          );
                        } else if (snapshotFoto.hasError) {
                          return Center(child: Text('Error al cargar la foto'));
                        }
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error al cargar los servicios'));
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
