import 'package:flutter/material.dart';
import 'package:search_cep/models/address_model.dart';
import 'package:search_cep/repositories/cep_repository.dart';
import 'package:search_cep/repositories/cep_repository_impl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  AddressModel? addressModel;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  Future<void> handleSearchCep() async {
    setState(() {
      isLoading = true;
    });
    final valid = formKey.currentState?.validate() ?? false;
    if (valid) {
      try {
        final cep = cepEC.text;
        final address = await cepRepository.getCep(cep);
        setState(() {
          addressModel = address;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          addressModel = null;
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Erro ao buscar CEP',
              style: TextStyle(
                color: Colors.white,
                backgroundColor: Colors.red,
              ),
            ),
          ),
        );
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar CEP', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: () {
                            cepEC.clear();
                          },
                          tooltip: 'Limpar campo',
                          icon: const Icon(Icons.clear),
                        ),
                        labelText: 'CEP',
                        hintText: 'Digite o CEP',
                        border: const OutlineInputBorder(),
                        helperText: 'Informe o CEP desejado',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      ),
                      controller: cepEC,
                      validator: (value) {
                        if (value == null || value == '') {
                          setState(() {
                            isLoading = false;
                          });
                          return 'Digite um CEP válido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: isLoading ? null : handleSearchCep,
                child:
                    const Text('Buscar', style: TextStyle(color: Colors.white)),
              ),
              Visibility(
                visible: isLoading,
                child: const LinearProgressIndicator(),
              ),
              Visibility(
                visible: addressModel != null,
                child: Divider(),
              ),
              Visibility(
                visible: addressModel != null,
                child: Text(
                  'CEP: ${addressModel?.cep}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Visibility(
                visible: addressModel != null,
                child: Text(
                  'UF: ${addressModel?.uf}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Visibility(
                visible: addressModel != null,
                child: Text(
                  'CIDADE: ${addressModel?.localidade}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Visibility(
                visible: addressModel != null,
                child: Divider(),
              ),
              Visibility(
                visible: addressModel != null,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      addressModel = null;
                    });
                  },
                  child: const Text(
                    'Limpar resultado',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ]),
          )),
    );
  }
}
