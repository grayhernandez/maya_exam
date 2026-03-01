import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionsUseCase {
  final TransactionRepository repository;

  GetTransactionsUseCase(this.repository);

  Future<Either<Failure, List<Transaction>>> call() {
    return repository.getTransactions();
  }
}
