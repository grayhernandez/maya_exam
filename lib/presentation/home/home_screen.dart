import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../home/home_cubit.dart';
import '../login/login_cubit.dart';
import '../send_money/send_money_screen.dart';
import '../transactions/transaction_screen.dart';
import '../../core/network/api_client.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/usecases/get_transactions_usecase.dart';
import '../../domain/usecases/send_money_usecase.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) {
    context.read<LoginCubit>().logout();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final balance = state.balance;
          final isVisible = state.isBalanceVisible;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('My Wallet'),
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
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Balance card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Current Balance',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              isVisible
                                  ? '₱${balance.toStringAsFixed(2)}'
                                  : '₱ ••••••',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                isVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.white70,
                              ),
                              onPressed: context
                                  .read<HomeCubit>()
                                  .toggleBalanceVisibility,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.send),
                      label: const Text('Send Money',
                          style: TextStyle(fontSize: 16)),
                      onPressed: () async {
                        final repo =
                            TransactionRepositoryImpl(apiClient: ApiClient());
                        final useCase = SendMoneyUseCase(repo);
                        final sent = await Navigator.push<double>(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SendMoneyScreen(sendMoneyUseCase: useCase),
                          ),
                        );
                        if (sent != null) {
                          context.read<HomeCubit>().updateBalance(sent);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.receipt_long_outlined),
                      label: const Text('View Transactions',
                          style: TextStyle(fontSize: 16)),
                      onPressed: () {
                        final repo =
                            TransactionRepositoryImpl(apiClient: ApiClient());
                        final useCase = GetTransactionsUseCase(repo);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TransactionScreen(
                                getTransactionsUseCase: useCase),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.indigo,
                        side: const BorderSide(color: Colors.indigo),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
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
}
