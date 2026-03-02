import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../send_money/send_money_cubit.dart';
import '../login/login_cubit.dart';
import '../../domain/usecases/send_money_usecase.dart';

class SendMoneyScreen extends StatelessWidget {
  final SendMoneyUseCase sendMoneyUseCase;
  const SendMoneyScreen({super.key, required this.sendMoneyUseCase});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SendMoneyCubit(sendMoneyUseCase: sendMoneyUseCase),
      child: const _SendMoneyView(),
    );
  }
}

class _SendMoneyView extends StatefulWidget {
  const _SendMoneyView();

  @override
  State<_SendMoneyView> createState() => _SendMoneyViewState();
}

class _SendMoneyViewState extends State<_SendMoneyView> {
  final _amountCtrl = TextEditingController();

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final text = _amountCtrl.text.trim();
    if (text.isEmpty) return;
    final amount = double.tryParse(text);
    if (amount == null) return;
    context.read<SendMoneyCubit>().sendMoney(amount);
  }

  Future<void> _showResultSheet(BuildContext context, bool isSuccess,
      double? amount, String? error) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
              color: isSuccess ? Colors.green : Colors.red,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              isSuccess ? 'Transfer Successful!' : 'Transfer Failed',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isSuccess
                  ? '₱${amount!.toStringAsFixed(2)} has been sent.'
                  : error ?? 'Something went wrong.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isSuccess ? Colors.green : Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    context.read<LoginCubit>().logout();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendMoneyCubit, SendStatus>(
      listener: (context, status) async {
        final cubit = context.read<SendMoneyCubit>();
        if (status == SendStatus.success) {
          final amount = cubit.lastTransaction?.amount;
          await _showResultSheet(context, true, amount, null);
          if (context.mounted) {
            Navigator.pop(context, amount); // return amount to HomeScreen
          }
        } else if (status == SendStatus.error) {
          await _showResultSheet(
              context, false, null, cubit.errorMessage);
          if (context.mounted) cubit.reset();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Send Money'),
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
              const Text('Enter Amount',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              TextField(
                controller: _amountCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Amount (₱)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.payments_outlined),
                  hintText: '0.00',
                ),
              ),
              const SizedBox(height: 32),
              BlocBuilder<SendMoneyCubit, SendStatus>(
                builder: (context, status) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: status == SendStatus.loading
                          ? null
                          : () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: status == SendStatus.loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Submit',
                              style: TextStyle(fontSize: 16)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
