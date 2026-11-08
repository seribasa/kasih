# Kasih Business Requirements and Delivery Plan

**Goal:** Mendefinisikan produk Kasih yang membantu pasien segala usia dan keluarganya mengelola perjalanan kesehatan secara aman, terhubung, dan mudah digunakan, dengan fondasi yang dapat berkembang dari kapabilitas e-Imunisasi.

**Architecture:** Produk dirancang sebagai platform patient-facing dengan profil pasien terpisah dari akun pengguna, pengelolaan keluarga berbasis persetujuan, dan data kesehatan longitudinal yang membedakan data terverifikasi fasyankes dari data yang diinput pengguna. Implementasi diusulkan bertahap: fondasi identitas dan keluarga, layanan inti pasien, rekam kesehatan, lalu interoperabilitas dan layanan lanjutan.

**Tech Stack:** Belum menjadi keputusan final. Baseline yang perlu divalidasi dari e-Imunisasi adalah Flutter, Feature-First Clean Architecture, BLoC/Cubit, Supabase, penyimpanan lokal terenkripsi, notifikasi lokal/push, Midtrans, Stripe, serta integrasi SATUSEHAT berbasis HL7 FHIR melalui backend yang berwenang.

---

## 1. Status dokumen

| Atribut | Nilai |
|---|---|
| Jenis | Business Requirements Document (BRD) dan phased delivery plan |
| Status | Draft untuk discovery dan validasi stakeholder |
| Tanggal | 30 September 2026 |
| Fokus | Business requirements terlebih dahulu; belum mengotorisasi coding |
| Sumber awal | Ringkasan fitur e-Imunisasi yang diberikan oleh product owner |
| Konteks repository | Greenfield; belum ada source code atau keputusan arsitektur yang tervalidasi |
| Pemilik keputusan | Product owner Kasih / Seribasa |

### 1.1 Cara membaca prioritas

- **MVP / Must:** wajib untuk membuktikan proposisi nilai utama secara aman.
- **P1 / Should:** bernilai tinggi setelah fondasi MVP stabil.
- **P2 / Could:** ekspansi produk, diferensiasi, atau monetisasi lanjutan.
- **Out:** sengaja tidak masuk scope saat ini.

### 1.2 Keputusan yang belum boleh dianggap final

- Apakah Kasih merupakan aplikasi consumer mandiri, produk white-label untuk fasyankes, atau model B2B2C.
- Siapa operator/pengendali data, siapa mitra pemroses data, dan siapa pemilik operasional klinis.
- Apakah platform mencatat rekam medis resmi atau hanya menampilkan salinan/ringkasan dari fasyankes.
- Jalur legal dan teknis integrasi SATUSEHAT.
- Batas layanan klinis: booking saja, telekonsultasi, home care, e-resep, atau kombinasi.
- Model pendapatan dan tanggung jawab refund/cancellation.

## 2. Executive summary

Kasih bukan sekadar e-Imunisasi yang mengganti objek “anak” menjadi “pasien”. Perluasan ke semua umur mengubah kebutuhan inti menjadi:

1. Satu orang dapat menjadi pengguna akun, pasien, wali, caregiver, sekaligus pembayar.
2. Satu rumah tangga dapat berisi anak, pasangan, orang tua, lansia, atau tanggungan lain dengan hak akses berbeda.
3. Data kesehatan menjadi longitudinal dan lintas kebutuhan: preventif, kuratif, kontrol penyakit kronis, obat, laboratorium, dokumen, dan kunjungan.
4. Privasi tidak dapat disamakan dengan relasi keluarga. Keanggotaan dalam satu KK tidak otomatis memberikan akses penuh ke data medis anggota lain.
5. Data dari pasien dan data dari nakes/fasyankes perlu dibedakan secara jelas agar tidak menyesatkan.
6. Produk perlu melayani perjalanan sebelum, saat, dan setelah kunjungan, bukan hanya transaksi booking.

### 2.1 Product thesis

> Kasih adalah pendamping kesehatan keluarga yang memberikan satu tempat aman untuk mengelola profil anggota keluarga, janji temu, pengingat, dokumen dan ringkasan kesehatan, serta akses ke layanan kesehatan—dengan kontrol akses tetap berada pada pasien atau wali yang sah.

### 2.2 Nilai utama

- **Untuk pasien:** mengurangi informasi kesehatan yang tercecer dan pekerjaan administratif berulang.
- **Untuk keluarga/caregiver:** memungkinkan bantuan terkontrol kepada anak, lansia, dan tanggungan.
- **Untuk fasyankes/nakes:** meningkatkan kualitas data pra-kunjungan, mengurangi no-show, dan memberi kesinambungan pasca-kunjungan.
- **Untuk bisnis:** menciptakan engagement berulang melalui kebutuhan keluarga, reservasi, pembayaran, reminder, dan program kesehatan.

## 3. Problem statement

### 3.1 Masalah pengguna

- Riwayat kesehatan tersebar pada banyak fasyankes, chat, kertas, foto, dan ingatan pribadi.
- Satu anggota keluarga sering mengurus booking, pembayaran, obat, serta dokumen anggota lain tanpa mekanisme delegasi yang jelas.
- Jadwal kontrol, obat, vaksin, pemeriksaan berkala, dan hasil laboratorium mudah terlewat.
- Pengguna harus mengulang data dasar, alergi, obat aktif, dan riwayat penting pada setiap kunjungan.
- Sulit membedakan catatan pribadi dengan informasi klinis yang telah diverifikasi nakes.
- Pengguna kesulitan menemukan layanan yang tepat berdasarkan kebutuhan, lokasi, jadwal, harga, serta metode layanan.

### 3.2 Masalah bisnis/operasional

- No-show dan pembatalan terlambat mengurangi utilisasi jadwal fasyankes.
- Data pasien pra-kunjungan tidak lengkap atau tidak konsisten.
- Komunikasi pasca-kunjungan dan pengingat kontrol tidak terstruktur.
- Pembayaran, invoice, refund, dan rekonsiliasi sering terpisah dari appointment.
- Produk yang hanya berfokus pada imunisasi memiliki frekuensi penggunaan dan segmen pasar terbatas.

## 4. Tujuan dan non-tujuan

### 4.1 Tujuan bisnis 12–18 bulan

| ID | Tujuan | Indikator awal |
|---|---|---|
| OBJ-01 | Memperluas pasar dari orang tua dengan anak ke pasien semua umur | Distribusi profil aktif lintas kelompok umur |
| OBJ-02 | Menjadikan keluarga sebagai unit engagement tanpa mengorbankan privasi individu | Rumah tangga aktif, delegasi diterima, insiden akses tidak sah |
| OBJ-03 | Meningkatkan penyelesaian layanan digital end-to-end | Search-to-booking, booking-to-attendance, payment completion |
| OBJ-04 | Meningkatkan kesinambungan perawatan | Kontrol ulang selesai, reminder engagement, medication adherence proxy |
| OBJ-05 | Menyiapkan interoperabilitas ekosistem kesehatan | Persentase data terstruktur dan integrasi tervalidasi |
| OBJ-06 | Membangun kepercayaan | Consent completion, audit coverage, complaint resolution, security incidents |

### 4.2 Non-tujuan MVP

- Menggantikan penilaian, diagnosis, atau keputusan klinis tenaga medis.
- Memberi diagnosis otomatis atau rekomendasi pengobatan berbasis AI.
- Menjadi sistem informasi rumah sakit/fasyankes lengkap.
- Menjadi sumber kebenaran tunggal untuk seluruh rekam medis nasional.
- Memberikan akses medis penuh berdasarkan nomor KK saja.
- Menyediakan layanan kegawatdaruratan atau menjanjikan respons darurat.
- Mengelola klaim BPJS end-to-end tanpa kemitraan dan scope terpisah.
- Membuka marketplace obat resep tanpa proses resep, apotek, dan kepatuhan yang tervalidasi.

## 5. Prinsip produk dan guardrails

1. **Patient profile is not an account.** Akun adalah identitas login; profil pasien adalah subjek data kesehatan.
2. **Household is not consent.** KK/rumah tangga membantu pengorganisasian, bukan bukti hak akses medis.
3. **Least privilege by default.** Akses minimum, eksplisit, dapat dicabut, dan tercatat.
4. **Source transparency.** Setiap data menampilkan sumber, waktu, status verifikasi, dan pihak yang memperbarui.
5. **Clinical safety before convenience.** Konflik data, alergi, obat, dan identitas tidak boleh disatukan diam-diam.
6. **Accessible across life stages.** Desain harus mendukung anak, dewasa, lansia, caregiver, dan pengguna dengan keterbatasan.
7. **Graceful degradation.** Fitur inti tetap informatif ketika integrasi fasyankes, pembayaran, atau notifikasi bermasalah.
8. **No hidden secondary use.** Penggunaan data untuk analitik, promosi, atau riset memerlukan dasar dan transparansi yang tepat.

