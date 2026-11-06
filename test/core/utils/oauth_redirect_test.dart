import 'package:kasih/core/utils/oauth_redirect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defaults to the Kasih HTTPS callback domain', () {
    expect(oauthRedirectUrl(null), 'https://kasih-app.peltops.com/');
    expect(oauthRedirectUrl(''), 'https://kasih-app.peltops.com/');
  });

  test('supports the declared App Link host and normalizes the root', () {
    expect(
      oauthRedirectUrl('https://kasih-app.peltops.com'),
      'https://kasih-app.peltops.com/',
    );
    expect(
      oauthRedirectUrl(' https://kasih-app.peltops.com/ '),
      'https://kasih-app.peltops.com/',
    );
  });

  test(
    'rejects undeclared hosts, non-HTTPS, credentials, and unsupported routes',
    () {
      for (final value in [
        'https://attacker.example/',
        'https://kasih-app.peltops.com.attacker.example/',
        'http://kasih-app.peltops.com/',
        'https://name:password@kasih-app.peltops.com/',
        'https://kasih-app.peltops.com:8443/',
        'https://kasih-app.peltops.com/auth/callback',
        'https://kasih-app.peltops.com/?redirect=other',
        'https://kasih-app.peltops.com/#token',
        'not-a-url',
      ]) {
        expect(() => oauthRedirectUrl(value), throwsFormatException);
      }
    },
  );
}
