# APK/IPA persisten di GitHub Release

Workflow manual **Kasih Persistent Release** (`.github/workflows/persistent_release.yml`) mempromosikan binary hasil Development APK/iOS ke GitHub Release. Release assets tidak memakai masa retensi artifact Actions; file tetap tersedia sampai release/asset/repository dihapus atau kebijakan GitHub berubah. Ini bukan backup permanen maupun deployment Play Store/TestFlight.

## Cara pakai

1. Jalankan Development APK dan/atau Development iOS, lalu tunggu sukses. Untuk iOS pilih `ipa` atau `both` dan lengkapi Apple signing. Build `app` simulator saja tidak menyediakan IPA.
2. Salin run ID dari URL Actions: `/actions/runs/<run_id>`. Artifact harus belum kedaluwarsa (workflow build saat ini 7 hari). Artifact yang sudah dihapus/kedaluwarsa harus dibangun ulang.
3. Jalankan **Kasih Persistent Release** dari branch tepercaya yang memuat workflow/helper. Isi tag baru berformat CalVer (seperti LinkedIn), misalnya `v2026.11.08` atau `v2026.11.08-dev.1`, `android_run_id` dan/atau `ios_run_id`. Minimal satu run ID wajib. Jika keduanya diisi, source commit harus sama.
4. Default `prerelease=true`; mengubahnya menjadi false hanya mengubah label GitHub, bukan backend/payment mode atau sertifikasi produksi.
5. Unduh APK/IPA dari halaman Releases. Nama asset memuat tag, gateway, dan build type APK. File `SHA256SUMS` membantu mengecek integritas unduhan (`shasum -a 256 <file>`).

Workflow hanya menerima run manual sukses dari workflow Development APK/iOS pada repository yang sama. Quality gates mengikuti build sumber; tidak rebuild atau menandatangani ulang binary. CI dummy, simulator APP, association JSON, credential, dan file lain tidak dipublikasikan. Semua varian APK/IPA yang cocok pada run terpilih ikut diunggah; tidak ada pemilihan sebagian gateway/build type.

Tag GitHub Release diarahkan ke commit **build sumber**, bukan commit branch yang menjalankan publisher. Tag yang sudah ada ditolak, tanpa overwrite asset/tag. Workflow membuat draft lebih dulu, mengunggah binary/checksum, baru memublikasikan release. Jika upload gagal, draft/tag dapat tertinggal: periksa dan hapus manual jika memang tidak dibutuhkan, atau gunakan tag baru untuk retry. Jangan menghapus release yang sudah didistribusikan tanpa pertimbangan konsumen.

Tidak membutuhkan PAT atau signing secrets tambahan: memakai `GITHUB_TOKEN` dengan `actions: read` dan `contents: write`. GitHub policy repository/organization harus mengizinkan operasi release. Jangan menjalankan workflow privileged ini dari branch tidak dipercaya. Pada repository publik, binary release yang dipublikasikan juga dapat diunduh publik; konfigurasi client development yang dibundel bukan secret server.

Workflow harus terdaftar pada default branch agar menu `workflow_dispatch` tersedia. Pembuatan file ini belum melakukan registrasi remote, commit/push, atau penerbitan release. Source Flutter tidak perlu digabung ke default branch docs-only untuk menjalankan publisher, tetapi file workflow/helper perlu tersedia pada branch eksekusi.

IPA tetap terikat aturan provisioning: development/ad hoc hanya untuk perangkat terdaftar; App Store IPA bukan file sideload. Publishing tidak memverifikasi OAuth/payment/runtime perangkat.

## Manajemen Versi (CalVer + Timestamp Build Number)

Aplikasi Kasih mengadopsi skema versioning berbasis kalender (CalVer) seperti LinkedIn dipadu dengan Unix timestamp untuk build number:
- **Version Name (`versionName` / `CFBundleShortVersionString`)**: Berbasis tanggal `YYYY.MM.DD` (misal `2026.11.08`) dengan opsional patch `YYYY.MM.DD.<patch>`.
- **Build Number (`versionCode` / `CFBundleVersion`)**: Monotonik integer berbasis Unix timestamp detik (`Math.floor(Date.now() / 1000)`). Nilai ini dijamin unik per build dan mematuhi batas signed 32-bit positive integer Android (`versionCode <= 2100000000`).

### Perintah CLI Version Manager
- Periksa versi aktif:
  ```bash
  node .github/scripts/version-manager.mjs --get
  ```
- Generate versi baru (preview):
  ```bash
  node .github/scripts/version-manager.mjs --generate
  ```
- Bump `pubspec.yaml` ke tanggal dan timestamp hari ini:
  ```bash
  node .github/scripts/version-manager.mjs --bump
  ```
- Validasi format versi:
  ```bash
  node .github/scripts/version-manager.mjs --check
  ```