## 6. Segmen pengguna dan persona

| Persona | Kebutuhan utama | Risiko khusus |
|---|---|---|
| Pasien dewasa mandiri | Mengatur profil, booking, rekam kesehatan, consent, pembayaran | Kebocoran data sensitif; duplikasi identitas |
| Orang tua/wali anak | Mengelola beberapa anak dan jadwal preventif | Status wali tidak valid; transisi saat anak dewasa |
| Pasangan | Membantu booking/pembayaran dengan akses terbatas | Anggapan keliru bahwa pasangan berhak melihat semua data |
| Caregiver lansia/disabilitas | Mengelola jadwal, obat, dokumen, dan transport | Delegasi tidak sah; kapasitas consent |
| Remaja | Mulai berpartisipasi dalam pengelolaan kesehatan | Privasi remaja dan aturan wali perlu kajian hukum/klinis |
| Pasien tanpa akun | Dibantu wali/caregiver atau didaftarkan fasyankes | Klaim profil dan verifikasi identitas |
| Tenaga kesehatan | Data pra-kunjungan relevan dan komunikasi pasca-kunjungan | Data user-generated dianggap terverifikasi |
| Admin fasyankes | Kelola layanan, jadwal, antrean, pembayaran | Salah konfigurasi slot/harga/status |
| Customer support | Menangani akun, sengketa akses, refund | Social engineering dan akses berlebihan |
| Compliance/auditor | Consent, audit trail, retensi, insiden | Log tidak lengkap atau dapat dimanipulasi |

### 6.1 Kebutuhan per tahap kehidupan

Produk memakai satu fondasi profil pasien, tetapi home, reminder, dan layanan yang ditonjolkan harus relevan terhadap tahap kehidupan. Umur hanya salah satu sinyal; kebutuhan aktual, consent, dan kondisi pasien tetap menentukan.

| Tahap | Kebutuhan dominan | Kapabilitas relevan | Guardrail |
|---|---|---|---|
| Bayi dan balita | Imunisasi, pertumbuhan, kunjungan rutin, dokumen kelahiran | Guardian-managed profile, vaksin, growth chart, reminder | Hanya guardian berwenang; kurva memakai standar tervalidasi |
| Anak | Preventive care, riwayat sakit, alergi, sekolah/aktivitas | Family booking, dokumen, alergi, reminder | Partisipasi anak disesuaikan usia dan hasil kajian |
| Remaja | Transisi kemandirian, kesehatan preventif, privasi sensitif | Shared management, privacy control bertahap | Aturan kerahasiaan/consent perlu legal-clinical review khusus |
| Dewasa | Akses layanan, hasil, obat, preventive screening | Self-managed profile, booking, timeline, payment | Pengguna memegang kontrol grant |
| Ibu hamil/nifas | Jadwal pemeriksaan, hasil, rencana perawatan | Care plan, calendar, documents, provider link | Bukan pengganti pemantauan klinis atau emergency service |
| Dewasa dengan kondisi kronis | Kontrol berulang, obat, pengukuran, lab | Recurring appointment, medication reminder, observations | Tidak menyimpulkan diagnosis/perubahan terapi otomatis |
| Lansia mandiri | Kesederhanaan akses, kontrol, obat, aksesibilitas | Self profile, large text, reminder, emergency contact | Tidak menganggap lansia selalu dependent |
| Lansia/dependent dengan caregiver | Delegasi, koordinasi multi-caregiver, pembayaran | Granular grant, audit, care circle | Kapasitas consent/perwalian perlu dibuktikan sesuai risiko |

### 6.2 Jobs to be done prioritas

- “Ketika saya perlu berobat, saya ingin menemukan dan memesan layanan yang cocok untuk diri sendiri atau orang yang sah saya bantu, sehingga prosesnya tidak berulang dan statusnya jelas.”
- “Ketika keluarga saya memiliki banyak jadwal kesehatan, saya ingin melihat dan mengingatnya dalam satu tempat tanpa membuka data yang tidak diberikan kepada saya.”
- “Ketika saya berpindah fasyankes, saya ingin membawa ringkasan/dokumen yang benar dan tahu sumbernya.”
- “Ketika saya meminta pasangan atau caregiver membantu, saya ingin memilih apa yang boleh mereka lakukan dan menarik izin kapan saja.”
- “Ketika transaksi bermasalah, saya ingin mengetahui siapa yang bertanggung jawab, status uang saya, dan kapan masalah selesai.”

## 7. Model konseptual akun, pasien, dan keluarga

### 7.1 Entitas bisnis utama

| Entitas | Definisi | Aturan kunci |
|---|---|---|
| User Account | Identitas untuk login dan tindakan digital | Satu akun dapat terkait ke satu atau lebih profil pasien |
| Patient Profile | Individu yang menerima layanan kesehatan | Dapat ada tanpa login; harus punya identitas minimum dan status verifikasi |
| Household | Wadah pengorganisasian keluarga/caregiver | Tidak memberikan akses klinis otomatis |
| Household Membership | Hubungan profil dengan household | Dapat aktif, pending, ditolak, keluar, atau dicabut |
| Care Relationship | Relasi caregiver/dependent/wali | Harus punya tipe, dasar, periode, dan bukti bila diperlukan |
| Access Grant | Izin akun A mengakses profil pasien B | Granular per scope, expiry, dan revocable |
| Consent Record | Bukti persetujuan untuk tujuan tertentu | Versioned, timestamped, purpose-specific, auditable |
| Encounter | Interaksi pelayanan kesehatan | Terhubung ke pasien, fasyankes, nakes, waktu, dan sumber |
| Health Record Item | Item klinis/nonklinis longitudinal | Memiliki sumber, status verifikasi, koreksi, dan provenance |
| Appointment | Reservasi layanan | Terpisah dari encounter karena booking bisa batal/tidak hadir |
| Order/Payment | Kewajiban dan transaksi finansial | Pembayar tidak otomatis memperoleh akses medis |

### 7.2 Jenis pengelolaan profil

- **Self-managed:** pasien dewasa mengelola profilnya sendiri.
- **Guardian-managed:** wali sah mengelola profil anak/dependent.
- **Delegated:** pasien memberi akses tertentu kepada caregiver.
- **Facility-assisted:** profil dibuat/dihubungkan oleh fasyankes, lalu dapat diklaim pengguna.
- **Unclaimed dependent:** profil tanggungan belum mempunyai akun sendiri.

### 7.3 Scope akses yang disarankan

| Scope | Contoh kewenangan |
|---|---|
| Profile basic | Melihat/memperbarui data demografi yang diizinkan |
| Appointment | Membuat, menjadwal ulang, atau membatalkan appointment |
| Payment | Membayar dan melihat invoice; tidak otomatis melihat diagnosis |
| Medication support | Melihat jadwal obat dan menandai pengingat |
| Documents | Melihat/mengunggah dokumen yang diizinkan |
| Clinical summary | Melihat ringkasan klinis tertentu |
| Full record | Akses luas; harus sangat terbatas dan eksplisit |
| Emergency profile | Akses ke subset informasi darurat yang dipilih pasien |

### 7.4 Lifecycle keluarga

1. User membuat atau bergabung ke household.
2. User menambah dependent atau mengundang anggota yang memiliki akun.
3. Sistem memverifikasi identitas dan relasi sesuai tingkat risiko.
4. Pemilik profil/guardian menyetujui scope akses.
5. Aktivitas sensitif dicatat dan dapat dilihat pemilik profil.
6. Pemilik profil dapat mengurangi/mencabut akses.
7. Perubahan status usia, wali, perceraian, kematian, atau sengketa memicu review akses.
8. Keluar dari household tidak menghapus rekam medis dan tidak selalu menghapus kewajiban transaksi historis.

## 8. Pemetaan e-Imunisasi ke Kasih

Detail kebutuhan, alur, aturan bisnis, batas MVP/P1, kriteria penerimaan, dan urutan adaptasi tiap kapabilitas tersedia dalam [dokumen pemetaan kapabilitas tersendiri](../product/2026-10-11-e-imunisasi-to-e-patient-capability-mapping.md).

