import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend2/class/servicios.class.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend2/class/usuarios.class.dart';
import 'package:frontend2/connection/connection.users.dart';
import 'package:frontend2/connection/connection.services.dart';
import 'package:frontend2/connection/connection.foto.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  Usuarios? usuario;
  List<Servicios> serviciosPublicados = [];
  String urlFotoPerfil = '';

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? usuarioId = prefs.getInt('id_usuario');
    if (usuarioId != null) {
      _cargarUsuario(usuarioId);
      _cargarServiciosPublicados(usuarioId);
    } else {
      // Manejar el caso en que no hay un usuario logueado
    }
  }

  Future<void> _cargarUsuario(int usuarioId) async {
    Connection connectionUsers = Connection();
    try {
      Usuarios fetchedUsuario = await connectionUsers.getUsuarioById(usuarioId);
      String fotoUrl = await fetchedUsuario.getUrlFotoPerfil();
      setState(() {
        usuario = fetchedUsuario;
        urlFotoPerfil = fotoUrl;
      });
    } catch (e) {
      print('Error al cargar los datos del usuario: $e');
    }
  }

  Future<void> _cargarServiciosPublicados(int usuarioId) async {
    ConnectionServices connectionServices = ConnectionServices();
    try {
      List<Servicios> fetchedServicios =
          await connectionServices.getServiciosByUserId(usuarioId);
      setState(() {
        serviciosPublicados = fetchedServicios;
      });
    } catch (e) {
      print('Error al cargar los servicios publicados: $e');
    }
  }

  Future<void> _eliminarServicio(int idServicio) async {
    try {
      await ConnectionServices().deleteServicio(idServicio);
      setState(() {
        serviciosPublicados
            .removeWhere((servicio) => servicio.idServicio == idServicio);
      });
    } catch (e) {
      print('Error al eliminar el servicio: $e');
    }
  }

  ConnectionFotos connectionFotos = ConnectionFotos();

  Future<void> _actualizarFotoPerfil(XFile? image) async {
    if (image != null && usuario != null && usuario!.idFotoPerfil != null) {
      File imagenFile = File(image.path);
      try {
        bool actualizado = await connectionFotos.actualizarFoto(
            usuario!.idFotoPerfil!, imagenFile);
        if (actualizado) {
          String nuevaUrlFotoPerfil = await connectionFotos
              .getFotoById(usuario!.idFotoPerfil!)
              .then((foto) => foto.ubicacionFoto);
          setState(() {
            urlFotoPerfil = nuevaUrlFotoPerfil;
          });
        }
      } catch (e) {
        print('Error al actualizar la foto de perfil: $e');
      }
    } else {
      print(
          'No se puede actualizar la foto de perfil: falta información del usuario o la imagen.');
    }
  }

  Future<void> _seleccionarFoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    _actualizarFotoPerfil(image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(usuario != null ? 'Perfil de ${usuario!.nombre}' : 'Perfil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(),
            _buildRatingSection(),
            _buildServicesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return GestureDetector(
      onTap: () {
        _seleccionarFoto();
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            usuario != null && urlFotoPerfil.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(urlFotoPerfil),
                    radius: 40,
                  )
                : CircleAvatar(
                    child: Icon(Icons.person),
                    radius: 40,
                  ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (usuario != null)
                    Text('${usuario!.nombre} ${usuario!.apellido}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Puntuación Vendedor',
                    style: TextStyle(color: Colors.white)),
                IconTheme(
                  data: IconThemeData(color: Colors.amber, size: 20),
                  child: StarDisplay(value: usuario?.puntuacionVendedor ?? 0),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text('Puntuación Comprador',
                    style: TextStyle(color: Colors.white)),
                IconTheme(
                  data: IconThemeData(color: Colors.amber, size: 20),
                  child: StarDisplay(value: usuario?.puntuacionComprador ?? 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: serviciosPublicados.length,
      itemBuilder: (BuildContext context, int index) {
        Servicios servicio = serviciosPublicados[index];
        return ListTile(
          title: Text(servicio.tituloServicio),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _eliminarServicio(servicio.idServicio!),
          ),
        );
      },
    );
  }
}

class StarDisplay extends StatelessWidget {
  final int value;
  const StarDisplay({Key? key, this.value = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
        );
      }),
    );
  }
}
