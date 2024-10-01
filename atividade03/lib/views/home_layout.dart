import 'package:flutter/material.dart';
import 'package:appcontabancaria/models/conta_bancaria.dart';

class HomeLayout extends StatelessWidget {
  final List<ContaBancaria> contas;
  final String tipoConta;
  final TextEditingController numeroContaController;
  final TextEditingController saldoController;
  final ValueChanged<String> onTipoContaChanged;
  final VoidCallback onAdicionarConta;
  final Function(int, double) onDepositar;
  final Function(int, double) onSacar;

  const HomeLayout({
    super.key,
    required this.contas,
    required this.tipoConta,
    required this.numeroContaController,
    required this.saldoController,
    required this.onTipoContaChanged,
    required this.onAdicionarConta,
    required this.onDepositar,
    required this.onSacar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplicação Bancária Genérica'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown(),
            const SizedBox(height: 10),
            _buildTextField(
              controller: numeroContaController,
              label: 'Número da Conta',
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: saldoController,
              label: 'Saldo Inicial',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _buildButton(),
            const SizedBox(height: 20),
            _buildListView(),
          ],
        ),
      ),
    );
  }

  DropdownButton<String> _buildDropdown() {
    return DropdownButton<String>(
      value: tipoConta,
      onChanged: (String? newValue) {
        if (newValue != null) {
          onTipoContaChanged(newValue);
        }
      },
      items: <String>['Corrente', 'Poupança']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }


  TextField _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  ElevatedButton _buildButton() {
    return ElevatedButton.icon(
      onPressed: onAdicionarConta,
      icon: const Icon(Icons.add),
      label: const Text('Adicionar Conta'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue.shade600,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  Expanded _buildListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: contas.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                contas[index].toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _showDialog(
                      context,
                      'Depositar',
                          (valor) => onDepositar(index, valor),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => _showDialog(
                      context,
                      'Sacar',
                          (valor) => onSacar(index, valor),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDialog(
      BuildContext context, String title, Function(double) onConfirm) {
    final _valorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: _valorController,
            decoration: const InputDecoration(labelText: 'Valor'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final double valor =
                    double.tryParse(_valorController.text) ?? 0.0;
                onConfirm(valor);
                Navigator.of(context).pop();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
}
