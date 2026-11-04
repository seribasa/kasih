import 'package:kasih/features/authentication/logic/cubit/signup_cubit/signup_cubit.dart';
import 'package:kasih/features/authentication/presentation/widgets/signup_phone_form.dart';
import 'package:kasih/injection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class RegisterPhoneScreen extends StatelessWidget {
  const RegisterPhoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocProvider(
            create: (_) => getIt<SignUpCubit>(),
            child: const SignUpPhoneForm(),
          ),
        ),
      ),
    );
  }
}
