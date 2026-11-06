import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/country_code.dart';
import '../../../data/models/email.dart';
import '../../../data/models/otp.dart';
import '../../../data/models/password.dart';
import '../../../data/models/phone.dart';
import '../../../data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'signup_state.dart';

@Injectable()
class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepository) : super(const SignUpState());

  final AuthRepository _authRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(email: email));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(password: password));
  }

  void countryCodeChanged(String value) {
    final countryCode = CountryCode.dirty(value);
    emit(state.copyWith(countryCode: countryCode));
  }

  void phoneChanged(String value) {
    final phone = Phone.dirty(value);
    emit(state.copyWith(phone: phone));
  }

  void showHidePassword() {
    emit(state.copyWith(isShowPassword: !state.isShowPassword));
  }

  String get _formattedPhoneNumber {
    final phoneVal = state.phone.value.trim();
    final cleanPhone =
        phoneVal.startsWith('0') ? phoneVal.substring(1) : phoneVal;
    final country =
        state.countryCode.value.isEmpty ? '+62' : state.countryCode.value;
    return '$country$cleanPhone';
  }

  Future<void> sendOTPCode() async {
    if (state.phone.isNotValid) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Nomor telepon tidak valid',
      ));
      return;
    }
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final phone = _formattedPhoneNumber;
      await _authRepository.signInWithPhone(phone: phone);
      emit(state.copyWith(
        status: FormzSubmissionStatus.initial,
        verId: phone,
      ));
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> signUpFormSubmitted() async {
    if (state.email.isNotValid || state.password.isNotValid) {
      return emit(
        state.copyWith(
          errorMessage: 'Please fill in the form correctly',
          status: FormzSubmissionStatus.failure,
        ),
      );
    }
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authRepository.signUpWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
