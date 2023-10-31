class Avaliacao {
  late final int id;
  late final int idUsuario;
  late final String avatar;
  late final String usuario;
  late final double rating;
  late final String cometario;
  late final String data;

  Avaliacao(this.id, this.idUsuario, this.avatar, this.usuario, this.rating,
      this.cometario, this.data);

  // Construtor factory para criar uma instância de Avaliacao a partir de JSON
  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      json['id'] as int,
      json['idUsuario'] as int,
      json['avatar'] as String,
      json['usuario'] as String,
      json['rating'] as double,
      json['comentario'] as String,
      json['data'] as String,
    );
  }
}