| Kapabilitas e-Imunisasi | Keputusan | Generalisasi untuk Kasih | Prioritas |
|---|---|---|---|
| Email/password, phone OTP, OAuth | Pertahankan | Login multi-metode, recovery, device/session management | MVP |
| PIN lokal 6 digit | Perluas | Biometrik/PIN, step-up auth untuk aksi sensitif(pakai HSM) | MVP |
| Profil orang tua | Perluas | Profil pasien/self, emergency contact, preference | MVP |
| Multi-anak | Redesain | Household multi-generasi, dependent, invitation, delegation, consent | MVP |
| Pilih anak saat booking | Pertahankan pola | Pilih “pasien yang dilayani” dari profil berizin | MVP |
| Booking imunisasi | Generalisasi | Booking konsultasi, kontrol, vaksin, lab, home care sesuai katalog | MVP terbatas |
| QR check-in | Pertahankan | QR/token check-in dengan fallback manual dan expiry | MVP/P1 |
| Pembayaran Midtrans/Stripe | Pertahankan bersyarat | Invoice layanan, promo, refund, reconciliation, payer ≠ patient | MVP terbatas |
| Buku KIA/Sehat | Redesain | Timeline kesehatan longitudinal dan ringkasan per domain | MVP bertahap |
| WHO growth chart | Pertahankan khusus | Modul pediatrik, bukan dashboard default semua pasien | P1 |
| Kalender offline | Perluas | Appointment, obat, kontrol, vaksin, pemeriksaan berkala | MVP |
| Direktori faskes/nakes | Perluas | Filter kebutuhan, layanan, lokasi, jadwal, channel, harga | MVP |
| Pesan pengumuman | Perluas | Notification center transaksional dan edukasi tersegmentasi | MVP/P1 |
| Onboarding | Redesain | Pilih tujuan, buat profil sendiri, tambah family kemudian | MVP |
| Vaksin anak | Perluas | Riwayat vaksin sepanjang usia dan rekomendasi program tervalidasi | P1 |

### 8.1 Fitur baru yang dibutuhkan karena semua umur

- Alergi dan intoleransi.
- Obat aktif, riwayat obat, dan pengingat konsumsi.
- Kondisi/diagnosis dengan provenance.
- Hasil pemeriksaan dan laboratorium.
- Tanda vital dan pengukuran mandiri.
- Dokumen kesehatan dan discharge/visit summary.
- Preventive care berdasarkan life stage, bukan hanya imunisasi anak.
- Care plan dan kontrol penyakit kronis.
- Delegasi caregiver dan consent granular.
- Emergency profile yang dapat dipilih pasien.
- Klaim profil ketika dependent memperoleh akun sendiri.
- Deteksi dan resolusi duplikasi profil.

## 9. Scope produk per fase

### 9.1 MVP — Foundation and care access

- Autentikasi, keamanan perangkat, dan session management.
- Profil pasien mandiri.
- Household, dependent anak, invitation anggota dewasa, dan akses appointment/payment.
- Direktori fasyankes, nakes, dan layanan.
- Booking, reschedule, cancel, status, QR/token check-in.
- Invoice dan pembayaran untuk metode yang disetujui bisnis.
- Timeline aktivitas dan dokumen dasar dengan label sumber.
- Kalender, reminder appointment, dan notification center.
- Consent, privacy center, audit aktivitas pengguna, dan support flow.
- Portal/operasi minimum untuk supply, schedule, booking, check-in, dan reconciliation.

### 9.2 P1 — Longitudinal health management

- Alergi, kondisi, medication list, hasil lab, tanda vital, vaksin seluruh umur.
- Medication reminder dan adherence log non-diagnostik.
- Care plan/kontrol penyakit kronis.
- Modul pediatrik dan growth chart.
- Delegasi caregiver lebih granular dan expiry.
- Integrasi sumber data fasyankes yang tervalidasi.
- Telekonsultasi/home care hanya jika model klinis dan operasional siap.

### 9.3 P2 — Ecosystem expansion

- Integrasi penjamin/asuransi sesuai kemitraan.
- Rujukan digital.
- Pharmacy fulfillment/e-prescription sesuai regulasi dan mitra.
- Program korporasi/komunitas.
- Family wellness plan dan paket berlangganan.
- Insight personal yang bersifat edukatif dan dapat dijelaskan, bukan diagnosis otomatis.

## 10. Functional business requirements

### 10.1 Identity, authentication, and account security

| ID | Requirement | Priority | Acceptance bisnis |
|---|---|---|---|
| AUTH-001 | User dapat mendaftar/login dengan metode yang disetujui | MVP | Metode memiliki verifikasi, error recovery, dan kebijakan duplikasi akun |
| AUTH-002 | Sistem memverifikasi email/nomor telepon sebelum dipakai untuk recovery/aksi sensitif | MVP | Identitas kontak tidak dianggap valid sebelum verifikasi berhasil |
| AUTH-003 | User dapat memulihkan akses tanpa membuka data medis kepada pihak tidak sah | MVP | Recovery memakai step-up verification dan tercatat |
| AUTH-004 | User dapat melihat serta mengakhiri sesi/perangkat aktif | MVP | Sesi yang dicabut tidak dapat mengakses API berikutnya |
| AUTH-005 | Aplikasi mendukung PIN/biometrik perangkat | MVP | Fallback aman tersedia; rahasia tidak dikirim sebagai plaintext |
| AUTH-006 | Aksi berisiko memerlukan autentikasi ulang | MVP | Contoh: ubah identitas, ekspor data, beri full-record access, hapus akun |
| AUTH-007 | Account lock/risk control berlaku pada percobaan tidak wajar | MVP | Tidak memblokir permanen tanpa recovery yang layak |
| AUTH-008 | User mendapat notifikasi keamanan penting | P1 | Login perangkat baru, perubahan credential, atau grant akses baru |

### 10.2 Patient profile and identity resolution

| ID | Requirement | Priority | Acceptance bisnis |
|---|---|---|---|
| PROF-001 | User dapat membuat profil dirinya dengan identitas minimum | MVP | Nama, tanggal lahir, jenis kelamin administratif, kontak; field wajib dikaji |
| PROF-002 | Profil dapat memuat NIK dan nomor identitas kesehatan bila dasar pemrosesan tersedia | MVP/P1 | Data sensitif dimasking dan aksesnya dibatasi |
| PROF-003 | Sistem menandai level verifikasi identitas | MVP | Minimal: unverified, contact-verified, identity-verified, facility-linked |
| PROF-004 | Sistem mencegah atau menandai potensi duplikasi profil | MVP | Tidak melakukan merge otomatis atas data klinis |
| PROF-005 | User dapat memperbarui data kontak/preferensi dan mengajukan koreksi data terverifikasi | MVP | Data terverifikasi tidak ditimpa tanpa workflow koreksi |
| PROF-006 | Profil mempunyai emergency contact terpisah dari caregiver access | P1 | Kontak darurat tidak otomatis mendapat akses akun |
| PROF-007 | User dapat memilih bahasa, zona waktu, channel notifikasi, dan kebutuhan aksesibilitas | P1 | Preferensi diterapkan konsisten |
| PROF-008 | Sistem mengelola status aktif, deceased, merged, disputed, dan archived secara terkontrol | P1 | Riwayat tidak hilang dan akses ditinjau ulang |

### 10.3 Household, dependent, and delegated access

| ID | Requirement | Priority | Acceptance bisnis |
|---|---|---|---|
| FAM-001 | User dapat membuat household dan memberi nama tampilan | MVP | Household ID bukan nomor KK |
| FAM-002 | User dapat menambahkan profil anak/dependent yang secara sah dikelola | MVP | User menyatakan relasi dan menyetujui terms khusus wali |
| FAM-003 | User mengundang anggota dewasa melalui channel terverifikasi | MVP | Tidak ada akses sebelum undangan diterima |
| FAM-004 | Anggota dewasa memilih scope yang diberikan kepada pengundang | MVP | Default minimum; full clinical access tidak preselected |
| FAM-005 | Pemilik profil dapat melihat, mengubah, memberi expiry, dan mencabut grant | MVP | Pencabutan efektif segera untuk akses baru |
| FAM-006 | Sistem mencatat siapa mengakses atau bertindak atas nama pasien | MVP | Riwayat menyebut actor dan patient yang dilayani |
| FAM-007 | Payer dapat membayar appointment tanpa otomatis memperoleh clinical access | MVP | Invoice hanya menampilkan data minimum yang diperlukan |
| FAM-008 | Sistem menangani klaim dependent menjadi self-managed | P1 | Verifikasi, notifikasi guardian, review grant, dan audit lengkap |
| FAM-009 | Perubahan usia/status hukum memicu evaluasi akses | P1 | Aturan usia dan pengecualian ditentukan legal/clinical review |
| FAM-010 | Tersedia alur dispute/suspension relasi | MVP | Support dapat membekukan grant tanpa menghapus bukti |
| FAM-011 | Satu pasien dapat dibantu oleh lebih dari satu caregiver | P1 | Masing-masing grant independen dan dapat dicabut terpisah |
| FAM-012 | Satu akun dapat menjadi anggota lebih dari satu care circle bila dibutuhkan | P2 | Tidak menyebabkan pencampuran data antar-household |

### 10.4 Directory and service discovery

