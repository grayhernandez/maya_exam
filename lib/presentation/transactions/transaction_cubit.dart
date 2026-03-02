import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/get_transactions_usecase.dart';

abstract class TransactionState {}

class TransactionInitial extends TransactionState {}
class TransactionLoading extends TransactionState {}
class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;
  TransactionLoaded(this.transactions);
}
class TransactionError extends TransactionState {
  final String message;
  TransactionError(this.message);
}

class TransactionCubit extends Cubit<TransactionState> {
  final GetTransactionsUseCase getTransactionsUseCase;

  TransactionCubit({required this.getTransactionsUseCase})
      : super(TransactionInitial());

  Future<void> loadTransactions() async {
    emit(TransactionLoading());
    try {
      final list = await getTransactionsUseCase();
      emit(TransactionLoaded(list));
    } catch (e) {
      emit(TransactionError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
