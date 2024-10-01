import 'package:flutter/material.dart';
import 'package:appcontabancaria/models/conta_bancaria.dart';
import 'package:appcontabancaria/models/conta_corrente.dart';
import 'package:appcontabancaria/models/conta_poupanca.dart';
import 'package:appcontabancaria/views/home_layout.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<ContaBancaria> _contas = [];
  final _numeroContaController = TextEditingController();
  final _saldoController = TextEditingController();
  String _tipoConta = 'Corrente';

  void _adicionarConta() {
    final String numeroConta = _numeroContaController.text;
    final double saldo = double.tryParse(_saldoController.text) ?? 0.0;

    if (numeroConta.isNotEmpty) {
      if (_tipoConta == 'Corrente') {
        setState(() {
          _contas.add(ContaBancaria<ContaCorrente>(
            tipoDeConta: ContaCorrente(numeroConta),
            saldo: saldo,
          ));
        });
      } else {
        setState(() {
          _contas.add(ContaBancaria<ContaPoupanca>(
            tipoDeConta: ContaPoupanca(numeroConta),
            saldo: saldo,
          ));
        });
      }
    }
    _numeroContaController.clear();
    _saldoController.clear();
  }

  void _depositar(int index, double valor) {
    setState(() {
      _contas[index].depositar(valor);
    });
  }

  void _sacar(int index, double valor) {
    try {
      setState(() {
        _contas[index].sacar(valor);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeLayout(
      contas: _contas,
      tipoConta: _tipoConta,
      numeroContaController: _numeroContaController,
      saldoController: _saldoController,
      onTipoContaChanged: (String newValue) {
        setState(() {
          _tipoConta = newValue;
        });
      },
      onAdicionarConta: _adicionarConta,
      onDepositar: _depositar,
      onSacar: _sacar,
    );
  }
}
