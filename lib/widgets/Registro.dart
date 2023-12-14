import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend2/class/usuarios.class.dart';
import 'package:frontend2/connection/connection.foto.dart';
import 'package:frontend2/connection/connection.users.dart';
import 'package:frontend2/widgets/Login.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedGender = ''; // Añadido para almacenar la selección del género

  bool _validateAllFields() {
    return _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _yearController.text.isNotEmpty &&
        _monthController.text.isNotEmpty &&
        _dayController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _selectedGender
            .isNotEmpty; // Asegúrate de que se haya seleccionado un género
  }

  void _registerUser() async {
    if (_validateAllFields()) {
      // Primero, sube la foto de perfil y obtén el ID
      int? idFotoPerfil;
      if (_image != null) {
        try {
          idFotoPerfil = await ConnectionFotos().subirFoto(File(_image!.path));
        } catch (e) {
          _showErrorDialog('Error al subir la foto de perfil: $e');
          return; // Detiene la ejecución si hay un error al subir la foto
        }
      }

      final String genderCode = _selectedGender == 'HOMBRE' ? 'M' : 'F';
      final DateTime birthdate = DateTime(
        int.parse(_yearController.text),
        int.parse(_monthController.text),
        int.parse(_dayController.text),
      );
      final newUser = Usuarios(
        nombre: _firstNameController.text,
        apellido: _lastNameController.text,
        nombreUsuario: _usernameController.text,
        idTipoUsuario:
            2, // Valor predeterminado para todos los nuevos registros
        email: _emailController.text,
        contrasena: _passwordController.text,
        fechaNacimiento: birthdate,
        sexo: genderCode, // Envía 'M' o 'F' a la base de datos
        puntuacionVendedor: 0, // Valor predeterminado
        puntuacionComprador: 0, // Valor predeterminado
        descripcionPerfil: 'usuario nuevo', // Valor predeterminado
        idFotoPerfil: idFotoPerfil, // Asigna el ID de la foto subida
        horariosAtencion: '',
        id_usuario: null, // Valor predeterminado
      );

      // Utiliza la función createUsuario de tu archivo de conexión para registrar el usuario
      final result = await Connection().createUsuario(newUser);
      if (result) {
        // Mostrar mensaje de éxito y navegar a la pantalla de inicio de sesión
        _showSuccessDialog();
      } else {
        // Mostrar mensaje de error
        _showErrorDialog('Error al registrar el usuario.');
      }
    } else {
      _showErrorDialog('Todos los campos son obligatorios.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registro exitoso'),
          content: const Text('El usuario ha sido registrado con éxito.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const LoginPage()), // Reemplaza NextPage con tu página de destino
                ); // Cierra el diálogo
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  XFile? _image;

  // Método para seleccionar una imagen de la galería
  Future<void> _seleccionarFotoPerfil() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  // Método para subir la foto de perfil
  Future<void> _subirFotoPerfil() async {
    if (_image != null) {
      File imagenFile = File(_image!.path);
      try {
        int fotoId = await ConnectionFotos().subirFoto(imagenFile);
        // Aquí puedes hacer algo con el ID de la foto, como guardarlo en las preferencias del usuario
      } catch (e) {
        print('Error al subir la foto de perfil: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Container(
        color: Colors.blue, // Fondo azul
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildTextField(_firstNameController, 'Nombre'),
            const SizedBox(height: 16.0), // Espacio entre campos
            _buildTextField(_lastNameController, 'Apellido'),
            const SizedBox(height: 16.0), // Espacio entre campos
            _buildTextField(_emailController, 'Email',
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16.0), // Espacio entre campos
            _buildTextField(_usernameController, 'Nombre de Usuario'),
            const SizedBox(height: 16.0), // Espacio entre campos
            _buildTextField(_passwordController, 'Contraseña',
                obscureText: true),
            const SizedBox(height: 16.0), // Espacio entre campos
            _buildGenderDropdown(), // Usa el nuevo método para el campo de sexo
            const SizedBox(height: 16.0),
            // Añade un botón para seleccionar la foto de perfil
            ElevatedButton(
              onPressed: _seleccionarFotoPerfil,
              child: const Text('Seleccionar Foto de Perfil'),
            ),
            // Muestra la imagen seleccionada si está disponible
            if (_image != null) Image.file(File(_image!.path)),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(_yearController, 'Año',
                      keyboardType: TextInputType.number),
                ),
                const SizedBox(width: 8.0), // Espacio entre campos
                Expanded(
                  child: _buildTextField(_monthController, 'Mes',
                      keyboardType: TextInputType.number),
                ),
                const SizedBox(width: 8.0), // Espacio entre campos
                Expanded(
                  child: _buildTextField(_dayController, 'Día',
                      keyboardType: TextInputType.number),
                ),
              ],
            ),
            const SizedBox(
                height: 16.0), // Espacio entre campos // Espacio entre campos
            ElevatedButton(
              onPressed: _registerUser,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.blue), // Fondo blanco
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                        color: Colors.white, width: 2), // Bordes redondeados
                  ),
                ),
              ),
              child: const Text(
                'Registrarse',
                style: TextStyle(color: Colors.white), // Texto azul
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText, {
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.white, // Fondo blanco
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(color: Colors.black), // Texto negro
    );
  }

  Widget _buildGenderDropdown() {
    List<String> genderOptions = ['Hombre', 'Mujer'];

    if (_selectedGender.isEmpty && genderOptions.isNotEmpty) {
      _selectedGender = genderOptions[0]; // Inicializa con el primer valor
    }

    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: InputDecoration(
        labelText: 'Sexo',
        filled: true,
        fillColor: Colors.white, // Fondo blanco
      ),
      items: genderOptions.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
                color: Color.fromARGB(255, 114, 114, 114)), // Letras grises
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedGender = value!;
        });
      },
    );
  }
}
