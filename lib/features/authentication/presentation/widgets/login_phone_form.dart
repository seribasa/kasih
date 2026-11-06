import 'package:country_code_picker/country_code_picker.dart';
import 'package:kasih/core/utils/constant.dart';
import 'package:kasih/features/authentication/presentation/screens/auth/otp_screen.dart';
import 'package:kasih/core/widgets/snackbar_custom.dart';
import 'package:kasih/routers/route_paths/auth_route_paths.dart';
import 'package:kasih/core/utils/string_extension.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/button_custom.dart';
import '../../../../core/widgets/text_form_custom.dart';
import '../../../../core/utils/dismiss_keyboard.dart';
import '../../logic/cubit/login_phone_cubit/login_phone_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginPhoneForm extends StatelessWidget {
  const LoginPhoneForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginPhoneCubit, LoginPhoneState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          snackbarCustom(
            state.errorMessage ?? 'Authentication Failure',
          ).show(context);
        } else if (state.verId != null) {
          context.pushReplacement(
            AuthRoutePaths.otp.fullPath,
            extra: OTPScreenArguments(
              phone: state.phone.value,
              countryCode: state.countryCode.value,
              verId: state.verId.orEmpty,
            ),
          );
        }
      },
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/e_patient_logo.png',
                width: 80,
                semanticLabel: 'Logo Kasih',
              ),
              const SizedBox(height: 30.0),
              const Text(
                'Masuk atau Daftar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan nomor handphone untuk menerima kode verifikasi (OTP)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              _PhoneInput(),
              const SizedBox(height: 16),
              _LoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginPhoneCubit, LoginPhoneState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CountryCodePicker(
                  onInit:
                      (countryCode) => context
                          .read<LoginPhoneCubit>()
                          .countryCodeChanged(countryCode?.dialCode ?? '+62'),
                  onChanged:
                      (countryCode) => context
                          .read<LoginPhoneCubit>()
                          .countryCodeChanged(countryCode.dialCode.orEmpty),
                  initialSelection: 'ID',
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                ),
                Expanded(
                  child: TextFormCustom(
                    label: AppConstant.PHONE_NUMBER_LABEL,
                    keyboardType: TextInputType.phone,
                    hintText: 'Contoh: 876543210',
                    onChanged:
                        (phone) =>
                            context.read<LoginPhoneCubit>().phoneChanged(phone),
                  ),
                ),
              ],
            ),
            () {
              if (state.phone.isNotValid) {
                return Text(
                  'Format salah! Contoh: 876543210',
                  style: TextStyle(color: Colors.red[600]),
                );
              } else {
                return Container();
              }
            }(),
          ],
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginPhoneCubit, LoginPhoneState>(
      builder: (context, state) {
        return ButtonCustom(
          child: const Text(
            'Kirim Kode OTP',
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
          loading: state.status.isInProgress,
          onPressed:
              state.phone.isValid && state.countryCode.isValid
                  ? () {
                    dismissKeyboard(context);
                    context.read<LoginPhoneCubit>().sendOtp();
                  }
                  : null,
        );
      },
    );
  }
}
