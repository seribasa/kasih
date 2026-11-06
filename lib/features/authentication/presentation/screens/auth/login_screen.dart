import '../../../../../core/widgets/button_custom.dart';
import '../../../../../core/widgets/snackbar_custom.dart';
import '../../../../../injection.dart';
import '../../../../../routers/route_paths/auth_route_paths.dart';
import '../../../logic/bloc/authentication_bloc/authentication_bloc.dart';
import '../../../logic/cubit/login_cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<LoginCubit, LoginState>(
            listenWhen:
                (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if (state.status.isFailure) {
                snackbarCustom(
                  state.errorMessage ?? 'Gagal membuka login.',
                ).show(context);
              }
            },
          ),
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              // Browser launch is not a completed login; wait for the session.
              if (state is Authenticated) context.go('/');
            },
          ),
        ],
        child: const _LoginScaffold(),
      ),
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
                  "Silahkan masuk dengan akun Seribase Anda",
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                _LoginButton(),
                SizedBox(height: 12.0),
                _LoginPhoneButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder:
          (context, state) => ButtonCustom(
            loading: state.status.isInProgress,
            onPressed:
                state.status.isInProgress
                    ? null
                    : () => context.read<LoginCubit>().logInWithSeribaseOauth(),
            child: const Text(
              'Masuk dengan Seribase',
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
          ),
    );
  }
}

class _LoginPhoneButton extends StatelessWidget {
  const _LoginPhoneButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder:
          (context, state) => ButtonCustom(
            onPressed:
                state.status.isInProgress
                    ? null
                    : () => context.push(AuthRoutePaths.loginPhone.fullPath),
            child: const Text(
              'Masuk dengan No Handphone',
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
          ),
    );
  }
}

typedef LoginSeribaseOauthScreen = LoginScreen;
