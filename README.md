# Kasih

Kasih adalah aplikasi Flutter untuk pengelolaan perjalanan kesehatan pasien dan keluarga lintas usia. Repository ini berkembang dari baseline e-Imunisasi, dengan migrasi fitur secara bertahap berdasarkan kebutuhan bisnis dan produk.

**Status:** dalam pengembangan. Branding, setup Flutter/FVM, konfigurasi VS Code, dan build Android telah disesuaikan. Source masih memiliki alur orang tua/anak, booking vaksin, dan buku sehat dari baseline. Household berizin, booking lintas layanan, serta timeline longitudinal adalah target migrasi; belum semuanya tersedia.

## Dokumen produk

| Dokumen                                                                                                       | Kegunaan                                                                                 |
| ------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| [Business requirements](docs/plans/2026-09-30-e-patient-business-requirements.md)                             | Tujuan bisnis, model akun/pasien/keluarga, scope MVP/P1                                  |
| [Product requirements](docs/product/2026-10-02-e-patient-prd.md)                                              | Journey, requirement, state, acceptance criteria                                         |
| [Detail pemetaan e-Imunisasi → Kasih](docs/product/2026-10-11-e-imunisasi-to-e-patient-capability-mapping.md) | Elaborasi 15 kapabilitas dan urutan adaptasi                                             |
| [Build timeline](docs/plans/2026-10-04-e-patient-build-timeline.md)                                           | Rencana delivery dan dependensi                                                          |
| [Migration tracker](docs/engineering/2026-10-09-e-imunisasi-to-e-patient-migration.md)                        | Catatan awal copy baseline; metadata historis perlu dicek terhadap Git sebelum digunakan |
| [GitHub Actions setup](docs/engineering/github-actions-setup.md)                                              | Workflow, secrets, artifact, dan troubleshooting CI                                      |
| [Brand assets](docs/product/2026-10-11-e-patient-brand-assets.md)                                             | Logo, ilustrasi, prompt, dan regenerasi ikon                                             |
| [AGENTS.md](AGENTS.md)                                                                                        | Panduan kerja bagi coding agent dan contributor                                          |

## Prasyarat

- FVM dan Flutter sesuai [.fvmrc](.fvmrc), saat ini **3.29.3**. Gunakan SDK ini agar local dan CI konsisten.
- Android SDK dan **JDK 17**, dengan perangkat/emulator yang siap digunakan. Project memakai compile/target SDK 35 dan minimum SDK 23.
- VS Code dengan ekstensi Dart dan Flutter jika memakai Run & Debug.
- Untuk iOS: minimum iOS 15.0, macOS, Xcode, CocoaPods, serta konfigurasi signing yang sesuai. Workflow manual iOS tersedia untuk simulator `.app` dan signed `.ipa`; tidak melakukan deployment store.
- Node.js untuk script konfigurasi CI; Node.js dan macOS `sips` untuk regenerasi ikon. Bukan dependency runtime aplikasi Flutter.

## Setup lokal

```sh
git clone https://github.com/seribasa/e-patient.git
cd e-patient
fvm install
```

Salin `.env.example` menjadi `.env` **jika `.env` belum ada**, lalu isi nilai development. Jangan menimpa konfigurasi lokal yang sudah digunakan.

```dotenv
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-client-anon-or-publishable-key
STRIPE_PUBLISHABLE_KEY=
PAYMENT_URL=https://your-payment-backend.example
PAYMENT_GATEWAY=midtrans
PAYMENT_CURRENCY=IDR
AUTH_REDIRECT_URL=https://kasih-app.peltops.com/
```

| Konfigurasi                            | Kebutuhan                                                                          |
| -------------------------------------- | ---------------------------------------------------------------------------------- |
| `SUPABASE_URL` dan `SUPABASE_ANON_KEY` | Wajib untuk startup; harus menunjuk project yang sama                              |
| `PAYMENT_URL`                          | Diperlukan saat repository payment diinisialisasi; wajib pada build development CI |
| `STRIPE_PUBLISHABLE_KEY`               | Diperlukan bila gateway Stripe dipakai                                             |
| `PAYMENT_GATEWAY`                      | Default `midtrans`; workflow development mendukung `midtrans` atau `stripe`        |
| `PAYMENT_CURRENCY`                     | Default `IDR`; sesuaikan dengan backend/gateway                                    |
| `AUTH_REDIRECT_URL`                    | Callback native HTTPS root; default `https://kasih-app.peltops.com/`               |

`.env` dibaca sebagai **aset Flutter**, bukan otomatis dari environment terminal/VS Code. File ini telah didaftarkan di `pubspec.yaml` dan tidak dilacak Git. Perubahan `.env`/aset memerlukan penghentian dan peluncuran ulang aplikasi.

Konfigurasi client ikut berada dalam APK. Jangan memasukkan Supabase service-role key, OAuth client secret, Stripe secret key, atau Midtrans server key; credential server tetap di backend.

