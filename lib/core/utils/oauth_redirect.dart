/// Keep native OAuth callbacks on a manifest-declared host and the root route.
String oauthRedirectUrl(String? configuredUrl) {
  final value = configuredUrl?.trim();
  final uri = Uri.tryParse(
    value == null || value.isEmpty ? 'https://kasih-app.peltops.com/' : value,
  );
  if (uri == null ||
      uri.scheme != 'https' ||
      uri.host != 'kasih-app.peltops.com' ||
      uri.hasPort ||
      uri.userInfo.isNotEmpty ||
      (uri.path.isNotEmpty && uri.path != '/') ||
      uri.hasQuery ||
      uri.hasFragment) {
    throw const FormatException(
      'AUTH_REDIRECT_URL harus berupa root HTTPS domain App Link yang terdaftar.',
    );
  }
  return uri.replace(path: '/').toString();
}
