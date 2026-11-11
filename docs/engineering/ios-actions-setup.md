# Workflow iOS — APP dan IPA

Workflow: `.github/workflows/development_ios.yml`, nama **Kasih Development iOS**. Manual saja, environment GitHub `development`, minimum iOS 15. Flutter mengikuti `.fvmrc`; runner `macos-15` memakai Xcode 16.4 yang dipilih eksplisit agar build tidak bergantung pada default image/Xcode 27. Ini workflow build development, bukan deployment.

## Output dan input

| Input               | Pilihan/default                                               | Output/perilaku                                                        |
| ------------------- | ------------------------------------------------------------- | ---------------------------------------------------------------------- |
| `artifact_type`        | `app` (default), `ipa`, `both`, `testflight`                  | APP adalah simulator debug, IPA adalah release signed, `testflight` ekspor & upload TestFlight |
| `upload_to_testflight` | `false` (default), `true`                                     | Upload IPA bertanda tangan ke TestFlight (otomatis menggunakan export `app-store-connect`)     |
| `payment_gateway`      | `midtrans` (default), `stripe`, `both`                        | Job/artifact terpisah per gateway                                                              |
| `midtrans_currency`    | `IDR`                                                         | Currency backend Midtrans                                                                      |
| `stripe_currency`      | `IDR`                                                         | Currency backend Stripe                                                                        |
| `export_method`        | `debugging` (default), `release-testing`, `app-store-connect` | Harus sesuai certificate dan profile; otomatis `app-store-connect` jika TestFlight dipilih     |
| `release_notes`        | `Internal test build` (default)                               | Catatan rilis untuk penguji TestFlight                                                         |
| `wait_for_processing`  | `false` (default), `true`                                     | Menunggu validasi pemrosesan build oleh Apple hingga selesai                                   |

Quality gate: test helper Node → konfigurasi dummy → pub get → code generation → analysis → seluruh test Flutter. Konfigurasi backend development baru ditulis setelah test. Artifact disimpan 7 hari dan tidak memuat file signing mentah/keychain/`.env` terpisah. Konfigurasi client tetap bisa dibaca dari app yang dibundel, jadi jangan memasukkan server secret ke `.env`.

- APP: `e-patient-<gateway>-simulator-app-<run_id>`, berisi `e-patient-<gateway>-simulator.app.zip`. ZIP mempertahankan struktur/symlink bundle. Ekstrak lalu pasang `Runner.app` ke iOS Simulator, bukan iPhone. Arsitektur mengikuti SDK/runner; workflow ini tidak membuktikan runtime di setiap mesin.
- IPA: `e-patient-<gateway>-signed-ipa-<run_id>`, berisi `.ipa`. `debugging` memerlukan development profile/certificate dan UDID perangkat terdaftar. `release-testing` memerlukan ad hoc distribution profile/certificate dan UDID terdaftar. `app-store-connect` memakai App Store distribution profile/certificate dan bukan IPA untuk sideload langsung.
- Tidak ada TestFlight upload, GitHub Release, perubahan backend, atau deployment hosting. IPA export berhasil bukan bukti memenuhi persyaratan SDK submission App Store terbaru; Xcode 16.4 dipilih untuk build yang kompatibel dengan Flutter pinned. Upgrade toolchain/validasi syarat Apple diperlukan sebelum submission nyata.

## Konfigurasi environment `development`

