import 'dart:developer';
import 'package:dio/dio.dart';
import './cep_repository.dart';
import 'package:search_cep/models/address_model.dart';

class CepRepositoryImpl implements CepRepository {
  @override
  Future<AddressModel> getCep(String cep) async {
    try {
      final response = await Dio().get('https://viacep.com.br/ws/$cep/json/');
      final address = AddressModel.fromMap(response.data);
      return address;
    } on DioError catch (e) {
      log('Erro ao buscar o CEP', error: e);
      throw Exception('Erro ao buscar o CEP');
    }
  }
}
