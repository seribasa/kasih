# GitHub Actions — Kasih

## Pipeline

- **Kasih Persistent Release:** manual, mengambil APK/IPA dari run Development yang sukses dan menerbitkan GitHub Release (default prerelease), tanpa rebuild atau deployment store. [Panduan input, retensi, dan akses](persistent-releases.md).

- **Kasih CI:** push seluruh branch, pull request, atau manual. Memakai konfigurasi dummy; code generation → analysis → seluruh test → APK debug. Tidak membutuhkan secret. APK CI hanya untuk verifikasi build, bukan uji login/payment dengan backend nyata.
- **Kasih Development APK:** manual, dengan GitHub Environment `development`. Pilih gateway `midtrans`, `stripe`, atau `both`, dan build type `debug`, `release`, atau `both`. Default build type adalah `both`. Quality gates memakai dummy; konfigurasi development ditulis sebelum build. Setiap kombinasi menghasilkan APK/artifact terpisah. Build release tetap memakai backend development; tidak mengaktifkan payment production atau deployment store.
- Flutter mengikuti `.fvmrc` (3.29.3 saat setup) dan Java 17. CI memakai signing debug bawaan; Development APK memakai keystore development tetap. Coverage disimpan sebagai artifact. Tidak publish release atau deploy ke Play Store.
- Workflow release e-Imunisasi lama serta konfigurasi Dependabot yang belum lengkap diarsipkan dalam `.github/legacy-workflows/` dan tidak aktif.

## Workflow iOS APP dan IPA

**Kasih Development iOS** adalah workflow manual untuk `.app` simulator tanpa signing atau `.ipa` device dengan Apple signing. Mendukung gateway Midtrans/Stripe/both, quality gates sebelum build, artifact 7 hari, dan tidak upload ke TestFlight/App Store. [Panduan lengkap, secrets Apple, dan batas verifikasi](ios-actions-setup.md).

## Secrets dan variables

