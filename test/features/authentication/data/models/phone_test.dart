import 'package:flutter_test/flutter_test.dart';
import 'package:kasih/features/authentication/data/models/phone.dart';

void main() {
  group('Phone Model', () {
    test('Phone.initial() creates pure instance with empty string', () {
      const phone = Phone.initial();
      expect(phone.value, '');
      expect(phone.isPure, true);
      expect(phone.isValid, false);
      expect(phone.error, PhoneValidationError.invalid);
    });

    test('Phone.dirty() creates dirty instance', () {
      const phone = Phone.dirty('876543210');
      expect(phone.value, '876543210');
      expect(phone.isPure, false);
      expect(phone.isValid, true);
      expect(phone.error, isNull);
    });

    group('Indonesian Phone Numbers', () {
      test('validates Indonesian 9-digit numbers without leading zero', () {
        expect(const Phone.dirty('876543210').isValid, true);
      });

      test('validates Indonesian numbers with leading zero', () {
        expect(const Phone.dirty('0876543210').isValid, true);
        expect(const Phone.dirty('081234567890').isValid, true);
      });

      test('validates Indonesian 11-13 digit numbers', () {
        expect(const Phone.dirty('81234567890').isValid, true);
        expect(const Phone.dirty('812345678901').isValid, true);
        expect(const Phone.dirty('8123456789012').isValid, true);
      });
    });

    group('International Phone Numbers (Nomor Luar Negeri)', () {
      test('validates Singapore 8-digit mobile numbers (+65)', () {
        expect(const Phone.dirty('81234567').isValid, true);
        expect(const Phone.dirty('91234567').isValid, true);
      });

      test('validates Hong Kong 8-digit numbers (+852)', () {
        expect(const Phone.dirty('91234567').isValid, true);
        expect(const Phone.dirty('51234567').isValid, true);
      });

      test('validates Malaysia 9-10 digit numbers (+60)', () {
        expect(const Phone.dirty('123456789').isValid, true);
        expect(const Phone.dirty('1234567890').isValid, true);
      });

      test('validates Australia 9-digit mobile numbers (+61)', () {
        expect(const Phone.dirty('412345678').isValid, true);
        expect(const Phone.dirty('0412345678').isValid, true);
      });

      test('validates US/Canada 10-digit numbers (+1)', () {
        expect(const Phone.dirty('2025550123').isValid, true);
        expect(const Phone.dirty('4155552671').isValid, true);
      });

      test('validates UK 10-11 digit numbers (+44)', () {
        expect(const Phone.dirty('7911123456').isValid, true);
        expect(const Phone.dirty('07911123456').isValid, true);
      });

      test('validates Japan 10-digit mobile numbers (+81)', () {
        expect(const Phone.dirty('9012345678').isValid, true);
        expect(const Phone.dirty('09012345678').isValid, true);
      });

      test('validates China 11-digit mobile numbers (+86)', () {
        expect(const Phone.dirty('13800138000').isValid, true);
      });

      test('validates Saudi Arabia 9-digit mobile numbers (+966)', () {
        expect(const Phone.dirty('512345678').isValid, true);
      });

      test('validates minimum E.164 subscriber length (6 digits)', () {
        expect(const Phone.dirty('123456').isValid, true);
      });

      test('validates maximum E.164 subscriber length (15 digits)', () {
        expect(const Phone.dirty('123456789012345').isValid, true);
      });
    });

    group('Numbers with formatting characters', () {
      test('validates numbers containing spaces', () {
        expect(const Phone.dirty('812 3456 7890').isValid, true);
        expect(const Phone.dirty(' 812 3456 7890 ').isValid, true);
      });

      test('validates numbers containing hyphens', () {
        expect(const Phone.dirty('812-3456-7890').isValid, true);
      });

      test('validates numbers containing dots', () {
        expect(const Phone.dirty('812.3456.7890').isValid, true);
      });
    });

    group('Invalid Phone Numbers', () {
      test('rejects empty string', () {
        expect(const Phone.dirty('').isValid, false);
        expect(const Phone.dirty('').error, PhoneValidationError.invalid);
      });

      test('rejects numbers that are too short (< 6 digits)', () {
        expect(const Phone.dirty('12345').isValid, false);
        expect(const Phone.dirty('8').isValid, false);
      });

      test('rejects numbers that are too long (> 15 digits)', () {
        expect(const Phone.dirty('1234567890123456').isValid, false);
      });

      test('rejects non-numeric characters', () {
        expect(const Phone.dirty('abcdefghij').isValid, false);
        expect(const Phone.dirty('812345abc').isValid, false);
        expect(const Phone.dirty(r'@#$%^&*()').isValid, false);
      });

      test('rejects numbers with all zeros or leading double zero', () {
        expect(const Phone.dirty('0000000000').isValid, false);
      });
    });
  });
}
