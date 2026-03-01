import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class SendMoneyUseCase {
  final TransactionRepository repository;

  SendMoneyUseCase(this.repository);

  Future<Either<Failure, Transaction>> call(double amount) {
    return repository.sendMoney(amount);
  }
}
