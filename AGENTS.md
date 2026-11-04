# Panduan kerja agent — Kasih

Panduan ini berlaku untuk seluruh repository. Ikuti instruksi pengguna dan panduan yang lebih spesifik pada subdirektori bila tersedia. Jangan menganggap dokumen produk sebagai izin melakukan deploy, mengubah data produksi, atau memublikasikan aplikasi.

## Konteks dan sumber requirement

Kasih sedang dimigrasikan dari baseline Flutter e-Imunisasi menjadi aplikasi pasien segala usia. Rename dan branding sudah dilakukan; banyak alur parent/child, vaksin, dan buku sehat masih merupakan implementasi baseline. Jangan mengklaim fitur target sudah tersedia tanpa inspeksi source dan verifikasi.

Baca dokumen sesuai scope pekerjaan:

- [README](README.md): setup dan cara run.
- [BRD](docs/plans/2026-09-30-e-patient-business-requirements.md): tujuan bisnis, scope fase, aturan bisnis.
- [PRD](docs/product/2026-10-02-e-patient-prd.md): journey, functional requirements, state, acceptance criteria.
- [Pemetaan kapabilitas](docs/product/2026-10-11-e-imunisasi-to-e-patient-capability-mapping.md): MAP-01 sampai MAP-15 dan dependensi adaptasi.
- [Timeline](docs/plans/2026-10-04-e-patient-build-timeline.md): rencana delivery, bukan bukti semua fitur selesai.
- [CI setup](docs/engineering/github-actions-setup.md): secrets, workflow, dan batas release.

Jika dokumen/source bertentangan, jelaskan temuan dan tandai keputusan yang belum final. Jangan menetapkan diam-diam scope baru, policy refund, ambang usia legal, program vaksin, atau interpretasi klinis. Migration tracker adalah catatan historis; metadata baseline/branch harus diperiksa terhadap Git bila diperlukan.

## Toolchain dan setup

- Versi Flutter bersumber dari `.fvmrc` (saat ini 3.29.3). Gunakan `fvm flutter` dan `fvm dart` secara lokal, bukan SDK global dengan versi berbeda.
- Android memakai Java 17, compile/target SDK 35, min SDK 23. Jangan upgrade SDK/dependency di luar scope tanpa alasan konkret dan verifikasi kompatibilitas.
- `.vscode/settings.json` mengarah ke `.fvm/flutter_sdk`; jangan memasukkan path SDK absolut milik komputer tertentu.
- `.env` lokal dibaca oleh flutter_dotenv melalui aset `pubspec.yaml`. Jangan menghapus pendaftaran aset untuk mengatasi build yang belum memiliki konfigurasi; CI memiliki generator placeholder.
- Setup dependency dan code generation:

```sh
fvm flutter pub get
fvm dart run build_runner build --delete-conflicting-outputs
```

Jangan menimpa `.env` pengguna. Script `.github/scripts/write-app-env.mjs` menulis `.env` di working directory; jalankan `--check` untuk validasi tanpa menulis, atau gunakan direktori sementara saat menguji generator.

## Struktur dan pola implementasi

- Ikuti struktur fitur yang ada: `data` untuk model/repository, `logic` untuk Cubit/BLoC, `presentation` untuk layar/widget.
- Reuse `core` untuk perilaku bersama; jangan membuat abstraksi baru hanya untuk satu pemakaian sederhana.
- Akses backend melalui repository, bukan langsung dari callback widget. Routing mengikuti GoRouter di `lib/routers/`.
- Dependency injection mengikuti GetIt/Injectable. Ubah annotation/source dan regenerate; jangan mengedit `lib/injection.config.dart` manual.
- `.g.dart`, `.mocks.dart`, dan `.config.dart` merupakan generated files. Sebagian masih tracked dari baseline; periksa diff setelah code generation dan pertahankan perubahan yang relevan. Jangan menyuntingnya untuk menyembunyikan warning.
- Gunakan fixture model nyata untuk value object immutable bila tidak memerlukan behavior mock; mock repository/service boundary yang memang dibutuhkan test.
- Migrasikan satu kapabilitas/increment yang dapat direview. Mengganti kata “anak” menjadi “pasien” belum mengubah model akses, data, dan lifecycle.

## Invariant bisnis dan data pasien

1. Akun login berbeda dari profil pasien. Actor berbeda dari pasien yang dilayani; payer dapat berbeda dari keduanya.
2. Household/KK, status pasangan, emergency contact, atau pembayaran tidak otomatis memberikan akses klinis.
3. Izin/grant harus eksplisit, sesuai scope, dapat dicabut, dan diperiksa ulang saat membaca data atau melakukan tindakan. Pending/revoked/expired/suspended bukan akses aktif.
4. Jangan membawa jawaban klinis, cache, atau dokumen antar pasien saat patient switcher berubah.
5. User-added tidak sama dengan provider-verified. Pertahankan tanggal kejadian, sumber, status, dan provenance; unknown bukan “normal”.
6. Jangan auto-merge profil atau catatan klinis berdasarkan nama/kontak yang sama. Sediakan review konflik/salah pasien sesuai requirement.
7. Status payment, appointment, check-in, dan encounter terpisah. Client redirect/screenshot bukan bukti paid; QR bukan bukti pelayanan selesai atau vaksin diberikan.
8. Retry harus aman dari duplikasi transaksi/booking. Refund, reconciliation, cancellation, dan exception mengikuti policy yang disepakati.
9. Data offline adalah salinan terakhir; cache/expiry dan invalidasi ketika revoke diketahui harus jelas. Jangan menjanjikan pencabutan instan pada perangkat yang tidak terhubung.
10. Tidak membuat diagnosis, terapi, atau jadwal vaksin klinis otomatis tanpa scope dan validasi sumber/reviewer yang relevan.