Untuk workflow iOS lihat [bagian APP/IPA](#workflow-ios-app-dan-ipa). Konfigurasi Android di bawah tetap terpisah dari Apple signing.

Repository GitHub → **Settings → Environments → New environment → development**. Tambahkan secrets:

| Secret                      | Wajib                                   | Isi                                                                    |
| --------------------------- | --------------------------------------- | ---------------------------------------------------------------------- |
| `SUPABASE_URL`              | Ya                                      | URL project Supabase development                                       |
| `SUPABASE_ANON_KEY`         | Ya                                      | Anon/publishable client key project yang sama; bukan service-role key  |
| `PAYMENT_URL`               | Ya bila override gateway tidak tersedia | Endpoint backend payment development bersama, sebagai fallback         |
| `PAYMENT_URL_MIDTRANS`      | Opsional                                | Endpoint khusus Midtrans; mengoverride PAYMENT_URL pada build Midtrans |
| `PAYMENT_URL_STRIPE`        | Opsional                                | Endpoint khusus Stripe; mengoverride PAYMENT_URL pada build Stripe     |
| `STRIPE_PUBLISHABLE_KEY`    | Jika Stripe                             | Publishable key sandbox; boleh kosong untuk Midtrans                   |
| `DEBUG_KEYSTORE_BASE64`     | Jika build type debug/both              | File keystore debug dalam base64                                       |
| `DEBUG_KEY_ALIAS`           | Jika build type debug/both              | Alias private key debug                                                |
| `DEBUG_KEY_PASSWORD`        | Jika build type debug/both              | Password private key debug                                             |
| `DEBUG_KEYSTORE_PASSWORD`   | Jika build type debug/both              | Password keystore debug                                                |
| `RELEASE_KEYSTORE_BASE64`   | Jika build type release/both            | Keystore release dalam base64, terpisah dari debug                     |
| `RELEASE_KEY_ALIAS`         | Jika build type release/both            | Alias private key release                                              |
| `RELEASE_KEY_PASSWORD`      | Jika build type release/both            | Password private key release                                           |
| `RELEASE_KEYSTORE_PASSWORD` | Jika build type release/both            | Password keystore release                                              |

Repository secrets bernama sama dapat digunakan jika environment tidak mengoverride nilainya. Tidak perlu mengubah repository/environment Variables untuk memilih gateway atau currency. Pilihan berasal dari **Run workflow inputs**:

| Input               | Default    | Pilihan                                                           |
| ------------------- | ---------- | ----------------------------------------------------------------- |
| `payment_gateway`   | `midtrans` | `midtrans`, `stripe`, atau `both`                                 |
| `build_type`        | `both`     | `debug`, `release`, atau `both`                                   |
| `midtrans_currency` | `IDR`      | Kode currency tiga huruf uppercase yang didukung backend Midtrans |
| `stripe_currency`   | `IDR`      | Kode currency tiga huruf uppercase yang didukung backend Stripe   |

Gateway `both` dan build type `both` menghasilkan empat job independen: Midtrans debug/release dan Stripe debug/release. Currency valid secara format belum berarti didukung akun/backend; gunakan konfigurasi sandbox yang telah disepakati. Key publishable Stripe tidak dimasukkan ke APK Midtrans. Tiap job hanya menerima signing secrets untuk build type yang dipilih.

Pipeline baru tidak memerlukan `ENV_MIDTRANS_DEV`, `ENV_STRIPE_DEV`, `ENV_PAYPAL_DEV`, atau `CODECOV_TOKEN`. `GITHUB_TOKEN` disediakan otomatis oleh GitHub. Variable opsional `AUTH_REDIRECT_URL` memilih HTTPS root host App Link; default `https://kasih-app.peltops.com/`. Gateway/currency tetap dipilih lewat input, bukan variable repo.

Lihat [setup signing dan OAuth](android-oauth-signing-setup.md) untuk fingerprint key yang dipakai, statement assetlinks, allowlist Supabase, dan pengujian perangkat. Workflow mengupload `assetlinks-debug.json` / `assetlinks-release.json` sebagai artifact publik terpisah; file keystore dan password tidak ikut diupload.

File `.env` masuk ke APK sebagai aset Flutter. GitHub Secrets menghindari penyimpanan nilai di source/log, tetapi tidak merahasiakan nilai dari pemegang APK. Hanya konfigurasi client development yang boleh dimasukkan. Key server Midtrans/Stripe, Supabase service-role key, password database, dan OAuth client secret tetap di backend.

## Menjalankan

1. Push/merge workflow; file workflow manual harus tersedia di default branch agar dapat ditemukan melalui Actions.
2. Buat environment `development` dan isi konfigurasi di atas.
3. Actions → **Kasih Development APK** → **Run workflow** → pilih branch, gateway, build type, serta currency per gateway.
4. Unduh artifact `e-patient-<gateway>-<build type>-<run id>`. File di dalamnya bernama `app-<gateway>-<build type>.apk`, misalnya `app-midtrans-release.apk`.
5. Debug application ID memakai suffix `.debug` dari Gradle. Callback OAuth/App Link perlu cocok dengan package, certificate signing, domain, serta allowlist Supabase; build sukses belum membuktikan login berfungsi.

PR fork tidak memperoleh secrets; CI tetap bekerja dengan placeholder. Workflow tidak menggunakan pull_request_target. Atur proteksi environment/branch development sesuai proses tim.

Pilihan gateway belum berupa Android product flavors: dua gateway pada build type yang sama memakai application ID yang sama dan tidak dapat diinstall berdampingan. Debug (`digital.seribasa.kasih.debug`) dan release (`digital.seribasa.kasih`) memiliki ID berbeda. Fingerprint setiap tipe tetap antarrun selama key tidak diganti. Update dari APK lama yang memakai key lain tetap perlu penanganan transisi.

## Play Store nanti

Build APK release tersedia, tetapi deployment ke Play Store belum diaktifkan. Secret legacy berikut bukan nama secret yang dibaca workflow baru; saat menyiapkan deployment, nilai kembali kebutuhan signing/Play Console:

| Secret                           | Kegunaan                                    |
| -------------------------------- | ------------------------------------------- |
| `KEYSTORE_FILE`                  | Upload keystore Android dalam base64        |
| `KEY_ALIAS`                      | Alias upload key                            |
| `KEY_PASSWORD`                   | Password key                                |
| `KEYSTORE_PASSWORD`              | Password keystore                           |
| `GPLAY_SERVICE_ACCOUNT_KEY_JSON` | Credential Play Console dengan izin minimum |

Secret signing/deployment tidak masuk `.env` aplikasi. Perlu review application ID, listing Play Console, Fastlane metadata, version code, track, dan konfigurasi produksi sebelum mengaktifkan deployment. Jangan langsung mengaktifkan workflow legacy hanya dengan mengisi secrets.

## Troubleshooting

- Missing configuration: nama secret wajib belum tersedia pada environment development; nilai tidak dicetak ke log.
- File .env.dev tidak diperlukan lagi; `.env` dibuat saat workflow berjalan dan dihapus saat selesai.
- Generated import/mock hilang: langkah build_runner harus sukses; generated files tidak dilacak Git.
- Analysis/test gagal: perbaiki temuan; pipeline tidak mematikan fatal warnings atau memakai continue-on-error.
- APK CI tidak dapat login: gunakan Development APK; CI memakai placeholder.
- Missing signing secret / Cannot unlock development keystore: periksa empat secret signing; build development sengaja tidak fallback ke key acak.
- Update APK dari signing lama dapat gagal; jangan menghapus data aplikasi tanpa pertimbangan. Cocokkan fingerprint key yang terpasang dengan artifact yang hendak digunakan.

## Referensi

- [Flutter Action dan dukungan FVM](https://github.com/subosito/flutter-action)
- [GitHub: penggunaan secrets](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets)
- [GitHub: artifact workflow](https://docs.github.com/en/actions/tutorials/store-and-share-data)
