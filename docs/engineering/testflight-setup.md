# Panduan Setup Deployment TestFlight iOS — Kasih

Workflow: `.github/workflows/development_ios.yml`, nama **Kasih Development iOS**.
Workflow ini dijalankan secara manual (`workflow_dispatch`), mendukung pilihan `artifact_type: testflight` atau `upload_to_testflight: true`. Workflow mengompilasi rilis iOS dengan profile App Store, menandatangani IPA, dan mengunggahnya secara otomatis ke **Apple TestFlight** via App Store Connect API.

---

## 1. Prasyarat Akun Apple

1. **Apple Developer Program**: Akun terdaftar aktif.
2. **App Store Connect App**: Aplikasi dibuat di [App Store Connect](https://appstoreconnect.apple.com/) dengan Bundle Identifier yang sesuai (misal: `digital.seribasa.kasih`).
3. **Distribution Certificate**: Sertifikat *Apple Distribution* aktif, diekspor ke format `.p12` beserta private key.
4. **App Store Provisioning Profile**: Profile jenis *App Store Distribution* (bukan Development/Ad-Hoc), tanpa daftar UDID perangkat fisik.
5. **App Store Connect API Key**: Dibuat dari menu **Users and Access → Integrations → App Store Connect API** dengan role *App Manager* atau *Developer*. Unduh file private key `.p8`.

---

## 2. Secrets dan Variables GitHub

Buka repository GitHub → **Settings → Environments → New environment → `testflight`** (atau gunakan environment `production` / `development`).

### A. App Store Connect API (Untuk Upload ke TestFlight)

| Nama Secret                     | Tipe   | Isi / Deskripsi |
| ------------------------------- | ------ | --------------- |
| `APP_STORE_CONNECT_KEY_ID`      | Secret | Key ID 10 karakter alfanumerik (misal: `2X9R4HXF34`) |
| `APP_STORE_CONNECT_ISSUER_ID`   | Secret | Issuer ID format UUID (misal: `57246542-96fe-1a63-e053-0824d0110072`) |
| `APP_STORE_CONNECT_PRIVATE_KEY` | Secret | Isi file `AuthKey_<KEY_ID>.p8` (mendukung teks raw PEM langsung maupun Base64) |

### B. Apple Signing (Untuk Codesign IPA)

| Nama                            | Tipe     | Isi / Deskripsi |
| ------------------------------- | -------- | --------------- |
| `IOS_CERTIFICATE_BASE64`        | Secret   | Sertifikat *Apple Distribution* `.p12` yang di-encode base64: `base64 -i cert.p12 \| pbcopy` |
| `IOS_CERTIFICATE_PASSWORD`      | Secret   | Password file `.p12` |
| `IOS_PROVISION_PROFILE_BASE64`  | Secret   | File `.mobileprovision` distribusi App Store dalam base64: `base64 -i profile.mobileprovision \| pbcopy` |
| `IOS_TEAM_ID`                   | Variable | Apple Developer Team ID 10 karakter (misal: `ABCDE12345`) |
| `IOS_BUNDLE_ID`                 | Variable | Explicit Apple Bundle ID terdaftar (misal: `digital.seribasa.kasih`) |

### C. Backend & Payment (Sama dengan Android/iOS Development)

| Nama                     | Tipe     | Isi / Deskripsi |
| ------------------------ | -------- | --------------- |
| `SUPABASE_URL`           | Secret   | URL project Supabase |
| `SUPABASE_ANON_KEY`      | Secret   | Anon / client key Supabase |
| `PAYMENT_URL`            | Secret   | Endpoint backend payment |
| `PAYMENT_URL_MIDTRANS`   | Secret   | Opsional: override endpoint khusus Midtrans |
| `PAYMENT_URL_STRIPE`     | Secret   | Opsional: override endpoint khusus Stripe |
| `STRIPE_PUBLISHABLE_KEY` | Secret   | Publishable key sandbox/production Stripe jika gateway stripe dipilih |
| `AUTH_REDIRECT_URL`      | Variable | Opsional: host App Link / Universal Link (default: `https://kasih-app.peltops.com/`) |

---

## 3. Parameter Input Workflow

Saat memicu workflow melalui **Actions → Kasih Deploy TestFlight iOS → Run workflow**:

| Parameter             | Default      | Pilihan / Format | Keterangan |
| --------------------- | ------------ | ---------------- | ---------- |
| `environment`         | `testflight` | `testflight`, `development`, `production` | Menentukan GitHub Environment penyedia secrets |
| `payment_gateway`     | `midtrans`   | `midtrans`, `stripe` | Gateway pembayaran yang dikonfigurasi ke dalam build |
| `midtrans_currency`   | `IDR`        | String           | Currency backend Midtrans |
| `stripe_currency`     | `IDR`        | String           | Currency backend Stripe |
| `version_name`        | *(kosong)*   | String           | Kosongkan untuk CalVer otomatis (`YYYY.MM.DD`) |
| `build_number`        | *(kosong)*   | String           | Kosongkan untuk Unix epoch seconds otomatis (selalu naik / monoton) |
| `release_notes`       | `Internal test build` | String  | Catatan versi rilis yang tampil bagi tester di aplikasi TestFlight |
| `wait_for_processing` | `false`      | Boolean          | Menunggu validasi server App Store hingga selesai atau langsung lanjut setelah upload berhasil |

---

## 4. Fitur Keamanan dan Otomasi

1. **Pre-flight Credential Validation**: Helper `.github/scripts/app-store-connect.mjs` memvalidasi kelengkapan dan format Key ID, Issuer ID, serta decoding PEM private key sebelum menjalankan build Flutter/Xcode. Jika secret tidak valid, workflow gagal dalam hitungan detik tanpa membuang waktu runner.
2. **Export Compliance Otomatis**: Tag `<key>ITSAppUsesNonExemptEncryption</key><false/>` telah disematkan di `ios/Runner/Info.plist`. Build tidak akan tertahan di status "Missing Compliance" pada dashboard App Store Connect.
3. **Pembersihan Bersih (Zero-Artifact Leak)**: Kredensial signing macOS keychain temporer dan file kunci `.p8` langsung dihapus pada langkah `always()`, baik kompilasi/upload sukses maupun gagal.
4. **Backup IPA**: File `.ipa` hasil build tersimpan selama 14 hari sebagai artifact job di GitHub Actions sebagai arsip rilis.

---

## 5. Troubleshooting

- **Error: `APP_STORE_CONNECT_KEY_ID must be a 10-character alphanumeric string`**: Pastikan Key ID disalin dari halaman App Store Connect API tanpa spasi tambahan.
- **Error: `APP_STORE_CONNECT_ISSUER_ID must be a valid UUID`**: Pastikan Issuer ID berbentuk UUID (`xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`).
- **Error: `Provisioning profile does not match export method`**: Pastikan provisioning profile yang di-upload bertipe **App Store Distribution**, bukan Development atau Ad-Hoc. Profile App Store tidak memuat daftar perangkat `ProvisionedDevices`.
- **Error: `No exported .ipa file found`**: Periksa log langkah *Archive and export App Store IPA* untuk melihat detail kegagalan kompilasi `xcodebuild`.
