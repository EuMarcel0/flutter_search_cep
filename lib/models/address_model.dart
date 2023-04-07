import 'dart:convert';

class AddressModel {
  final String cep;
  final String logradouro;
  final String bairro;
  final String uf;
  final String complemento;
  final String localidade;

  AddressModel({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.uf,
    required this.complemento,
    required this.localidade,
  });

  Map<String, dynamic> toMap() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'bairro': bairro,
      'uf': uf,
      'complemento': complemento,
      'localidade': localidade,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      cep: map['cep'],
      logradouro: map['logradouro'],
      bairro: map['bairro'],
      uf: map['uf'],
      complemento: map['complemento'],
      localidade: map['localidade'],
    );
  }

  factory AddressModel.fromJson(String json) =>
      AddressModel.fromMap(jsonDecode(json));
}
