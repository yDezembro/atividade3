import 'package:flutter_test/flutter_test.dart';
import 'package:appcontabancaria/models/conta_bancaria.dart';
import 'package:appcontabancaria/models/conta_corrente.dart';
import 'package:appcontabancaria/models/conta_poupanca.dart';

void main() {
  group('ContaBancaria', () {
    test('Deve depositar dinheiro na conta corrente', () {
      final conta = ContaBancaria<ContaCorrente>(
        tipoDeConta: ContaCorrente('12345-6'),
      );

      conta.depositar(100.0);

      expect(conta.saldo, 100.0);
    });

    test('Deve sacar dinheiro da conta poupança', () {
      final conta = ContaBancaria<ContaPoupanca>(
        tipoDeConta: ContaPoupanca('65432-1'),
        saldo: 500.0,
      );

      conta.sacar(200.0);

      expect(conta.saldo, 300.0);
    });

    test('Deve lançar exceção ao tentar sacar mais do que o saldo', () {
      final conta = ContaBancaria<ContaCorrente>(
        tipoDeConta: ContaCorrente('12345-6'),
        saldo: 100.0,
      );

      expect(() => conta.sacar(200.0), throwsException);
    });
  });
}
