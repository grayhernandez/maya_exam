import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<bool> {
  LoginCubit() : super(false);

  static const _validUsers = {
    'admin': 'password123',
    'user': 'user123',
    'demo': 'demo',
    'test': 'password',
  };

  void login(String username, String password) {
    final valid = _validUsers[username] == password;
    emit(valid);
  }

  void logout() {
    emit(false);
  }
}