| ID | Requirement | Priority | Acceptance bisnis |
|---|---|---|---|
| DIR-001 | User dapat mencari fasyankes, nakes, dan layanan | MVP | Search mendukung lokasi dan kata kunci |
| DIR-002 | User dapat memfilter hasil | MVP | Filter minimum: spesialisasi/layanan, jarak, jadwal, mode layanan |
| DIR-003 | Detail menunjukkan informasi yang cukup untuk keputusan | MVP | Alamat, kontak, layanan, jadwal, harga/estimasi, kebijakan |
| DIR-004 | Status verifikasi provider/fasyankes terlihat | MVP | Klaim pemasaran tidak tampil sebagai kredensial terverifikasi |
| DIR-005 | User dapat membuka peta atau menghubungi fasyankes | MVP | Deep link gagal memiliki fallback |
| DIR-006 | Informasi jadwal/harga memiliki timestamp pembaruan | P1 | User memahami freshness data |

### 10.5 Appointment, queue, and check-in

| ID | Requirement | Priority | Acceptance bisnis |
|---|---|---|---|
| APT-001 | User memilih pasien yang berhak ia kelola | MVP | Hanya profil dengan scope appointment yang dapat dipilih |
| APT-002 | User memilih layanan, provider, lokasi/mode, tanggal, dan slot | MVP | Slot dikonfirmasi ulang sebelum booking final |
| APT-003 | Sistem mengumpulkan alasan kunjungan dan informasi pra-kunjungan minimum | MVP | Terdapat disclaimer emergency dan privacy notice |
| APT-004 | User melihat harga, biaya admin, cancellation, dan refund sebelum konfirmasi | MVP | Total tidak berubah tanpa reconfirmation |
| APT-005 | Booking memiliki status lifecycle yang konsisten | MVP | Draft, awaiting payment, confirmed, checked-in, completed, cancelled, no-show, expired |
| APT-006 | User dapat reschedule/cancel sesuai kebijakan | MVP | Dampak biaya/refund ditampilkan sebelum tindakan |
| APT-007 | Sistem mencegah double booking atau menjelaskan konflik | MVP | Idempotency dan hold expiry dipertimbangkan pada desain |
| APT-008 | Check-in memakai QR/token unik dengan fallback manual | MVP/P1 | Token ber-expiry dan tidak mengekspos data medis |
| APT-009 | User menerima reminder bertahap dan instruksi persiapan | MVP | Preferensi channel dan quiet hours dihormati |
| APT-010 | Fasyankes dapat menunda/membatalkan dan memberi opsi tindak lanjut | MVP | Pasien mendapat notifikasi serta opsi refund/reschedule |
| APT-011 | Setelah kunjungan, appointment dapat terhubung ke encounter/summary | P1 | Link tidak mengubah status klinis tanpa sumber valid |
| APT-012 | Kebutuhan darurat dialihkan ke kanal darurat yang tepat | MVP | Aplikasi tidak menerima booking biasa sebagai respons emergency |

### 10.6 Payment, invoice, and refund

| ID | Requirement | Priority | Acceptance bisnis |
|---|---|---|---|
| PAY-001 | Sistem membuat order/invoice dari appointment atau layanan | MVP | Item, pajak/fee, diskon, total, payer, patient, merchant jelas |
| PAY-002 | Sistem mendukung payment gateway terpilih melalui backend | MVP | Credential rahasia tidak berada di aplikasi klien |
| PAY-003 | Status pembayaran berasal dari verifikasi server/webhook | MVP | Client callback saja tidak dapat menandai paid |
| PAY-004 | Retry tidak menciptakan charge/order ganda | MVP | Idempotency berlaku pada create dan callback |
| PAY-005 | User dapat melihat receipt/invoice dan status terbaru | MVP | Status payment dan appointment tidak tercampur |
| PAY-006 | Refund mengikuti policy dan menampilkan estimasi waktu | MVP | Partial/full refund serta kegagalan dapat ditelusuri |
| PAY-007 | Finance dapat merekonsiliasi transaksi | MVP | Gateway reference, order, payout, refund, exception tersedia |
| PAY-008 | Data finansial tidak memberi akses ke catatan klinis | MVP | Payer receipt memakai data minimum |
| PAY-009 | Promo/paket memiliki syarat, masa berlaku, dan reversal rule | P1 | Tidak menghasilkan saldo/discount negatif |

### 10.7 Health record and document timeline

| ID | Requirement | Priority | Acceptance bisnis |
|---|---|---|---|
| REC-001 | Pasien melihat timeline kesehatan per profil | MVP bertahap | Item diurutkan, dapat difilter, dan tidak bocor antarprofil |
| REC-002 | Setiap item menampilkan tipe, tanggal kejadian, sumber, author, dan verification status | MVP | User-generated tidak tampak sebagai provider-verified |
| REC-003 | User dapat menambah catatan/dokumen pribadi | MVP | Label “dicatat pengguna” selalu terlihat |
| REC-004 | Data provider-linked bersifat read-only bagi pasien dengan correction request | P1 | Koreksi tidak menghapus versi asli |
| REC-005 | Timeline mendukung encounter summary, diagnosis/condition, tindakan, resep/obat, hasil, vaksin, dan dokumen | P1 | Terminologi dan status konsisten |
| REC-006 | Informasi alergi dan obat aktif mendapat prioritas visual | P1 | Konflik/duplikasi tidak di-merge diam-diam |
| REC-007 | User dapat mengunduh atau membagikan subset data dengan consent dan expiry | P1 | Link/token dapat dicabut dan diaudit |
| REC-008 | Sistem menangani data yang salah pasien atau sumber tidak dikenal | MVP/P1 | Ada report, quarantine, dan investigation flow |
| REC-009 | Sistem tidak menghapus item klinis final tanpa retention/correction policy | MVP | Penghapusan akun tidak otomatis merusak kewajiban retensi |
| REC-010 | Data sensitif tertentu dapat memiliki aturan akses tambahan | P1 | Kebijakan ditentukan legal/clinical governance |

### 10.8 Medication, preventive care, and measurements

| ID | Requirement | Priority | Acceptance bisnis |
|---|---|---|---|
| MED-001 | User melihat medication list dengan status dan sumber | P1 | Aktif, selesai, dihentikan, unknown dibedakan |
| MED-002 | User dapat membuat reminder tanpa mengubah resep klinis | P1 | Reminder jelas bukan instruksi/resep baru |
| MED-003 | User dapat mencatat consumed/skipped beserta waktu | P1 | Catatan self-reported dan dapat dikoreksi |
| MED-004 | Reminder tidak menjanjikan adherence atau outcome klinis | P1 | Missed reminder tidak dianggap missed dose otomatis |
| PREV-001 | Produk menampilkan preventive schedule sesuai kelompok yang tervalidasi | P1 | Sumber guideline dan tanggal versi terlihat |
| PREV-002 | Vaksin sepanjang usia dapat dicatat dan dibedakan sumbernya | P1 | Provider record dan self-upload tidak disamakan |
| MEAS-001 | User dapat mencatat pengukuran rumah | P1 | Unit, perangkat/sumber, waktu, dan rentang validasi disimpan |
| MEAS-002 | Grafik tidak memberi diagnosis otomatis | P1 | Outlier memicu pesan aman dan jalur konsultasi, bukan diagnosis |
| PED-001 | Growth chart hanya untuk profil pediatrik yang relevan | P1 | Standar, jenis kelamin referensi, usia, dan unit tervalidasi |

### 10.9 Calendar, notification, and messaging

| ID | Requirement | Priority | Acceptance bisnis |
|---|---|---|---|
| CAL-001 | Kalender menggabungkan appointment, kontrol, obat, vaksin, dan aktivitas pribadi | MVP/P1 | User dapat memfilter per pasien dan tipe |
| CAL-002 | Data sensitif pada lock-screen notification diminimalkan | MVP | Default tidak menyebut diagnosis/obat sensitif |
| CAL-003 | User mengatur channel, kategori, quiet hours, dan opt-out non-wajib | MVP | Pesan layanan wajib dibedakan dari promosi |
| CAL-004 | Reminder memperhitungkan zona waktu dan perubahan jadwal | MVP | Tidak mengirim reminder usang setelah cancel/reschedule |
| MSG-001 | Notification center menyimpan status unread/read dan deep link aman | MVP | Deep link memvalidasi session dan authorization |
| MSG-002 | Fasyankes dapat mengirim pesan transaksional terarah | P1 | Hanya ke pasien/actor yang berhak dan sesuai tujuan |
| MSG-003 | Marketing consent terpisah dari consent layanan | MVP | Penolakan marketing tidak menghambat layanan inti |
| MSG-004 | Two-way clinical chat tidak masuk MVP kecuali SLA dan governance siap | Out/MVP | Tidak ada kesan monitoring real-time tanpa staffing |

