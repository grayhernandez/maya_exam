import 'package:flutter_bloc/flutter_bloc.dart';

class HomeState {
  final double balance;
  final bool isBalanceVisible;

  const HomeState({required this.balance, required this.isBalanceVisible});

  HomeState copyWith({double? balance, bool? isBalanceVisible}) {
    return HomeState(
      balance: balance ?? this.balance,
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
    );
  }
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState(balance: 500.00, isBalanceVisible: true));

  void updateBalance(double amount) {
    emit(state.copyWith(balance: state.balance - amount));
  }

  void toggleBalanceVisibility() {
    emit(state.copyWith(isBalanceVisible: !state.isBalanceVisible));
  }
}
