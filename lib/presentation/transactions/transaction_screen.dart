import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../transactions/transaction_cubit.dart';
import '../login/login_cubit.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/get_transactions_usecase.dart';

class TransactionScreen extends StatelessWidget {
  final GetTransactionsUseCase getTransactionsUseCase;
  const TransactionScreen({super.key, required this.getTransactionsUseCase});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TransactionCubit(getTransactionsUseCase: getTransactionsUseCase)
            ..loadTransactions(),
      child: const _TransactionView(),
    );
  }
}

class _TransactionView extends StatelessWidget {
  const _TransactionView();

  void _logout(BuildContext context) {
    context.read<LoginCubit>().logout();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.indigo));
          }
          if (state is TransactionError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(state.message,
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () =>
                        context.read<TransactionCubit>().loadTransactions(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is TransactionLoaded) {
            if (state.transactions.isEmpty) {
              return const Center(
                  child: Text('No transactions yet.',
                      style: TextStyle(color: Colors.grey)));
            }
            return RefreshIndicator(
              color: Colors.indigo,
              onRefresh: () =>
                  context.read<TransactionCubit>().loadTransactions(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.transactions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) =>
                    _TransactionTile(tx: state.transactions[i]),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction tx;
  const _TransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.indigo.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.send, color: Colors.indigo, size: 20),
      ),
      title:
          Text(tx.title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        '${tx.date.day}/${tx.date.month}/${tx.date.year}',
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      trailing: Text(
        '-₱${tx.amount.toStringAsFixed(2)}',
        style: const TextStyle(
            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}
