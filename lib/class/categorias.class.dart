class Categorias {
  int idCategoria;
  String nombreCategoria;

  Categorias({
    required this.idCategoria,
    required this.nombreCategoria,
  });

  factory Categorias.fromJson(Map<String, dynamic> json) => Categorias(
        idCategoria: json["id_categoria"],
        nombreCategoria: json["nombre_categoria"],
      );

  Map<String, dynamic> toJson() => {
        "id_categoria": idCategoria,
        "nombre_categoria": nombreCategoria,
      };
}
