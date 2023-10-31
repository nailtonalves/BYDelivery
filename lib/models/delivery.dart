import 'package:bydelivery/models/location_address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Delivery {
  String idEstabelecimento;
  String idCliente;
  String nomeCliente;
  LocationAddress localRetiradaEncomenda;
  LocationAddress localEntregaEncomenda;
  String dataCriacao;
  String dataEntrega;
  String idMotoboy;
  String status;
  String valor;

  Delivery(
    this.idEstabelecimento,
    this.idCliente,
    this.nomeCliente,
    this.localRetiradaEncomenda,
    this.localEntregaEncomenda,
    this.dataCriacao,
    this.dataEntrega,
    this.idMotoboy,
    this.status,
    this.valor,
  );

  static fromJson(Map<String, dynamic> json) {
    return Delivery(
        json['idEstabelecimento'] as String,
        json['idCliente'] as String,
        json['nomeCliente'] as String,
        // json['localRetiradaEncomenda'] as LocationAddress,
        // json['localEntregaEncomenda'] as LocationAddress,
        LocationAddress.fromJson(
            json['localRetiradaEncomenda'] as Map<String, dynamic>),
        LocationAddress.fromJson(
            json['localEntregaEncomenda'] as Map<String, dynamic>),
        json['dataCriacao'] as String,
        json['dataEntrega'] as String,
        json['idMotoboy'] as String,
        json['status'] as String,
        json['valor'] as String);
  }
}
