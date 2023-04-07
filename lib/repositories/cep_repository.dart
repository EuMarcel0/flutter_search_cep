import 'package:search_cep/models/address_model.dart';

abstract class CepRepository {
  Future<AddressModel> getCep(String cep);
}
