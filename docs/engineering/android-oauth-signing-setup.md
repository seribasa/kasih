# Android debug/release signing dan OAuth App Links

## Konfigurasi yang dipakai

- Package development: `digital.seribasa.kasih.debug`.
- Keystore development menggunakan key yang sudah ada pada baseline e-Imunisasi; tidak membuat signing identity baru.
- Public SHA-256: `24:1B:E5:AE:94:DE:90:63:87:48:63:36:CC:C2:B4:49:5E:4C:0D:C9:42:AF:A1:64:75:D1:1F:BA:45:87:D2:8B`.
- Package release: `digital.seribasa.kasih`, dengan key release lama yang terpisah. SHA-256: `D4:76:0F:61:B3:8A:33:CD:F9:85:06:D7:47:9B:4D:E4:90:C9:68:BF:46:B5:F7:C9:8B:9F:AB:13:6E:9C:58:C1`.
- Callback native default: `https://kasih-app.peltops.com/`. Root dipilih karena sudah dilayani auth router; bukan route baru `/auth/callback`.
- Gateway/API staging: `https://kasih-base-staging.peltops.com/`. Nilai ini dipakai melalui `SUPABASE_URL` dan/atau `PAYMENT_URL`, bukan sebagai callback OAuth aplikasi.
- Flutter handler default dinonaktifkan pada Android agar Supabase/app_links menangani callback. MainActivity tetap exported untuk launcher/App Link, dengan launch mode singleTop; plugin menangani link saat cold start maupun warm intent. Tidak ada pemrosesan nested Intent baru.

## GitHub Environment development

Secret signing dipisahkan per build type:

| Secret                      | Isi                                      |
| --------------------------- | ---------------------------------------- |
| `DEBUG_KEYSTORE_BASE64`     | Binary keystore development dalam base64 |
| `DEBUG_KEY_ALIAS`           | Alias private key                        |
| `DEBUG_KEY_PASSWORD`        | Password private key                     |
| `DEBUG_KEYSTORE_PASSWORD`   | Password keystore                        |
| `RELEASE_KEYSTORE_BASE64`   | Binary keystore release dalam base64     |
| `RELEASE_KEY_ALIAS`         | Alias private key release                |
| `RELEASE_KEY_PASSWORD`      | Password private key release             |
| `RELEASE_KEYSTORE_PASSWORD` | Password keystore release                |

Setiap job memerlukan empat secret sesuai build type, bukan key dari tipe lain. Untuk `build_type=both`, kedelapan secret diperlukan. Script memvalidasi keystore/password dengan keytool. Salah konfigurasi menggagalkan job; release tidak pernah fallback ke debug key. CI placeholder tetap tidak membutuhkan key/secret dan tidak dijanjikan dapat membuka verified App Links.

Script `.github/scripts/configure-signing.mjs` membaca `BUILD_TYPE=debug` atau `release` dan menulis file lokal sementara:

- `android/keystore/debug.jks` atau `android/keystore/release.jks`, serta `android/key.properties`, permission 0600.
- `build/app-links/assetlinks-debug.json` atau `assetlinks-release.json`, hanya package dan fingerprint publik.

Keystore dan password tidak diupload sebagai artifact dan tidak dicetak. File signing dihapus pada cleanup workflow. Dalam build type yang sama, Midtrans dan Stripe memakai key/package sama dan tidak dapat diinstall berdampingan. Debug dan release memiliki application ID berbeda sehingga dapat dipasang bersamaan, tetapi masing-masing perlu asosiasi App Link dengan fingerprint yang sesuai.

Untuk penggunaan lokal, simpan file signing secara privat. Jangan menimpa `key.properties` yang sudah ada. Konfigurasi debug Gradle membaca:

```properties
debugStoreFile=keystore/debug.jks
debugKeyAlias=<alias>
debugKeyPassword=<key-password>
debugStorePassword=<store-password>
```

Konfigurasi release memakai `storeFile=keystore/release.jks`, `keyAlias`, `keyPassword`, dan `storePassword`. Kedua path relatif terhadap folder `android`. Script sengaja menolak menimpa konfigurasi yang sudah ada. Untuk menambahkan konfigurasi tipe lain secara lokal tersedia opsi fungsi `merge: true` yang hanya mengizinkan penambahan tipe yang belum ada; workflow tidak memerlukan merge karena tiap job terisolasi. Key asli harus tetap dibackup.

## Publish assetlinks pada domain

[Entry debug](../deployment/assetlinks-development.json) dan [entry release](../deployment/assetlinks-release.json) berisi identitas key terverifikasi saat setup. Gabungkan kedua statement ke array yang sudah ada pada:

