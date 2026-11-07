import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/country_code.dart';
import '../../../data/models/otp.dart';
import '../../../data/models/phone.dart';
import '../../../data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'login_phone_state.dart';

@Injectable()
class LoginPhoneCubit extends Cubit<LoginPhoneState> {
  LoginPhoneCubit(this._authRepository) : super(const LoginPhoneState());

  final AuthRepository _authRepository;

  void phoneChanged(String value) {
    final phone = Phone.dirty(value);
    emit(state.copyWith(
      phone: phone,
      status: FormzSubmissionStatus.initial,
      resetError: true,
    ));
  }

  void otpCodeChanged(String value) {
    final otpCode = OTP.dirty(value);
    emit(state.copyWith(
      otpCode: otpCode,
      status: FormzSubmissionStatus.initial,
      resetError: true,
    ));
  }

  void countryCodeChanged(String value) {
    final countryCode = CountryCode.dirty(value);
    emit(state.copyWith(
      countryCode: countryCode,
      status: FormzSubmissionStatus.initial,
      resetError: true,
    ));
  }

  void verIdChanged(String value) {
    emit(state.copyWith(verId: value, status: FormzSubmissionStatus.initial));
  }

  String get _formattedPhoneNumber {
    final phoneVal = state.phone.value.trim();
    final cleanPhone =
        phoneVal.startsWith('0') ? phoneVal.substring(1) : phoneVal;
    final country =
        state.countryCode.value.isEmpty ? '+62' : state.countryCode.value;
    return '$country$cleanPhone';
  }

  Future<void> sendOtp() async {
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

  Future<void> verifyOtp() async {
    if (state.otpCode.isNotValid) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Kode OTP tidak valid',
      ));
      return;
    }
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final phone = _formattedPhoneNumber;
      await _authRepository.verifyPhoneOtp(
        phone: phone,
        token: state.otpCode.value.trim(),
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
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

  Future<void> resendOtp() async {
    try {
      final phone = _formattedPhoneNumber;
      await _authRepository.resendPhoneOtp(phone: phone);
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
