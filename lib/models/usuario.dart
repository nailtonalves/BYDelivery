class Usuario {
  int id;
  String avatar;
  String nome;
  String email;
  String senha;

  Usuario(this.id, this.avatar, this.nome, this.email, this.senha);

  static fromJson(Map<String, dynamic> json) {
    return Usuario(
        json['id'] as int,
        json['avatar'] as String,
        json['nome'] as String,
        json['email'] as String,
        json['senha'] as String);
  }
}
