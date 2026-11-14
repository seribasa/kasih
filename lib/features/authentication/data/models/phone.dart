import 'package:formz/formz.dart';

/// Validation errors for the [phone] [FormzInput].
enum PhoneValidationError {
  /// Generic invalid error.
  invalid,
}

/// {@template phone}
/// Form input for a phone number input.
/// Supports both domestic and international subscriber numbers (ITU-T E.164: 6-15 digits,
/// with optional domestic leading zero).
/// {@endtemplate}
class Phone extends FormzInput<String, PhoneValidationError> {
  /// {@macro phone}
  const Phone.initial() : super.pure('');

  /// {@macro phone}
  const Phone.dirty([String value = '']) : super.dirty(value);

  /// E.164 national significant numbers: 6 to 15 digits, with optional leading zero.
  /// Supports Indonesian numbers (8-13 digits) as well as international numbers
  /// (e.g. Singapore 8 digits, Malaysia 9-10 digits, US/UK/Japan 10 digits, China 11 digits, etc.).
  static final RegExp _phoneRegExp = RegExp(r'^0?[1-9][0-9]{5,14}$');

  @override
  PhoneValidationError? validator(String? value) {
    final clean = (value ?? '').replaceAll(RegExp(r'[\s\-\.]'), '');
    return _phoneRegExp.hasMatch(clean) ? null : PhoneValidationError.invalid;
  }
}