### 10.10 Consent, privacy, and patient rights

| ID | Requirement | Priority | Acceptance bisnis |
|---|---|---|---|
| CON-001 | Consent dicatat per tujuan dan versi kebijakan | MVP | Who, what, purpose, time, channel, version tersedia |
| CON-002 | User dapat melihat dan mencabut consent yang dapat dicabut | MVP | Konsekuensi dijelaskan sebelum pencabutan |
| CON-003 | Access grant keluarga dipisahkan dari terms layanan/marketing | MVP | Satu persetujuan tidak membundel tujuan tidak terkait |
| CON-004 | User dapat meminta akses, koreksi, ekspor, atau penghapusan sesuai hak dan kewajiban retensi | MVP/P1 | Request memiliki SLA, verifikasi, dan outcome audit |
| CON-005 | Sistem menyimpan audit trail aksi sensitif | MVP | Actor, subject, action, time, device/context, outcome |
| CON-006 | Support tidak dapat melihat data klinis secara default | MVP | Elevation time-bound, reasoned, approved, audited |
| CON-007 | Breach/incident workflow memiliki mekanisme identifikasi subjek terdampak | MVP | Bukti dan timeline tersedia untuk respons kepatuhan |
| CON-008 | Analytics memakai minimisasi/pseudonimisasi sesuai tujuan | MVP | Event tracking tidak mengirim clinical free text |

### 10.11 Support and dispute resolution

| ID | Requirement | Priority | Acceptance bisnis |
|---|---|---|---|
| SUP-001 | User dapat melaporkan masalah akun, booking, pembayaran, data, atau akses keluarga | MVP | Kategori, severity, evidence, dan SLA tercatat |
| SUP-002 | Sengketa akses keluarga mendapat jalur prioritas | MVP | Grant dapat ditangguhkan tanpa menghapus audit |
| SUP-003 | Refund dan payment dispute dapat ditelusuri end-to-end | MVP | Support melihat data finansial minimum yang relevan |
| SUP-004 | Clinical concern diarahkan ke fasyankes/nakes, bukan diputuskan support umum | MVP | Escalation ownership dan disclaimer jelas |
| SUP-005 | User menerima nomor tiket dan status penyelesaian | P1 | Tidak perlu mengirim ulang data sensitif di kanal informal |

### 10.12 Provider and operations capabilities

Fitur consumer tidak dapat berfungsi tanpa supply-side minimum berikut:

| ID | Requirement | Priority |
|---|---|---|
| OPS-001 | Onboarding dan verifikasi fasyankes/nakes/merchant | MVP |
| OPS-002 | Katalog layanan, lokasi, harga, durasi, persiapan, policy | MVP |
| OPS-003 | Jadwal, slot, capacity, blackout, cut-off, overbooking rule | MVP |
| OPS-004 | Booking worklist dan status transition | MVP |
| OPS-005 | Check-in, reschedule, cancel, no-show, completion | MVP |
| OPS-006 | Payment/refund/reconciliation view | MVP |
| OPS-007 | Encounter summary/document publishing dengan authorisasi | P1 |
| OPS-008 | User/role management dan segregation of duties | MVP |
| OPS-009 | Audit, incident, and correction queue | MVP |
| OPS-010 | Content/program/reminder management dengan approval | P1 |

## 11. Business rules

### 11.1 Identity and family rules

- BR-001: Nomor KK tidak boleh menjadi satu-satunya faktor pemberian akses medis.
- BR-002: Anggota dewasa harus menerima undangan dan memilih scope, kecuali terdapat dasar perwalian yang tervalidasi.
- BR-003: Pembuat household bukan otomatis pemilik semua profil di dalamnya.
- BR-004: Hanya satu self-managed primary account diperbolehkan per patient identity; konflik masuk review.
- BR-005: Menghapus anggota dari household tidak menghapus medical history.
- BR-006: Akses yang dicabut mencegah akses berikutnya, namun audit historis tetap dipertahankan.
- BR-007: Booking dan pembayaran “atas nama pasien” harus merekam actor terpisah dari patient.
- BR-008: Umur legal dan aturan consent anak/remaja harus dikonfigurasi berdasarkan hasil kajian hukum, bukan hard-code asumsi produk.

### 11.2 Clinical information rules

- BR-009: Item user-generated selalu berlabel non-verified sampai diverifikasi pihak berwenang.
- BR-010: Item provider-verified tidak dapat diedit langsung oleh pasien; koreksi memakai amendment workflow.
- BR-011: Konflik data tidak diatasi dengan last-write-wins untuk data klinis penting.
- BR-012: Diagnosis/condition tidak boleh disimpulkan dari gejala atau hasil ukur oleh aplikasi.
- BR-013: Timestamp kejadian, timestamp pencatatan, dan sumber harus dibedakan.
- BR-014: Satu profil tidak boleh menerima item klinis sebelum patient matching melewati threshold yang disetujui.
- BR-015: Informasi emergency adalah subset pilihan pasien dan tidak menjamin kelengkapan.

### 11.3 Booking and payment rules

- BR-016: Slot hanya dianggap dimiliki setelah hold/confirmation berhasil.
- BR-017: Status paid tidak boleh berasal dari client redirect saja.
- BR-018: Cancellation oleh fasyankes harus menawarkan reschedule/refund sesuai policy.
- BR-019: Payer dapat berbeda dari patient dan booking actor.
- BR-020: Informasi medis tidak dicetak pada invoice kecuali benar-benar diperlukan.
- BR-021: Perubahan harga setelah user konfirmasi memerlukan persetujuan ulang.
- BR-022: Retry dan webhook duplikat tidak boleh menggandakan order, appointment, atau refund.

## 12. Alur bisnis kritis

### 12.1 Onboarding pasien dewasa mandiri

1. User memilih metode registrasi dan memverifikasi kontak.
2. User menyetujui terms dan privacy notice versi aktif.
3. User membuat profil dirinya; sistem mengecek potensi duplikasi.
4. User mengatur PIN/biometrik dan preferensi notifikasi.
5. User masuk ke home dengan action utama: cari layanan, tambah keluarga, atau lengkapi profil.
6. Data identitas tingkat tinggi diverifikasi hanya saat diperlukan oleh layanan/integrasi.

### 12.2 Menambahkan anak/dependent

1. Guardian memilih “Tambah anggota yang saya kelola”.
2. Sistem menjelaskan perbedaan dependent dan anggota dewasa.
3. Guardian mengisi identitas minimum dan relasi.
4. Guardian memberikan attestation/bukti sesuai risk tier.
5. Sistem melakukan deduplication check.
6. Profil dibuat sebagai guardian-managed dengan audit record.
7. Sistem menawarkan preventive setup yang relevan tanpa menganggap diagnosis.

### 12.3 Mengundang pasangan/anggota dewasa

1. Pengundang memasukkan kontak terverifikasi atau mengirim secure invite.
2. Penerima login/registrasi dan memverifikasi kecocokan undangan.
3. Penerima memilih bergabung/tolak.
4. Jika bergabung, penerima memilih scope akses; default adalah minimum.
5. Kedua pihak menerima konfirmasi dan dapat melihat status grant.
6. Penerima dapat mencabut akses kapan saja.

### 12.4 Booking untuk anggota keluarga

1. Actor memilih pasien dari profil yang memiliki scope appointment.
2. Actor mencari layanan/provider dan memilih slot.
3. Sistem menampilkan patient, actor, payer, harga, policy, dan preparation.
4. Actor mengisi pre-visit data yang diizinkan.
5. Slot di-hold; payment dilakukan bila perlu.
6. Backend mengonfirmasi payment dan appointment.
7. Semua pihak yang relevan menerima notifikasi minimum sesuai grant.
8. Check-in dan completion dicatat tanpa mengubah akses keluarga.

### 12.5 Menambahkan dokumen/catatan pribadi

1. User memilih profil yang berhak dikelola.
2. User memilih tipe dokumen/catatan dan tanggal kejadian.
3. Sistem melakukan validasi file, malware scan, dan metadata minimum.
4. Item tampil dengan label “ditambahkan pengguna”.
5. User dapat mengoreksi metadata atau menghapus item pribadi sesuai policy.
6. Jika dibagikan ke provider, consent dan audit event dibuat.

### 12.6 Pencabutan akses caregiver

1. Pemilik profil/guardian membuka privacy center.
2. Sistem menampilkan current grants dan last activity.
3. User memilih revoke dan melihat dampaknya.
4. Revoke diterapkan untuk akses baru dan token/session terkait diinvalidasi.
5. Appointment/payment ownership yang masih aktif ditangani sesuai aturan operasional.
6. Kedua pihak mendapat notifikasi aman; audit dipertahankan.

## 13. Role and permission matrix tingkat bisnis

