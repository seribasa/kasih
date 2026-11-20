import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kasih/features/authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:kasih/features/authentication/presentation/screens/auth/login_screen.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

void main() {
  late MockAuthenticationBloc authBloc;

  setUp(() {
    authBloc = MockAuthenticationBloc();
    whenListen(
      authBloc,
      Stream<AuthenticationState>.empty(),
      initialState: Unauthenticated(isSeenOnboarding: true),
    );
  });

  Widget buildTestWidget(Widget child) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => BlocProvider<AuthenticationBloc>.value(
            value: authBloc,
            child: child,
          ),
        ),
        GoRoute(
          path: '/auth/login-phone',
          builder: (_, __) => const Scaffold(body: Text('Login Phone Target')),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }

  testWidgets('LoginScreen displays only Masuk button and updated header', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(const LoginScreen()));
    await tester.pumpAndSettle();

    // Verify header text
    expect(find.text('Silahkan masuk ke akun Anda'), findsOneWidget);
    expect(find.text('Silahkan masuk dengan akun Seribase Anda'), findsNothing);

    // Verify only 'Masuk' button exists
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Masuk dengan Seribase'), findsNothing);
    expect(find.text('Masuk dengan No Handphone'), findsNothing);

    // Tap 'Masuk' and verify navigation
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Login Phone Target'), findsOneWidget);
  });
}
