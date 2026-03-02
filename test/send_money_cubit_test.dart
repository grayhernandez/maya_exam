import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:maya_app/presentation/send_money/send_money_cubit.dart';

void main() {
  group('SendMoneyCubit', () {
    test('initial state is SendStatus.initial', () {
      expect(SendMoneyCubit().state, SendStatus.initial);
    });

    blocTest<SendMoneyCubit, SendStatus>(
      'emits success when valid amount is sent',
      build: () => SendMoneyCubit(),
      act: (cubit) => cubit.sendMoney(100),
      wait: const Duration(seconds: 2),
      expect: () => [SendStatus.loading, SendStatus.success],
    );

    blocTest<SendMoneyCubit, SendStatus>(
      'emits error when invalid amount is sent',
      build: () => SendMoneyCubit(),
      act: (cubit) => cubit.sendMoney(-50),
      expect: () => [SendStatus.error],
    );
  });
}