Legenda: **O** own, **G** jika diberi grant, **M** operasional minimum, **A** audited elevated access, **—** tidak boleh.

| Capability | Patient self | Guardian | Delegated caregiver | Payer only | Nakes | Faskes admin | Support |
|---|---:|---:|---:|---:|---:|---:|---:|
| Edit self demographic | O | G | G | — | — | M | A |
| View full clinical record | O | G | G | — | M | — | A |
| Create appointment | O | G | G | G | M | M | A |
| Cancel appointment | O | G | G | G terbatas | M | M | A |
| Pay invoice | O | G | G | G | — | M | A |
| View diagnosis | O | G | G | — | M | — | A |
| Publish verified record | — | — | — | — | M | M berotorisasi | — |
| Grant family access | O | G sesuai dasar | — | — | — | — | — |
| Reconcile payment | — | — | — | — | — | M | A |
| Resolve access dispute | — | — | — | — | — | — | A dengan approval |

Matrix final harus dipecah menjadi permission rinci dan disetujui product, legal, clinical governance, serta security.

## 14. Data classification and minimization

| Kelas | Contoh | Aturan minimum |
|---|---|---|
| Public | Nama fasyankes, alamat publik, katalog layanan | Tetap melalui content approval |
| Internal | Konfigurasi operasional non-pasien | Role-based access |
| Personal | Nama, kontak, tanggal lahir | Encryption, purpose limitation, masking |
| Sensitive personal/health | NIK, KK, diagnosis, obat, hasil lab, biometrik | Strict access, encryption, audit, no analytics leakage |
| Financial | Invoice, gateway ref, refund | Segregation, masking, retention policy |
| Security secret | Token, key, recovery secret | Vault/secure storage; tidak masuk log |

### 14.1 Data minimum per alur

- Browse directory tidak memerlukan login atau profil klinis.
- Membuat akun tidak harus meminta NIK jika belum dibutuhkan.
- Membayar untuk orang lain tidak memerlukan akses diagnosis.
- Notifikasi lock screen tidak menampilkan detail kondisi/obat secara default.
- Analytics tidak merekam clinical free text, NIK, nomor KK, atau dokumen.
- Support hanya melihat field yang diperlukan untuk tiket spesifik.

## 15. Non-functional and trust requirements

### 15.1 Security and privacy

- NFR-SEC-001: Encryption in transit dan at rest untuk data sensitif.
- NFR-SEC-002: Authorization diperiksa server-side pada setiap object, bukan hanya menu/UI.
- NFR-SEC-003: Object-level access test wajib mencakup lintas anggota keluarga.
- NFR-SEC-004: Secret dan credential gateway/integrasi hanya di lingkungan server aman.
- NFR-SEC-005: Audit log immutable/tamper-evident untuk aksi sensitif.
- NFR-SEC-006: File upload dibatasi tipe/ukuran, dipindai, dan disajikan melalui URL sementara.
- NFR-SEC-007: Backup, restore, key rotation, incident response, dan breach drill terdokumentasi.
- NFR-SEC-008: Threat model khusus family linking, account recovery, support impersonation, QR, dan deep link.

### 15.2 Reliability and performance targets untuk divalidasi

| Area | Target discovery | Catatan |
|---|---|---|
| Availability core booking | ≥99.9% bulanan | Exclude maintenance terjadwal jika disepakati |
| API read p95 | ≤2 detik pada kondisi normal | Ukur dari region target |
| Search result p95 | ≤3 detik | Dengan pagination dan degraded state |
| Payment callback processing | ≤60 detik untuk mayoritas webhook | Tampilkan pending secara jujur |
| Reminder dispatch | ≥99% job diproses dalam window | Delivery provider tidak selalu guaranteed |
| Recovery Point Objective | Ditentukan BIA | Data klinis dan transaksi mungkin berbeda tier |
| Recovery Time Objective | Ditentukan BIA | Core access vs analytics berbeda tier |

### 15.3 Accessibility and inclusivity

- Minimum WCAG 2.2 AA sebagai target antarmuka relevan.
- Mendukung font scaling, screen reader labels, kontras, target sentuh, dan reduced motion.
- Bahasa harus mudah dipahami, tidak menyalahkan pasien, dan menghindari jargon klinis tanpa penjelasan.
- Tidak bergantung hanya pada warna untuk status kesehatan/transaksi.
- Flow caregiver harus dapat digunakan oleh pengguna lansia dan low digital literacy.
- Format tanggal, waktu, unit, serta nomor mengikuti konteks Indonesia dan dapat diperluas.

### 15.4 Observability and auditability

- Korelasi aman antara booking, order, payment, encounter, dan notification tanpa memasukkan data sensitif ke log umum.
- Dashboard operasional untuk error rate, payment mismatch, failed notification, duplicate profile, dan access dispute.
- Alert memiliki runbook, owner, severity, dan escalation path.
- Product analytics dipisahkan dari audit/security logs.

## 16. Regulatory and interoperability assumptions

Dokumen ini bukan opini hukum. Legal counsel dan clinical governance harus mengonfirmasi penerapannya sebelum production.

