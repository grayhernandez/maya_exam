import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:maya_app/presentation/login/login_cubit.dart';

void main() {
  group('LoginCubit', () {
    test('initial state is false (not logged in)', () {
      expect(LoginCubit().state, false);
    });

    blocTest<LoginCubit, bool>(
      'emits true when login is called with valid credentials',
      build: () => LoginCubit(),
      act: (cubit) => cubit.login('test', 'password'),
      expect: () => [true],
    );

    blocTest<LoginCubit, bool>(
      'emits false when logout is called',
      build: () => LoginCubit(),
      seed: () => true,
      act: (cubit) => cubit.logout(),
      expect: () => [false],
    );
  });
}
