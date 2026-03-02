import '../../core/network/api_client.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final ApiClient apiClient;

  // Local storage for sent transactions within the session
  final List<Transaction> _localTransactions = [];

  TransactionRepositoryImpl({required this.apiClient});

  @override
  Future<List<Transaction>> getTransactions() async {
    final data = await apiClient.get('/posts?userId=1&_limit=10');
    final remote = (data as List)
        .map((e) => Transaction(
              id: e['id'] as int,
              amount: (e['id'] as int) * 25.0, // fake amount from id
              title: 'Money Transfer',
              date: DateTime.now().subtract(Duration(days: e['id'] as int)),
            ))
        .toList();

    // Simulate network latency
    await Future.delayed(const Duration(seconds: 1));
    return [..._localTransactions, ...remote];
  }

  @override
  Future<Transaction> sendMoney(double amount) async {
    final data = await apiClient.post('/posts', {
      'title': 'Money Transfer',
      'amount': amount,
      'userId': 1,
    });
    final tx = Transaction(
      id: data['id'] as int,
      amount: amount,
      title: 'Money Transfer',
      date: DateTime.now(),
    );
    _localTransactions.insert(0, tx);
    return tx;
  }
}