- UU No. 27 Tahun 2022 menjadi landasan pelindungan data pribadi; data kesehatan termasuk area yang memerlukan kontrol kuat dan pemrosesan yang memiliki dasar jelas. Referensi resmi: [UU Nomor 27 Tahun 2022 tentang Pelindungan Data Pribadi](https://peraturan.bpk.go.id/Home/Download/224884/UU%20Nomor%2027%20Tahun%202022.pdf).
- Rekam medis elektronik, kerahasiaan, dan penyelenggaraannya perlu ditinjau terhadap [Permenkes Nomor 24 Tahun 2022 tentang Rekam Medis](https://peraturan.bpk.go.id/Download/301563/Permenkes%20Nomor%2024%20Tahun%202022.pdf).
- SATUSEHAT memakai standar HL7 FHIR dan identifier pasien dari Master Patient Index pada alur interoperabilitas. Referensi resmi: [Panduan interoperabilitas SATUSEHAT](https://satusehat.kemkes.go.id/platform/docs/id/interoperability/) dan [Playbook rawat jalan](https://satusehat.kemkes.go.id/platform/docs/id/interoperability/rme-rawat-jalan/).
- Akses production SATUSEHAT terkait status fasyankes dan sistem RME yang terdaftar/terverifikasi; integrasi tidak boleh diasumsikan sebagai API publik consumer biasa. Referensi resmi: [Panduan registrasi fasyankes SATUSEHAT](https://satusehat.kemkes.go.id/platform/docs/id/registration-guide/regis-institution/).
- Integrasi perlu memetakan setidaknya Patient, Encounter, Condition, AllergyIntolerance, MedicationStatement/MedicationRequest sesuai use case resmi, Observation, CarePlan, Immunization, DiagnosticReport, DocumentReference, Practitioner, Organization, dan Location—namun resource final mengikuti playbook yang benar-benar masuk scope.

### 16.1 Checklist keputusan compliance

- Tentukan peran organisasi: controller/pengendali, processor/prosesor, fasyankes, merchant, dan subprocessor.
- Susun Record of Processing Activities dan Data Protection Impact Assessment.
- Tentukan dasar pemrosesan per tujuan; jangan memakai satu consent universal.
- Tetapkan retensi per kategori data dan kewajiban rekam medis.
- Tetapkan hak subjek, identity proofing, SLA, dan pengecualian retensi.
- Tetapkan lokasi pemrosesan/penyimpanan serta mekanisme transfer bila lintas wilayah.
- Review kontrak provider, payment gateway, messaging, analytics, storage, dan support.
- Susun incident/breach response serta jalur notifikasi regulator/subjek sesuai hasil legal review.

## 17. Monetization hypotheses

Keputusan model bisnis harus diuji; jangan mengunci arsitektur pada satu hipotesis.

| Model | Nilai | Risiko/pertanyaan |
|---|---|---|
| Fee per booking | Selaras dengan transaksi | Siapa merchant of record, refund, pajak, fee transparency |
| SaaS/white-label fasyankes | Revenue berulang | Sales cycle, customization, data controller role |
| Subscription family | Fitur caregiver/premium convenience | Jangan paywall hak akses data dasar |
| Corporate wellness | Volume pengguna | Consent, separation employer-health data, discrimination risk |
| Sponsored program | Preventive campaigns | Harus transparan; hindari bias dan promosi terselubung |
| Payment/service margin | Mudah diukur | Kepatuhan, reconciliation, chargeback |

Rekomendasi discovery: validasi **B2B2C fasyankes + fee transaksi** terlebih dahulu karena supply, data terverifikasi, dan operasional booking memerlukan mitra. Subscription keluarga dapat diuji setelah retention terbukti.

## 18. Metrics framework

### 18.1 North-star candidate

**Monthly Completed Care Actions (MCCA):** jumlah tindakan perawatan bermakna yang selesai per bulan—misalnya kunjungan selesai, kontrol ulang selesai, vaksin tercatat terverifikasi, hasil ditinjau, atau regimen reminder aktif—dengan deduplikasi dan definisi anti-gaming.

### 18.2 Funnel metrics

- Registration completion rate.
- Self-profile completion dan identity verification rate.
- Household created → member invited → invite accepted.
- Search → provider detail → slot selected → booking confirmed.
- Awaiting payment → paid → attended/completed.
- Reminder sent → opened → care action completed.
- First completed care action → 30/90-day retained household.

### 18.3 Guardrail metrics

- Unauthorized access reports per 10,000 active profiles.
- Access grant dispute rate.
- Duplicate/mismatched patient incidents.
- Payment mismatch dan refund SLA breach.
- Provider cancellation/no-show rate.
- Notification opt-out/complaint rate.
- Clinical data correction request rate and resolution time.
- Support contacts per completed booking.
- Crash-free sessions and critical API failure rate.

### 18.4 Metric governance

- Setiap metric memiliki definisi, owner, denominator, exclusion, dan source of truth.
- Event analytics tidak boleh memuat NIK, KK, diagnosis free text, resep, atau file.
- Eksperimen pada consent, security, dan clinical safety tidak boleh mengurangi proteksi minimum.

## 19. Risks and mitigations

| Risiko | Dampak | Probabilitas awal | Mitigasi bisnis |
|---|---|---:|---|
| Akses pasangan/caregiver tanpa consent | Sangat tinggi | Sedang | Grant granular, invitation, revoke, audit, dispute freeze |
| Salah menghubungkan pasien | Sangat tinggi | Sedang | Identity verification, probabilistic duplicate flag, manual review, no auto-merge |
| Data user-generated dianggap diagnosis resmi | Tinggi | Tinggi | Provenance label, visual distinction, verification workflow |
| Scope terlalu luas untuk MVP | Tinggi | Tinggi | Batasi layanan dan record types; use-case gate |
| Supply fasyankes/jadwal tidak cukup | Tinggi | Sedang | Pilot partner sebelum consumer launch |
| Payment dan appointment tidak sinkron | Tinggi | Sedang | Server verification, reconciliation queue, idempotency |
| Integrasi SATUSEHAT diasumsikan terlalu mudah | Tinggi | Tinggi | Discovery legal/partner/registration lebih awal |
| Reminder klinis menyesatkan | Tinggi | Sedang | Content governance, guideline versioning, non-diagnostic language |
| Support menjadi jalur social engineering | Tinggi | Sedang | Step-up verification, least privilege, dual approval, audit |
| Data sensitif masuk analytics/log | Tinggi | Sedang | Schema allowlist, DLP checks, log review |
| Biaya operasional file dan notifikasi membengkak | Sedang | Sedang | Quota, lifecycle policy, compression, cost dashboard |
| Low digital literacy menghambat caregiver | Sedang | Tinggi | Usability test, assisted flow, accessible language |

## 20. Dependencies

- Product owner dan business sponsor yang dapat memutuskan scope.
- Legal/privacy counsel Indonesia.
- Clinical governance lead.
- Mitra fasyankes pilot dan PIC operasional.
- Payment/finance owner serta merchant configuration.
- Security owner dan incident response.
- Support operations dan SLA.
- Content/medical review untuk reminder serta preventive schedule.
- Keputusan hubungan dengan SATUSEHAT dan pihak yang memiliki hak integrasi.
- UX research dengan pasien dewasa, orang tua, caregiver lansia, dan pengguna disabilitas.

## 21. Phased delivery plan — belum mengotorisasi coding

### Phase 0: Business validation and governance

**Exit criteria:** proposisi nilai, operator model, pilot partner, scope klinis, peran data, dan unit economics hypothesis disetujui.

1. Wawancarai minimal empat kelompok: pasien mandiri, orang tua, caregiver lansia, dan fasyankes.
2. Petakan journey dan pain point nyata, bukan hanya feature preference.
3. Putuskan primary wedge: general outpatient booking + family coordination direkomendasikan.
4. Pilih 1–2 jenis layanan pilot; hindari seluruh spesialisasi sekaligus.
5. Tetapkan business owner per domain: identity, family, care, payment, compliance, operations.
6. Selesaikan legal/compliance assessment dan clinical safety boundary.
7. Validasi monetization dan merchant/refund responsibility.

### Phase 1: Service blueprint and policy definition

**Exit criteria:** seluruh critical flow memiliki happy path, exception path, owner, SLA, dan policy.

1. Finalisasi account-patient-household model.
2. Finalisasi identity assurance tiers.
3. Finalisasi consent/access grant matrix.
4. Definisikan status machine booking, payment, refund, dan encounter.
5. Susun provider onboarding dan catalog governance.
6. Susun support, dispute, correction, incident, and escalation runbooks.
7. Susun data inventory, retention schedule, dan audit requirements.
8. Buat content guidelines untuk clinical-safe copy dan emergency disclaimer.

### Phase 2: UX validation prototype

**Exit criteria:** prototype diuji dan critical safety/privacy tasks dapat diselesaikan dengan tingkat keberhasilan yang disepakati.

1. Prototype onboarding self-profile.
2. Prototype tambah anak vs undang dewasa.
3. Prototype grant/revoke access.
4. Prototype booking anggota keluarga dan pembayaran oleh orang lain.
5. Prototype source labeling pada timeline kesehatan.
6. Prototype dispute/report wrong patient data.
7. Uji dengan peserta lintas umur dan caregiver; iterasi berdasarkan severity.

### Phase 3: MVP engineering planning

**Exit criteria:** architecture decision records, backlog, test strategy, delivery estimate, dan launch controls disetujui.

Dokumen teknis berikut direncanakan dibuat setelah Phase 0–2:

- Create: `docs/architecture/adr-001-client-platform.md`
- Create: `docs/architecture/adr-002-identity-and-household-model.md`
- Create: `docs/architecture/adr-003-backend-and-data-boundaries.md`
- Create: `docs/architecture/adr-004-health-data-provenance.md`
- Create: `docs/architecture/adr-005-payment-orchestration.md`
- Create: `docs/architecture/adr-006-satusehat-integration-boundary.md`
- Create: `docs/security/threat-model.md`
- Create: `docs/security/privacy-impact-assessment.md`
- Create: `docs/operations/provider-onboarding.md`
- Create: `docs/operations/support-and-incident-runbook.md`
- Create: `docs/testing/e-patient-test-strategy.md`
- Create: `docs/product/analytics-event-spec.md`

### Phase 4: Controlled pilot

**Exit criteria:** keamanan, operasional, pembayaran, support, dan core journey memenuhi launch threshold.

1. Mulai dengan satu region/cluster dan mitra fasyankes terbatas.
2. Gunakan allowlist layanan dan user cohort.
3. Lakukan reconciliation harian dan access-log review.
4. Jalankan incident drill: wrong-patient data, account takeover, payment mismatch, provider cancellation.
5. Ukur funnel dan guardrail metrics mingguan.
6. Perluas hanya setelah exit criteria terpenuhi.

## 22. Release slices yang direkomendasikan

| Slice | Outcome | Included | Excluded |
|---|---|---|---|
| R0 Discovery | Scope tervalidasi | Research, policy, prototype | Production app |
| R1 Self Care Access | Pasien mandiri dapat booking | Auth, self profile, directory, booking, payment, reminder | Family clinical access |
| R2 Family Coordination | Keluarga dapat membantu secara aman | Dependent, invite adult, appointment/payment grant, audit | Full shared record |
| R3 Health Timeline | Pasien melihat data terstruktur awal | Documents, visit summary, source labels, correction request | Broad SATUSEHAT sync |
| R4 Care Continuity | Kontrol dan obat lebih terkelola | Medication reminder, labs, preventive care, care plan | AI diagnosis |
| R5 Interoperability | Data lintas sistem terhubung | Use cases SATUSEHAT yang disetujui | Unsupported resources |

## 23. UAT scenarios prioritas

### Identity and family

- UAT-001: Pasien dewasa membuat profil sendiri dan tidak melihat data user lain.
- UAT-002: Ayah menambah anak sebagai dependent dan ibu mendapat invitation dengan scope yang dipilih.
- UAT-003: Pasangan dewasa menolak invitation; pengundang tidak mendapat data apa pun.
- UAT-004: Pasien memberi caregiver akses appointment saja; caregiver tidak dapat melihat diagnosis.
- UAT-005: Pasien mencabut akses; caregiver yang masih login gagal membuka data berikutnya.
- UAT-006: Dua user mencoba mengklaim patient identity sama; sistem menahan merge dan membuka review.
- UAT-007: Payer membayar appointment anggota keluarga tanpa mendapat clinical access.

### Booking and payment

- UAT-008: Dua user memilih slot terakhir; hanya satu booking final terbentuk.
- UAT-009: Client kembali dari gateway tetapi webhook belum tiba; status tetap pending.
- UAT-010: Webhook dikirim ulang; tidak ada duplikasi payment/appointment.
- UAT-011: Fasyankes membatalkan; pasien memilih refund dan dapat melacak status.
- UAT-012: Appointment di-reschedule; reminder lama dibatalkan.
- UAT-013: QR kedaluwarsa; check-in manual tetap tersedia dan diaudit.

### Health records and privacy

- UAT-014: User-uploaded lab diberi label non-verified.
- UAT-015: Pasien tidak bisa mengedit diagnosis provider; dapat mengirim correction request.
- UAT-016: Dokumen salah pasien dilaporkan, disembunyikan sementara, dan diinvestigasi.
- UAT-017: Deep link notifikasi tidak membuka data saat session invalid atau grant dicabut.
- UAT-018: Support membutuhkan elevated access dengan alasan, expiry, dan audit.
- UAT-019: Export hanya berisi profil dan rentang data yang dipilih.
- UAT-020: Lock-screen notification tidak membocorkan kondisi atau nama obat sensitif.

## 24. Go/no-go criteria MVP

### Go jika semua terpenuhi

- Legal/compliance dan clinical safety sign-off.
- Pilot fasyankes, merchant, refund, dan support ownership jelas.
- Tidak ada unresolved critical/high security finding.
- Cross-profile authorization tests lulus 100% untuk critical cases.
- Payment reconciliation dan idempotency tests lulus.
- Backup restore dan incident drill berhasil.
- Consent/access audit dapat direkonstruksi end-to-end.
- Accessibility critical flows tidak memiliki blocker.
- Support SLA dan escalation on-call siap.
- Product analytics tidak mengandung prohibited health identifiers/content.

### No-go jika salah satu terjadi

- Hak akses keluarga masih bergantung pada household membership saja.
- Data user-generated dan provider-verified tidak dapat dibedakan.
- Status paid dapat dimanipulasi dari client.
- Wrong-patient data tidak memiliki containment workflow.
- Belum ada pemilik refund, clinical escalation, atau security incident.
- Integrasi eksternal production dipakai tanpa otorisasi/perjanjian yang benar.

## 25. Open questions requiring product-owner decisions

### P0 — harus diputuskan sebelum solution design

1. Siapa customer utama: pasien, keluarga, fasyankes, perusahaan, atau kombinasi?
2. Apa primary launch wedge: booking rawat jalan umum, chronic care, family health organizer, atau home care?
3. Apakah Seribasa menjadi operator platform saja atau juga penyelenggara layanan kesehatan?
4. Apakah rekam kesehatan hanya user-controlled vault, salinan dari fasyankes, atau bagian RME resmi?
5. Mitra fasyankes pertama siapa dan apa kapasitas operasionalnya?
6. Apakah rumah tangga mengikuti data KK resmi atau care circle fleksibel? Rekomendasi: care circle fleksibel, KK hanya bukti opsional.
7. Scope akses keluarga default apa? Rekomendasi: appointment + payment, tanpa clinical record.
8. Bagaimana verifikasi wali/dependent dan penanganan sengketa?
9. Layanan dan daerah pilot mana?
10. Siapa merchant of record dan siapa menanggung refund/chargeback?

### P1 — sebelum backlog MVP final

11. Apakah guest browsing dan guest booking diizinkan?
12. Apakah profil tanpa NIK dapat booking layanan tertentu?
13. Apakah QR check-in wajib atau opsional per fasyankes?
14. Dokumen/record type mana yang benar-benar masuk MVP?
15. Channel notifikasi: push, WhatsApp, SMS, email—mana transaksional vs promosi?
16. Apakah Midtrans dan Stripe sama-sama relevan pada launch market Indonesia?
17. Apakah aplikasi mendukung Bahasa Indonesia saja saat MVP?
18. Berapa SLA support untuk account takeover, access dispute, dan wrong-patient data?
19. Apakah telemedicine/home care masuk pilot atau ditunda?
20. Apakah integrasi SATUSEHAT dilakukan oleh Seribasa, fasyankes, atau vendor RME mitra?

## 26. Recommended workshop sequence

| Workshop | Peserta | Output |
|---|---|---|
| 1. Product strategy | Sponsor, product, sales, operations | Target customer, wedge, business model |
| 2. Patient and family model | Product, legal, clinical, security, UX | Household/dependent/delegation policy |
| 3. Care journey | Product, fasyankes, nakes, operations | Service blueprint dan exception flows |
| 4. Data governance | Legal, security, data, clinical | Data inventory, purpose, retention, access |
| 5. Payment operations | Finance, product, fasyankes, gateway | Merchant, fee, refund, reconciliation |
| 6. MVP scope | Semua decision owner | Prioritized backlog dan explicit exclusions |
| 7. Pilot readiness | Product, engineering, QA, security, support | Go/no-go controls dan rollout plan |

## 27. Definition of ready for engineering

Engineering belum dimulai sampai tersedia:

- Business model dan launch wedge yang disetujui.
- Daftar in-scope service types dan pilot provider.
- Persona serta journey tervalidasi riset.
- Account/patient/household policy final.
- Consent/access matrix final.
- Booking/payment status machines dan exception policy.
- Clinical record scope serta source-of-truth policy.
- Legal/privacy/clinical sign-off.
- Non-functional targets dan data classification.
- UAT scenarios serta go/no-go criteria.
- Prioritized backlog dengan owner dan acceptance criteria.

## 28. Immediate next actions

1. Product owner menjawab P0 open questions.
2. Jadwalkan Workshop 1–3 terlebih dahulu.
3. Rekrut peserta discovery: minimal 5 pasien dewasa, 5 orang tua, 5 caregiver/lansia, dan 3–5 staf fasyankes sebagai baseline kualitatif; angka final mengikuti saturation.
4. Buat prototype khusus family access sebelum dashboard visual lainnya.
5. Minta legal memo mengenai consent anggota keluarga, dependent, rekam medis, serta status platform.
6. Konfirmasi partner path untuk SATUSEHAT sebelum memasukkannya ke commitment roadmap.
7. Setelah keputusan di atas, turunkan dokumen ini menjadi PRD per release dan implementation plan teknis terpisah.

## 29. Traceability ringkas

| Business objective | Requirement groups | Primary metric |
|---|---|---|
| Perluas semua umur | PROF, REC, MED, PREV | Active profiles by life stage |
| Family coordination aman | FAM, CON, AUTH | Accepted grants vs disputes |
| Layanan end-to-end | DIR, APT, PAY | Completed care actions |
| Continuity of care | REC, MED, CAL | Follow-up completion |
| Trust and compliance | CON, NFR-SEC | Security/privacy guardrails |
| Provider value | OPS, APT, PAY | No-show, utilization, reconciliation |

---

## Appendix A — Glossary

| Istilah | Definisi kerja |
|---|---|
| Actor | User yang melakukan tindakan |
| Patient | Individu penerima layanan/subjek data kesehatan |
| Payer | Pihak yang membayar; dapat berbeda dari patient/actor |
| Guardian | Pihak dengan dasar sah mengelola dependent |
| Caregiver | Pihak yang membantu berdasarkan grant/delegasi |
| Household | Wadah pengorganisasian keluarga/care circle |
| Consent | Persetujuan untuk tujuan pemrosesan tertentu |
| Access grant | Izin operasional untuk scope data/aksi tertentu |
| Provenance | Asal, author, waktu, dan riwayat suatu data |
| Encounter | Interaksi pelayanan yang benar-benar terjadi |
| Appointment | Reservasi yang dapat atau tidak menjadi encounter |
| Fasyankes | Fasilitas pelayanan kesehatan |
| Nakes | Tenaga kesehatan |
| RME | Rekam Medis Elektronik |
| MPI | Master Patient Index |
| MCCA | Monthly Completed Care Actions |

## Appendix B — Feature ideas intentionally parked

Fitur berikut layak dieksplorasi, tetapi tidak boleh mengganggu fondasi:

- AI symptom checker/diagnosis.
- Family health score tunggal.
- Social/community feed kesehatan.
- Gamification berbasis kondisi klinis.
- Open marketplace obat resep.
- Always-on doctor chat tanpa SLA.
- Wearable/device integrations dalam jumlah besar.
- Insurance claim automation lintas penjamin.
- Emergency monitoring real-time.
- Automated clinical risk scoring tanpa governance khusus.

Alasan parkir: risiko klinis, regulatory surface, kebutuhan operasi 24/7, integrasi kompleks, atau nilai belum tervalidasi.