Setelah `.env` tersedia:

```sh
fvm flutter pub get
fvm dart run build_runner build --delete-conflicting-outputs
fvm flutter devices
fvm flutter run -d <device-id>
```

Code generation menyiapkan dependency injection, adapter, dan mocks dari source/annotation. Beberapa generated files masih dilacak dari baseline meskipun polanya ada di `.gitignore`; jangan mengeditnya manual.

## Run & Debug di VS Code

1. Buka root repository, bukan hanya folder `lib` atau `android`.
2. Setelah `fvm install`, pastikan `.fvm/flutter_sdk` tersedia; [settings.json](.vscode/settings.json) mengarah ke SDK tersebut.
3. Pilih perangkat lewat status bar atau **Flutter: Select Device**.
4. Pilih **Kasih (Debug)** pada Run & Debug, kemudian tekan **F5**.

[launch.json](.vscode/launch.json) menyediakan Debug, Profile, dan Release dengan entrypoint `lib/main.dart`. Profile/release bukan alternatif signing produksi; konfigurasi release Android memerlukan keystore tersendiri.

## Verifikasi dan build

Untuk menyimpan APK/IPA tanpa retensi artifact Actions, gunakan workflow manual **Kasih Persistent Release**. Workflow mengambil binary dari build sukses dan menerbitkannya ke GitHub Release beserta checksum. [Panduan persistent releases](docs/engineering/persistent-releases.md).

```sh
fvm flutter analyze
fvm flutter test --coverage --reporter expanded
fvm flutter build apk --debug
```

APK berada di `build/app/outputs/flutter-apk/app-debug.apk`; coverage di `coverage/lcov.info`. Android memakai application ID `digital.seribasa.kasih`, dengan suffix `.debug` untuk build debug. Untuk release, lengkapi konfigurasi key release yang terpisah lalu jalankan `fvm flutter build apk --release`; hasilnya `app-release.apk`. Build release bukan deployment otomatis ke Play Store.

Untuk kompilasi iOS lokal (minimum iOS 15.0):

```sh
fvm flutter build ios --release --no-codesign
fvm flutter build ios --simulator --debug
```

Pada Flutter 3.29.3 + Xcode 27, build simulator generik dapat gagal pada `debug_unpack_ios` saat `lipo -verify_arch` menerima dua arsitektur sekaligus. Untuk simulator Apple Silicon, gunakan satu arsitektur secara eksplisit:

```sh
fvm flutter build ios --simulator --debug --config-only
xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner \
  -configuration Debug -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  ARCHS=arm64 ONLY_ACTIVE_ARCH=YES CODE_SIGNING_ALLOWED=NO \
  BUILD_DIR="$PWD/build/ios" build
```

Verifikasi lokal 16 Oktober 2026: release device tanpa signing dan debug simulator ARM64 berhasil dikompilasi dengan Xcode 27. Simulator Intel/multi-arsitektur belum lolos jalur generik di atas. Compiler masih menampilkan warning dari plugin lama. Bundle identifier iOS saat ini `digital.seribasa.kasih` mengandung underscore dan perlu disepakati ulang menjadi identifier Apple yang valid sebelum menyiapkan signing/App Store; identitas Android/backend tidak diubah oleh penyesuaian build ini.