`https://kasih-app.peltops.com/.well-known/assetlinks.json`

**Jangan mengganti seluruh file dengan entry tunggal ini bila aplikasi e-Imunisasi masih perlu didukung.** Statement untuk package e-Imunisasi release/debug dapat tetap ada. Fingerprint yang sama tidak membuat package baru terdaftar otomatis; `digital.seribasa.kasih.debug` tetap memerlukan statement sendiri.

Server harus menyajikan HTTPS valid, status 200, Content-Type application/json, dan tanpa redirect. Artifact publik dari build development juga menyediakan statement sesuai key aktual runner; cocokkan fingerprint sebelum publish.

Mengubah file di repository ini tidak otomatis mengubah website peltops.com. Repo/deployment pemilik domain harus menerbitkan perubahan tersebut. Fingerprint release di sini sesuai APK yang ditandatangani langsung dengan key lama; untuk distribusi Play Store dengan Play App Signing, gunakan app-signing certificate dari Play Console, yang dapat berbeda dari upload certificate lokal.

## Supabase dan Keycloak: dua redirect berbeda

Alur native:

```text
Aplikasi → Supabase authorize → Keycloak/Seribase
         → callback server Supabase → HTTPS callback aplikasi → Android App Link
```

1. Pada Auth URL Configuration Supabase, tambahkan redirect URL tepat `https://kasih-app.peltops.com/` ke allowlist. Jangan mengganti Site URL global hanya untuk build Android jika aplikasi web lain masih memakainya.
2. Keycloak client tetap mengizinkan callback **server Supabase** yang dipakai provider, umumnya URL Auth `/auth/v1/callback`. Jangan menggantinya menjadi URL App Link Android.
3. App memanggil OAuth Keycloak dengan scopes openid, explicit redirectTo native, dan browser eksternal. Pada web, redirect/launch tetap mengikuti platform web.
4. Override callback melalui `.env` lokal atau variable environment GitHub `AUTH_REDIRECT_URL`. Hanya HTTPS root `kasih-app.peltops.com` yang didukung. Jangan memasukkan token, parameter next, fragment, atau kredensial ke konfigurasi callback.
5. Keberhasilan membuka browser bukan keberhasilan login. Navigasi aplikasi mengikuti session signedIn/Authenticated; failure launch tampil pada layar login.

Untuk local `.env` yang sudah ada, default bekerja tanpa menambah field. Bila ingin eksplisit:

```dotenv
AUTH_REDIRECT_URL=https://kasih-app.peltops.com/
```

Jangan memasukkan authorization code atau token asli ke command, log, screenshot, atau issue saat troubleshooting.

## Verifikasi

Setelah domain dan allowlist selesai, build/install APK development yang memakai key tetap, lalu periksa perangkat:

```sh
adb shell pm verify-app-links --re-verify digital.seribasa.kasih.debug
adb shell pm get-app-links digital.seribasa.kasih.debug
```

Ulangi pemeriksaan dengan package `digital.seribasa.kasih` untuk release. Saat keduanya terinstall dan sama-sama terverifikasi pada host yang sama, periksa aplikasi mana yang menerima callback.

Tunggu proses verifikasi OS selesai; domain yang dipakai harus berstatus verified. Tes link tanpa memaksa package agar benar-benar menguji resolusi Android:

```sh
adb shell am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d https://kasih-app.peltops.com/
```

Lanjutkan uji OAuth dari aplikasi pada cold start dan saat aplikasi masih di background. Jangan memakai URL berisi token untuk uji manual. Karena domain Kasih hanya diklaim Kasih, tidak ada benturan App Link dengan e-Imunisasi pada host ini.

Update dari APK yang sebelumnya memakai signing key lain dapat gagal. Jangan menguninstall atau menghapus data aplikasi pengguna otomatis; rencanakan transisi signing/data dengan tester bila terjadi mismatch.

## Batas validasi

Analysis/test/build dan fingerprint membuktikan konfigurasi source serta signing artifact. OAuth end-to-end baru terbukti setelah domain, allowlist server, sesi pengguna, dan provisioning profil diuji. Setup ini khusus Android; iOS memerlukan AASA/Associated Domains dan signing tersendiri.

## Referensi

- [Android Digital Asset Links](https://developer.android.com/training/app-links/configure-assetlinks)
- [Flutter deep linking dan handler plugin](https://docs.flutter.dev/ui/navigation/deep-linking)
- [Supabase native deep linking](https://supabase.com/docs/guides/auth/native-mobile-deep-linking)
- [Supabase Flutter OAuth](https://supabase.com/docs/reference/dart/auth-signinwithoauth)
