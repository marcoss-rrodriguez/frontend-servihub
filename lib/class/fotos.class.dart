class Fotos {
  int idFoto;
  int idReferencia;
  String ubicacionFoto;

  Fotos({
    required this.idFoto,
    required this.idReferencia,
    required this.ubicacionFoto,
  });

  factory Fotos.fromJson(Map<String, dynamic> json) => Fotos(
        idFoto: json["id_foto"],
        idReferencia: json["id_referencia"],
        ubicacionFoto: json["ubicacion_foto"],
      );

  Map<String, dynamic> toJson() => {
        "id_foto": idFoto,
        "id_referencia": idReferencia,
        "ubicacion_foto": ubicacionFoto,
      };
}
