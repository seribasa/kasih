import 'package:bloc_test/bloc_test.dart';
import 'package:kasih/features/authentication/data/models/country_code.dart';
import 'package:kasih/features/authentication/data/models/otp.dart';
import 'package:kasih/features/authentication/data/models/phone.dart';
import 'package:kasih/features/authentication/data/repositories/auth_repository.dart';
import 'package:kasih/features/authentication/logic/cubit/login_phone_cubit/login_phone_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateMocks([AuthRepository])
import 'login_phone_cubit_test.mocks.dart';

void main() {
  late AuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
  });

  final phone = "85211011003";
  final phoneInvalid = "12345";
  final countryCode = "+62";
  final countryCodeInvalid = "62";
  final otp = "123456";
  final otpInvalid = "12345";

  group("phoneChanged", () {
    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'phoneChanged: phone invalid and countryCode invalid',
      build: () => LoginPhoneCubit(authRepository),
      seed:
          () => LoginPhoneState(
            phone: Phone.dirty(phoneInvalid),
            countryCode: CountryCode.dirty(countryCodeInvalid),
          ),
      act: (cubit) => cubit.phoneChanged(phone),
      expect:
          () => [
            LoginPhoneState(
              phone: Phone.dirty(phone),
              countryCode: CountryCode.dirty(countryCodeInvalid),
            ),
          ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'phoneChanged: phone valid and countryCode invalid',
      build: () => LoginPhoneCubit(authRepository),
      seed:
          () => LoginPhoneState(
            phone: Phone.dirty(phoneInvalid),
            countryCode: CountryCode.dirty(countryCodeInvalid),
          ),
      act: (cubit) => cubit.phoneChanged(phone),
      expect:
          () => [
            LoginPhoneState(
              phone: Phone.dirty(phone),
              countryCode: CountryCode.dirty(countryCodeInvalid),
            ),
          ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'phoneChanged: phone invalid and countryCode valid',
      build: () => LoginPhoneCubit(authRepository),
      seed:
          () => LoginPhoneState(
            phone: Phone.dirty(phoneInvalid),
            countryCode: CountryCode.dirty(countryCode),
          ),
      act: (cubit) => cubit.phoneChanged(phone),
      expect:
          () => [
            LoginPhoneState(
              phone: Phone.dirty(phone),
              countryCode: CountryCode.dirty(countryCode),
            ),
          ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'phoneChanged: phone valid and countryCode valid',
      build: () => LoginPhoneCubit(authRepository),
      seed:
          () => LoginPhoneState(
            phone: Phone.dirty(phoneInvalid),
            countryCode: CountryCode.dirty(countryCode),
          ),
      act: (cubit) => cubit.phoneChanged(phone),
      expect:
          () => [
            LoginPhoneState(
              phone: Phone.dirty(phone),
              countryCode: CountryCode.dirty(countryCode),
            ),
          ],
    );
  });

  group("countryCodeChanged", () {
    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'countryCodeChanged: countryCode invalid and phone invalid',
      build: () => LoginPhoneCubit(authRepository),
      seed:
          () => LoginPhoneState(
            phone: Phone.dirty(phoneInvalid),
            countryCode: CountryCode.dirty(countryCodeInvalid),
          ),
      act: (cubit) => cubit.countryCodeChanged(countryCode),
      expect:
          () => [
            LoginPhoneState(
              phone: Phone.dirty(phoneInvalid),
              countryCode: CountryCode.dirty(countryCode),
            ),
          ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'countryCodeChanged: countryCode valid and phone invalid',
      build: () => LoginPhoneCubit(authRepository),
      seed:
          () => LoginPhoneState(
            phone: Phone.dirty(phoneInvalid),
            countryCode: CountryCode.dirty(countryCodeInvalid),
          ),
      act: (cubit) => cubit.countryCodeChanged(countryCode),
      expect:
          () => [
            LoginPhoneState(
              phone: Phone.dirty(phoneInvalid),
              countryCode: CountryCode.dirty(countryCode),
            ),
          ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'countryCodeChanged: countryCode invalid and phone valid',
      build: () => LoginPhoneCubit(authRepository),
      seed:
          () => LoginPhoneState(
            phone: Phone.dirty(phone),
            countryCode: CountryCode.dirty(countryCodeInvalid),
          ),
      act: (cubit) => cubit.countryCodeChanged(countryCode),
      expect:
          () => [
            LoginPhoneState(
              phone: Phone.dirty(phone),
              countryCode: CountryCode.dirty(countryCode),
            ),
          ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'countryCodeChanged: countryCode valid and phone valid',
      build: () => LoginPhoneCubit(authRepository),
      seed:
          () => LoginPhoneState(
            phone: Phone.dirty(phone),
            countryCode: CountryCode.dirty(countryCodeInvalid),
          ),
      act: (cubit) => cubit.countryCodeChanged(countryCode),
      expect:
          () => [
            LoginPhoneState(
              phone: Phone.dirty(phone),
              countryCode: CountryCode.dirty(countryCode),
            ),
          ],
    );
  });

  group("otpCodeChanged", () {
    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'otpCodeChanged: otpCode invalid',
      build: () => LoginPhoneCubit(authRepository),
      seed: () => LoginPhoneState(otpCode: OTP.dirty("123456")),
      act: (cubit) => cubit.otpCodeChanged("1234567"),
      expect: () => [LoginPhoneState(otpCode: OTP.dirty("1234567"))],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'otpCodeChanged: otpCode invalid',
      build: () => LoginPhoneCubit(authRepository),
      act: (cubit) => cubit.otpCodeChanged(otpInvalid),
      expect: () => [LoginPhoneState(otpCode: OTP.dirty(otpInvalid))],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'otpCodeChanged: otpCode valid',
      build: () => LoginPhoneCubit(authRepository),
      seed:
          () => LoginPhoneState(
            phone: Phone.dirty(phone),
            countryCode: CountryCode.dirty(countryCode),
          ),
      act: (cubit) => cubit.otpCodeChanged(otp),
      expect:
          () => [
            LoginPhoneState(
              otpCode: OTP.dirty(otp),
              phone: Phone.dirty(phone),
              countryCode: CountryCode.dirty(countryCode),
            ),
          ],
    );
  });

  group("verIdChanged", () {
    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'verIdChanged: verId valid',
      build: () => LoginPhoneCubit(authRepository),
      act: (cubit) => cubit.verIdChanged("123456"),
      expect:
          () => [
            LoginPhoneState(
              verId: "123456",
              status: FormzSubmissionStatus.initial,
            ),
          ],
    );
  });

  group("sendOtp", () {
    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'emits failure when phone is not valid',
      build: () => LoginPhoneCubit(authRepository),
      seed: () => LoginPhoneState(phone: Phone.dirty(phoneInvalid)),
      act: (cubit) => cubit.sendOtp(),
      expect:
          () => [
            LoginPhoneState(
              phone: Phone.dirty(phoneInvalid),
              status: FormzSubmissionStatus.failure,
              errorMessage: 'Nomor telepon tidak valid',
            ),
          ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'emits inProgress then success with verId when valid',
      build: () {
        when(
          authRepository.signInWithPhone(phone: '+62$phone'),
        ).thenAnswer((_) async {});
        return LoginPhoneCubit(authRepository);
      },
      seed:
          () => LoginPhoneState(
            phone: Phone.dirty(phone),
            countryCode: CountryCode.dirty(countryCode),
          ),
      act: (cubit) => cubit.sendOtp(),
      expect:
          () => [
            LoginPhoneState(
              phone: Phone.dirty(phone),
              countryCode: CountryCode.dirty(countryCode),
              status: FormzSubmissionStatus.inProgress,
            ),
            LoginPhoneState(
              phone: Phone.dirty(phone),
              countryCode: CountryCode.dirty(countryCode),
              status: FormzSubmissionStatus.success,
              verId: '+62$phone',
            ),
          ],
      verify: (_) {
        verify(
          authRepository.signInWithPhone(phone: '+62$phone'),
        ).called(1);
      },
    );
  });

  group("verifyOtp", () {
    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'emits failure when otp is not valid',
      build: () => LoginPhoneCubit(authRepository),
      seed: () => LoginPhoneState(otpCode: OTP.dirty(otpInvalid)),
      act: (cubit) => cubit.verifyOtp(),
      expect:
          () => [
            LoginPhoneState(
              otpCode: OTP.dirty(otpInvalid),
              status: FormzSubmissionStatus.failure,
              errorMessage: 'Kode OTP tidak valid',
            ),
          ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'uses state.verId over recomputing formatted phone',
      build: () {
        when(
          authRepository.verifyPhoneOtp(
            phone: '+629999999999',
            token: otp,
          ),
        ).thenAnswer((_) async => AuthResponse());
        return LoginPhoneCubit(authRepository);
      },
      seed:
          () => LoginPhoneState(
            phone: Phone.dirty(phone),
            countryCode: CountryCode.dirty(countryCode),
            otpCode: OTP.dirty(otp),
            verId: '+629999999999',
          ),
      act: (cubit) => cubit.verifyOtp(),
      expect:
          () => [
            LoginPhoneState(
              phone: Phone.dirty(phone),
              countryCode: CountryCode.dirty(countryCode),
              otpCode: OTP.dirty(otp),
              verId: '+629999999999',
              status: FormzSubmissionStatus.inProgress,
            ),
            LoginPhoneState(
              phone: Phone.dirty(phone),
              countryCode: CountryCode.dirty(countryCode),
              otpCode: OTP.dirty(otp),
              verId: '+629999999999',
              status: FormzSubmissionStatus.success,
            ),
          ],
      verify: (_) {
        verify(
          authRepository.verifyPhoneOtp(phone: '+629999999999', token: otp),
        ).called(1);
      },
    );
  });

  group("resendOtp", () {
    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'uses state.verId to resend OTP',
      build: () {
        when(
          authRepository.resendPhoneOtp(phone: '+628888888888'),
        ).thenAnswer((_) async {});
        return LoginPhoneCubit(authRepository);
      },
      seed:
          () => LoginPhoneState(
            phone: Phone.dirty(phone),
            countryCode: CountryCode.dirty(countryCode),
            verId: '+628888888888',
          ),
      act: (cubit) => cubit.resendOtp(),
      verify: (_) {
        verify(
          authRepository.resendPhoneOtp(phone: '+628888888888'),
        ).called(1);
      },
    );
  });
}
