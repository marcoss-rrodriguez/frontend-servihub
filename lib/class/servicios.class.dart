class Servicios {
  int? idServicio;
  int idVendedor;
  String tituloServicio;
  String ubicacionServicio;
  String descripcionServicio;
  int precio;
  int idCategoria;
  int idFotoServicio;

  Servicios({
    required this.idServicio,
    required this.idVendedor,
    required this.tituloServicio,
    required this.ubicacionServicio,
    required this.descripcionServicio,
    required this.precio,
    required this.idCategoria,
    required this.idFotoServicio,
  });

  factory Servicios.fromJson(Map<String, dynamic> json) => Servicios(
        idServicio: json["id_servicio"],
        idVendedor: json["id_vendedor"],
        tituloServicio: json["titulo_servicio"],
        ubicacionServicio: json["ubicacion_servicio"],
        descripcionServicio: json["descripcion_servicio"],
        precio: json["precio"],
        idCategoria: json["id_categoria"],
        idFotoServicio: json["id_foto_servicio"],
      );

  Map<String, dynamic> toJson() => {
        "id_servicio": idServicio,
        "id_vendedor": idVendedor,
        "titulo_servicio": tituloServicio,
        "ubicacion_servicio": ubicacionServicio,
        "descripcion_servicio": descripcionServicio,
        "precio": precio,
        "id_categoria": idCategoria,
        "id_foto_servicio": idFotoServicio,
      };
}
