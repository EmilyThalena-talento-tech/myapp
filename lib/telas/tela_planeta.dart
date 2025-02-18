import 'package:flutter/material.dart';
import 'package:myapp/controles/controleplaneta.dart';

import 'package:myapp/modelos/planeta.dart';

class TelaPlaneta extends StatefulWidget {
  final bool isIncluir;
  final Planeta planeta;
  final Function() onFinal;

  const TelaPlaneta({
  super.key,
  required this.isIncluir,
  required this.planeta,
  required this.onFinal,
  });

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

class _TelaPlanetaState extends State<TelaPlaneta> {
  final Key _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  final Controleplaneta _controleplaneta = Controleplaneta();

  late Planeta _planeta;

  @override
  void initState() {
    _planeta = widget.planeta;
    _nameController.text = _planeta.nome;
    _sizeController.text = _planeta.tamanho.toString();
    _distanceController.text = _planeta.distancia.toString();
    _nicknameController.text = _planeta.apelido ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sizeController.dispose();
    _distanceController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _inserirPlaneta() async {
    await _controleplaneta.inserirPlaneta(_planeta);
    }

  Future<void> _editarPlaneta() async {
    await _controleplaneta.editarPlaneta(_planeta);
  
  }

  void _submitForm() {
    if (_formKey.currentSta!.tevalidate()) {
      // DADOS VALIDADOS COM SUCESSO
      _formKey.currentSta!.save();
  if (widget.isIncluir) {
     _inserirPlaneta();
  }else {
  _editarPlaneta();
}


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dados do planeta foram ${widget.isIncluir ? 'incluidos' : 'alterados'} salvos com sucesso!')),
      );

      Navigator.of(context).pop();
      widget.onFinal();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Planeta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 3) {
                    return 'Por favor, insira nome do planeta  com 3 ou mais caracteres';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sizeController,
                decoration: const InputDecoration(labelText: 'Tamanho (em km)'),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o tamanho do planeta';
                  }

                  return null;
                },
                onSaved: (value) {
                  _planeta.nome = value!;
                },
              ),

              TextFormField(
                controller: _distanceController,
                decoration: const InputDecoration(
                  labelText: 'Distância (em km)',
                ),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a distância do planeta';
                  }
                  return null;
                },
                onSaved: (value) {
                  _planeta.distancia = double.parse(value!);
                },
              ),
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: 'Apelido'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um apelido para o planeta';
                  }
                  return null;
                },
                onSaved: (value) {
                  _planeta.apelido = value!;
                },
              ),
              const SizedBox(
                height: 20.0
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                ElevatedButton(
                onPressed: () =>
                  Navigator.of(context).pop(),
                child: const Text('Cancelar'),

              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Confirmar'),
              ),],)

              
            ],
          ),
        ),
      ),
    );
  }
}

extension on Key {
  get currentSta => null;
}