APP dan IPA memakai secrets backend yang sama dengan Development APK: `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `PAYMENT_URL` atau override `PAYMENT_URL_MIDTRANS`/`PAYMENT_URL_STRIPE`, serta `STRIPE_PUBLISHABLE_KEY` untuk Stripe. Variable `AUTH_REDIRECT_URL` opsional seperti Android. Apple secrets tidak diperlukan untuk APP.

Tambahan untuk IPA:

| Jenis    | Nama                           | Isi                                                                                              |
| -------- | ------------------------------ | ------------------------------------------------------------------------------------------------ |
| Secret   | `IOS_CERTIFICATE_BASE64`       | Base64 export certificate **beserta private key** dalam `.p12`                                   |
| Secret   | `IOS_CERTIFICATE_PASSWORD`     | Password file `.p12`                                                                             |
| Secret   | `IOS_PROVISION_PROFILE_BASE64` | Base64 file `.mobileprovision` eksplisit untuk aplikasi dan metode export yang dipilih           |
| Variable | `IOS_TEAM_ID`                  | Apple Developer team ID 10 karakter                                                              |
| Variable | `IOS_BUNDLE_ID`                | Bundle ID Apple yang terdaftar, sama persis dengan profile; contoh format `com.company.epatient` |

Tambahan untuk TestFlight (opsional jika hanya build APP/IPA lokal):

| Jenis  | Nama                            | Isi                                                                                     |
| ------ | ------------------------------- | --------------------------------------------------------------------------------------- |
| Secret | `APP_STORE_CONNECT_KEY_ID`      | Key ID 10 karakter alfanumerik dari App Store Connect API (misal: `2X9R4HXF34`)         |
| Secret | `APP_STORE_CONNECT_ISSUER_ID`   | Issuer ID UUID dari App Store Connect API (misal: `57246542-96fe-1a63-e053-0824d0110072`)|
| Secret | `APP_STORE_CONNECT_PRIVATE_KEY` | Isi file `AuthKey_<KEY_ID>.p8` (mendukung teks raw PEM maupun Base64)                   |

Sediakan tepat satu identity valid pada `.p12`, belum kedaluwarsa, serta profile belum kedaluwarsa. Helper memvalidasi team, UUID, explicit application identifier, masa berlaku profile, dan kecocokan jenis export. Xcode memvalidasi kecocokan certificate/profile dan entitlement saat archive/export. Wildcard profile, enterprise profile, app extension/multiple-profile archive belum didukung. Jika metode export berubah, profile dan certificate environment mungkin perlu diganti agar sesuai.

Source iOS lama masih menggunakan `digital.seribasa.kasih` (underscore tidak valid untuk Apple signing). Workflow IPA mengoverride identifier **hanya saat archive** memakai `IOS_BUNDLE_ID` yang Anda tentukan; tidak menetapkan identitas Apple baru atau mengubah application ID Android/backend. Pastikan layanan OAuth/entitlement menggunakan identifier Apple yang benar sebelum uji perangkat.

Jangan commit `.p12`, private key, profile, password, atau base64 credential. Buat base64 lokal lalu masukkan langsung ke GitHub Secrets; jangan tempel nilainya ke chat/log. Keychain sementara dan profile hasil install dibersihkan dengan langkah `always()`, termasuk ketika archive gagal. Helper dibatasi untuk konteks GitHub Actions dan tidak boleh dipakai untuk mengubah keychain workstation lokal.

## Menjalankan

1. Commit/push workflow **bersama source Flutter dan perubahan iOS/dependency yang dibutuhkan** ke branch kerja. Jangan menjalankan dari branch docs-only.
2. `workflow_dispatch` baru harus terdaftar pada default branch agar muncul di menu Actions. Jika default branch masih docs-only, registrasi workflow perlu dilakukan secara terpisah dan terotorisasi; menambah file lokal ini belum mendaftarkan workflow remote.
3. Buka Actions → **Kasih Development iOS** → Run workflow, pilih branch source, output, gateway, currency, dan metode export.
4. Unduh artifact setelah job berhasil. Bila `both` dipilih, APP diunggah sebelum signing sehingga tetap tersedia jika jalur IPA gagal.

Hanya jalankan branch/source yang dipercaya: workflow manual yang diberi environment secrets tetap menjalankan kode branch terpilih. Gunakan required reviewers/branch restrictions pada environment jika diperlukan. Tidak memakai `pull_request_target`.

## Batas verifikasi

Pengujian lokal mencakup unit test validasi profile/export options dan lint workflow; release unsigned serta simulator ARM64 telah dikompilasi lokal. Jalur signed IPA belum terbukti end-to-end sampai certificate/profile asli tersedia dan job GitHub benar-benar dijalankan. Build sukses tidak membuktikan OAuth Universal Links, payment, permission, push notification, atau runtime iPhone. Universal Links iOS memerlukan Associated Domains/AASA tersendiri; `assetlinks.json` Android tidak mencukupi.

Referensi: [Apple signing pada GitHub runner](https://docs.github.com/en/actions/how-tos/deploy/deploy-to-third-party-platforms/sign-xcode-applications), [toolchain macOS runner](https://github.com/actions/runner-images/blob/main/images/macos/macos-15-Readme.md).