Pembaruan dependency native dibatasi ke versi yang kompatibel dengan Flutter 3.29.3: `shared_preferences` 2.5.3, `url_launcher` 6.3.2, `flutter_local_notifications` 17.2.4, `image_picker` 1.2.1, `permission_handler` 11.4.0, dan `webview_flutter` 4.13.0. Versi implementasi platform dikunci di `pubspec.lock` dan `ios/Podfile.lock`. API Dart yang dipakai aplikasi tetap kompatibel; upgrade mayor Stripe, notification, atau Flutter SDK tidak termasuk pembaruan ini. Masalah simulator multi-arsitektur adalah [issue tooling Flutter/Xcode](https://github.com/flutter/flutter/issues/188461), bukan sesuatu yang diselesaikan oleh upgrade plugin aplikasi.

Build release tanpa signing menghasilkan `build/ios/iphoneos/Runner.app`, bukan IPA siap distribusi. Instalasi ke iPhone/TestFlight memerlukan Apple signing dan provisioning yang sesuai. Buka `ios/Runner.xcworkspace` di Xcode, bukan `.xcodeproj`, agar dependensi CocoaPods ikut dimuat. Simpan `ios/Podfile.lock` untuk mengunci versi dependensi native; jalankan `pod install` melalui build Flutter, bukan `pod update` tanpa kebutuhan. Keberhasilan kompilasi belum memverifikasi login OAuth, payment, permission, atau fitur perangkat di iOS.

Saat mengubah source yang menghasilkan kode, jalankan build_runner sebelum analysis/test. Untuk format, batasi pada file Dart yang diubah:

```sh
fvm dart format path/to/changed_file.dart
```

## Struktur repository

```text
lib/
  main.dart              # Env dan inisialisasi dependency/platform
  app.dart               # Material 3 dan tema monokrom
  core/                  # Widget, utilitas, model dan dependency umum
  features/              # Modul fitur: data, logic, presentation
  routers/               # GoRouter dan route paths
  services/              # Layanan lintas fitur, termasuk notifikasi
test/                    # Test model, repository, Cubit/BLoC, dan utilitas
assets/                  # Gambar dan font
android/ ios/ web/       # Project platform
docs/                    # Business/product/delivery/engineering
.github/workflows/       # CI dan build development manual
.github/legacy-workflows/# Arsip workflow baseline, tidak dijalankan
```

Baseline menggunakan BLoC/Cubit, GetIt/Injectable, Supabase, Hive, SharedPreferences, serta integrasi payment. Nama modul seperti `vaccination`, `healthy_book`, dan model parent/child masih dipertahankan sampai migrasi domain terkait dilakukan. Theme utama memakai Material 3, hitam-putih, dan border radius nol.

## GitHub Actions dan APK

- **Kasih CI:** berjalan pada push seluruh branch, pull request, atau manual. Menjalankan code generation, analysis, test, dan build debug dengan konfigurasi placeholder. Tidak membutuhkan secret. Artifact CI tidak ditujukan untuk login/payment nyata.
- **Kasih Development iOS:** manual melalui `.github/workflows/development_ios.yml`. Pilih `app` (simulator debug dalam ZIP, tanpa Apple signing), `ipa` (release device dengan signing), atau `both`, serta gateway/currency. Memakai environment `development`; lihat [konfigurasi iOS](docs/engineering/github-actions-setup.md#workflow-ios-app-dan-ipa) untuk secrets dan variable Apple. Artifact disimpan 7 hari; tidak upload ke TestFlight/App Store.
- **Kasih Development APK:** manual, memakai environment GitHub `development`. Isi `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `PAYMENT_URL` (atau endpoint override per gateway), serta `STRIPE_PUBLISHABLE_KEY` jika Stripe. Saat Run workflow, pilih gateway dan build type (`debug`, `release`, atau `both`, default `both`), lalu currency per gateway. Kedua pilihan `both` menghasilkan empat APK; tidak perlu mengubah variable repo. Artifact/APK diberi nama gateway dan build type.
- Unduh APK dari artifact run yang berhasil, bukan tautan release e-Imunisasi lama. Workflow release/Play Store lama diarsipkan; deployment produksi belum aktif.

Debug memerlukan `DEBUG_KEYSTORE_BASE64`, `DEBUG_KEY_ALIAS`, `DEBUG_KEY_PASSWORD`, dan `DEBUG_KEYSTORE_PASSWORD`. Release memerlukan empat secret dengan prefix `RELEASE_` yang sama. Key kedua build type terpisah; CI placeholder tetap tidak memerlukan secret.

Lihat [petunjuk GitHub Actions](docs/engineering/github-actions-setup.md) dan [setup signing/OAuth Android](docs/engineering/android-oauth-signing-setup.md) untuk konfigurasi, fingerprint publik, serta langkah publish assetlinks dan allowlist callback Supabase.

## Troubleshooting

| Gejala                                                      | Pemeriksaan                                                                                                      |
| ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| `.env` tidak terbaca atau konfigurasi Supabase kosong       | Pastikan file ada di root, key terisi, terdaftar sebagai aset, lalu Stop dan Run ulang                           |
| VS Code memakai Flutter berbeda                             | Jalankan `fvm install`, cek `.fvm/flutter_sdk`, lalu Reload Window                                               |
| Import `.g.dart`, `.config.dart`, atau `.mocks.dart` hilang | Jalankan build_runner sebelum analysis/test/build                                                                |
| OAuth tidak membuka browser                                 | Periksa error Cubit/launcher dan konfigurasi URL; jangan menganggap perubahan callback saja menyelesaikan launch |
| OAuth berhasil tetapi tidak kembali                         | Cocokkan redirect URL, allowlist Supabase, konfigurasi Keycloak, App Link, package, dan signing certificate      |
| Sudah login tetapi profil tidak ditemukan                   | Periksa provisioning/link profil backend; login berhasil tidak otomatis membuat row profil                       |
| APK CI tidak bisa login                                     | Gunakan Development APK karena CI memakai konfigurasi dummy                                                      |

## Kontribusi

Baca [AGENTS.md](AGENTS.md) dan requirement fitur sebelum mengubah domain. Gunakan perubahan bertahap dengan acceptance criteria yang jelas; akun, pasien, actor, payer, dan grant tidak boleh dicampur. Sertakan hasil verifikasi serta batas fitur dalam PR. Hindari mengaktifkan deployment produksi atau mengganti identitas backend sekadar untuk membuat build lolos.