## UI dan identitas produk

- Nama produk user-facing: **Kasih**; nama package Dart adalah `kasih` untuk kompatibilitas.
- Theme utama: Material 3, hitam-putih/grayscale, **border radius 0** untuk komponen UI. Status tidak boleh disampaikan hanya melalui warna.
- Dukung font scaling, label screen reader, feedback loading/error, dan konteks pasien yang jelas pada alur sensitif.
- Gunakan `assets/images/e_patient_logo.png` dan `assets/images/e_patient_care.png` sesuai pemakaiannya. Jangan mengembalikan bayi/imunisasi sebagai representasi default semua pasien.
- Untuk ikon platform, gunakan `node scripts/regenerate-brand-icons.mjs` pada macOS setelah master berubah. Masking ikon oleh OS berbeda dari radius UI aplikasi.
- Jangan rename `Seribase`, tabel/API, OAuth provider, atau contract backend hanya karena identitas aplikasi berubah; validasi kompatibilitas terlebih dahulu.
- Modul pediatrik/vaksin tetap dapat memakai istilah khusus bila fitur itu memang spesifik; jangan menghapus domain klinis yang masih relevan.

## Secret, logging, dan CI

- Jangan commit `.env`, signing key, `android/key.properties`, credential backend, atau nilai secret. Gunakan `.env.example` untuk nama konfigurasi, tanpa nilai nyata.
- File env yang dibundel dapat dibaca dari APK; hanya konfigurasi client boleh di dalamnya. Supabase service-role key, OAuth client secret, dan server key gateway tetap di backend.
- Jangan mencetak token, password/OTP, NIK/KK, isi klinis, atau file pasien ke log/analytics. Saat debugging, gunakan kategori/status dan identifier yang aman sesuai kebutuhan.
- CI otomatis memakai dummy dan tidak membutuhkan secret. Development APK manual memakai environment `development`, dengan secrets/variables yang didokumentasikan.
- Jangan memakai secrets untuk source PR fork melalui pull_request_target. Batasi permission workflow dan upload hanya artifact yang dimaksud, bukan root workspace atau `.env`.
- Jangan mengaktifkan `.github/legacy-workflows/`, release GitHub, atau Play Store deployment tanpa permintaan pengguna yang mencakup tindakan tersebut.
- Jangan melemahkan analysis/test gate dengan continue-on-error atau no-fatal-warnings untuk membuat workflow hijau; perbaiki sumber masalah.

## Verifikasi sesuai perubahan

Untuk perubahan source/runtime, jalankan analisis dan test yang mencakup dampaknya. Untuk perubahan CI/build atau perubahan lintas fitur, jalankan rangkaian yang digunakan pipeline:

```sh
fvm flutter analyze
fvm flutter test --coverage --reporter expanded
fvm flutter build apk --debug
```

- Jalankan code generation bila annotation/model/generated import berubah; lakukan sebelum checks yang bergantung pada hasilnya.
- Format hanya file Dart yang diubah: `fvm dart format <files>`.
- Tambahkan/regresikan test untuk perilaku bermakna: akses lintas pasien, revoke, retry, status, atau parsing sumber. Jangan hanya menguji salinan implementasi.
- Perubahan dokumentasi saja cukup memeriksa tautan, path, konsistensi dengan source, dan `git diff --check`; tidak perlu build ulang aplikasi.
- Jangan mengklaim workflow GitHub, OAuth, payment, iOS, atau fitur perangkat sudah terbukti hanya karena analysis/build lokal sukses. Laporkan apa yang diuji dan batasnya.

## Git dan handoff

- Periksa branch, status, dan diff sebelum mengubah file; pertahankan perubahan pengguna yang tidak terkait.
- Jika perlu branch baru, gunakan prefix `codex/` kecuali pengguna menentukan nama lain. Jangan berpindah branch jika pekerjaan sudah berada pada branch yang sesuai tanpa alasan.
- Commit ketika diminta pengguna, dengan staging target eksplisit. Jangan memasukkan dokumen/fitur lain yang masih belum siap atau secret lokal.
- Jangan push, membuat release, atau deploy hanya karena commit diminta; ikuti scope otorisasi.
- Handoff menyebut perubahan, alasan utama, hasil checks, blocker yang tersisa, serta commit bila dibuat. Perbarui requirement/docs yang relevan bila keputusan produk berubah.
