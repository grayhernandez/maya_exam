import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class SendMoneyUseCase {
  final TransactionRepository repository;
  SendMoneyUseCase(this.repository);

  Future<Transaction> call(double amount) {
    if (amount <= 0) throw Exception('Amount must be greater than 0');
    return repository.sendMoney(amount);
  }
}
