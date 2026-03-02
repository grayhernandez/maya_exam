import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:maya_app/presentation/home/home_cubit.dart';

void main() {
  group('HomeCubit', () {
    test('initial balance is 500.00', () {
      expect(HomeCubit().state.balance, 500.00);
    });

    test('initial balance visibility is true', () {
      expect(HomeCubit().state.isBalanceVisible, true);
    });

    blocTest<HomeCubit, HomeState>(
      'updates balance when amount is sent',
      build: () => HomeCubit(),
      act: (cubit) => cubit.updateBalance(100),
      expect: () => [
        isA<HomeState>().having((s) => s.balance, 'balance', 400.00),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'toggles balance visibility to false',
      build: () => HomeCubit(),
      act: (cubit) => cubit.toggleBalanceVisibility(),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.isBalanceVisible, 'isBalanceVisible', false),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'toggles balance visibility back to true',
      build: () => HomeCubit(),
      act: (cubit) {
        cubit.toggleBalanceVisibility();
        cubit.toggleBalanceVisibility();
      },
      expect: () => [
        isA<HomeState>()
            .having((s) => s.isBalanceVisible, 'isBalanceVisible', false),
        isA<HomeState>()
            .having((s) => s.isBalanceVisible, 'isBalanceVisible', true),
      ],
    );
  });
}
