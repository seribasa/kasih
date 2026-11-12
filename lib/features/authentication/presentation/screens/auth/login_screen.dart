import '../../../../../core/widgets/button_custom.dart';
import '../../../../../routers/route_paths/auth_route_paths.dart';
import '../../../logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        // Browser launch is not a completed login; wait for the session.
        if (state is Authenticated) context.go('/');
      },
      child: const _LoginScaffold(),
    );
  }
}

class _LoginScaffold extends StatelessWidget {
  const _LoginScaffold();

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/e_patient_logo.png',
                  width: 100,
                  semanticLabel: 'Logo Kasih',
                ),
                const SizedBox(height: 30.0),
                const Text(
                  "Silahkan masuk ke akun Anda",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ButtonCustom(
              onPressed: () => context.push(AuthRoutePaths.loginPhone.fullPath),
              child: const Text(
                'Masuk',
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

typedef LoginSeribaseOauthScreen = LoginScreen;
