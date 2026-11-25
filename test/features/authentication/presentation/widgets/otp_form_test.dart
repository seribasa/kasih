import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasih/features/authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:kasih/features/authentication/logic/cubit/login_phone_cubit/login_phone_cubit.dart';
import 'package:kasih/features/authentication/presentation/widgets/otp_form.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class MockLoginPhoneCubit extends MockCubit<LoginPhoneState>
    implements LoginPhoneCubit {}

void main() {
  late MockAuthenticationBloc authBloc;
  late MockLoginPhoneCubit loginPhoneCubit;

  setUp(() {
    authBloc = MockAuthenticationBloc();
    loginPhoneCubit = MockLoginPhoneCubit();
    whenListen(
      authBloc,
      const Stream<AuthenticationState>.empty(),
      initialState: Unauthenticated(isSeenOnboarding: true),
    );
    whenListen(
      loginPhoneCubit,
      const Stream<LoginPhoneState>.empty(),
      initialState: const LoginPhoneState(),
    );
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>.value(value: authBloc),
            BlocProvider<LoginPhoneCubit>.value(value: loginPhoneCubit),
          ],
          child: const SingleChildScrollView(child: OTPForm()),
        ),
      ),
    );
  }

  testWidgets('OTP input obscures digits by default and toggles visibility', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    final textFieldFinder = find.byKey(
      const Key('loginPhoneForm_otpCodeInput_textField'),
    );
    final toggleFinder = find.byKey(
      const Key('loginPhoneForm_otpCodeVisibility_iconButton'),
    );

    expect(textFieldFinder, findsOneWidget);
    expect(toggleFinder, findsOneWidget);

    var textField = tester.widget<TextField>(textFieldFinder);
    expect(textField.obscureText, isTrue);
    expect(textField.autocorrect, isFalse);
    expect(textField.enableSuggestions, isFalse);

    await tester.tap(toggleFinder);
    await tester.pump();

    textField = tester.widget<TextField>(textFieldFinder);
    expect(textField.obscureText, isFalse);

    await tester.tap(toggleFinder);
    await tester.pump();

    textField = tester.widget<TextField>(textFieldFinder);
    expect(textField.obscureText, isTrue);
  });
}
