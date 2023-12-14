class Contrataciones {
  int? idContratacion;
  int idComprador;
  int idVendedor;
  DateTime fechaContratacion;
  String detallesAdicionales;

  Contrataciones({
    this.idContratacion,
    required this.idComprador,
    required this.idVendedor,
    required this.fechaContratacion,
    required this.detallesAdicionales,
  });

  factory Contrataciones.fromJson(Map<String, dynamic> json) => Contrataciones(
        idContratacion: json["id_contratacion"],
        idComprador: json["id_comprador"],
        idVendedor: json["id_vendedor"],
        fechaContratacion: DateTime.parse(json["fecha_contratacion"]),
        detallesAdicionales: json["detalles_adicionales"],
      );

  Map<String, dynamic> toJson() => {
        "id_contratacion": idContratacion,
        "id_comprador": idComprador,
        "id_vendedor": idVendedor,
        "fecha_contratacion": fechaContratacion.toIso8601String(),
        "detalles_adicionales": detallesAdicionales,
      };
}
