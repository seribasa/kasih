# Detail Pemetaan Kapabilitas e-Imunisasi ke e-Patient

| Atribut | Nilai |
|---|---|
| Status | Draft elaborasi kebutuhan bisnis dan produk untuk review |
| Tanggal | 11 Oktober 2026 |
| Sumber utama | [BRD bagian 8](../plans/2026-09-30-e-patient-business-requirements.md#8-pemetaan-e-imunisasi-ke-e-patient) |
| Rujukan produk | [PRD e-Patient](2026-10-02-e-patient-prd.md) |
| Rujukan delivery | [Build timeline](../plans/2026-10-04-e-patient-build-timeline.md) |
| Fokus | Menjabarkan 15 kapabilitas untuk pengembangan dan refactor bertahap |
| Pemilik review | Product Owner bersama design, engineering, operations, finance, dan reviewer privacy/klinis sesuai fitur |

## 1. Tujuan dan cara menggunakan dokumen

Dokumen ini menjelaskan perubahan makna bisnis dari aplikasi imunisasi anak menjadi aplikasi pasien lintas usia. Setiap kapabilitas memiliki kebutuhan, batas fase, alur, aturan bisnis, data minimum, penanganan pengecualian, dan kriteria penerimaan yang dapat diturunkan menjadi backlog.

Dokumen ini merupakan elaborasi BRD dan PRD, bukan laporan audit source code. Nama kapabilitas e-Imunisasi berasal dari pemetaan BRD; keberadaan, kualitas, dan kelayakan implementasi lama harus dibuktikan saat inspeksi modul. Keputusan “pertahankan” tidak otomatis berarti implementasi lama sudah memenuhi kebutuhan keamanan atau operasional e-Patient.

ID `MAP-xx` mengidentifikasi kapabilitas, sedangkan `MAP-xx-Rnn` mengidentifikasi requirement turunannya. ID ini melengkapi requirement BRD/PRD dan tidak menggantikannya. Perubahan prioritas atau scope perlu dicatat pada dokumen sumber agar tidak muncul dua backlog yang bertentangan.

### 1.1 Arti keputusan pemetaan

| Keputusan | Makna bisnis | Implikasi saat adaptasi |
|---|---|---|
| Pertahankan | Nilai dan pola utama tetap relevan | Periksa ulang identitas pasien, akses, status, dan pengecualian |
| Perluas | Pola awal berguna tetapi belum memenuhi konteks semua umur | Tambahkan role, jenis data, pilihan, atau aturan baru |
| Redesain | Asumsi produk lama tidak cukup untuk kebutuhan baru | Susun ulang model dan alur; komponen visual tetap dapat digunakan bila cocok |
| Generalisasi | Proses yang khusus imunisasi menjadi proses lintas layanan | Kebutuhan spesifik layanan menjadi konfigurasi katalog |
| Pertahankan bersyarat | Nilai bergantung pada kesiapan mitra dan model bisnis | Aktifkan hanya setelah tanggung jawab dan operasi disepakati |

### 1.2 Batas fase dan status keputusan

- **MVP:** fondasi akun, profil, keluarga berizin, akses layanan, transaksi, kalender appointment, dan dokumen dasar.
- **MVP terbatas:** hanya mitra, jenis layanan, metode pembayaran, dan kebijakan yang siap dioperasikan; bukan seluruh katalog visi produk.
- **MVP bertahap:** fungsi dasar masuk MVP; pendalaman klinis atau integrasi masuk P1.
- **MVP/P1:** bagian inti dan fallback operasional masuk MVP; perluasan bergantung kesiapan mitra.
- **P1:** setelah fondasi MVP stabil dan kebutuhan spesifik tervalidasi.
- **Usulan:** detail yang belum diputuskan pada BRD/PRD, termasuk parameter waktu, batas percobaan, dan SLA. Tidak dianggap sebagai kebijakan final.

Tidak ada ambang usia legal, jadwal vaksin, interpretasi kurva klinis, atau SLA finansial baru yang ditetapkan oleh dokumen ini. Parameter tersebut memerlukan pemilik keputusan dan validasi tersendiri.

## 2. Fondasi lintas kapabilitas

### 2.1 Pisahkan akun, pasien, pelaku, dan pembayar

| Konsep | Pertanyaan yang dijawab | Contoh |
|---|---|---|
| Akun | Siapa yang login? | Akun Rina |
| Pasien | Siapa yang menerima layanan atau memiliki catatan? | Ibu Rina |
| Actor/pelaku | Siapa yang melakukan tindakan? | Rina membuat booking untuk ibunya |
| Payer/pembayar | Siapa yang memenuhi kewajiban pembayaran? | Saudara Rina membayar invoice |
| Grant | Apa yang boleh dilakukan actor terhadap pasien? | Booking diizinkan; dokumen medis tidak diizinkan |
| Consent | Persetujuan untuk tujuan apa? | Berbagi dokumen tertentu dengan caregiver |

Identitas pembayar atau anggota keluarga tidak otomatis memberikan akses medis. Emergency contact juga tidak otomatis menjadi caregiver berizin.

### 2.2 Aturan bersama

1. Konteks pasien harus terlihat pada booking, kalender, timeline, dan tindakan sensitif.
2. Akses diperiksa kembali ketika data dibuka atau tindakan dijalankan, bukan hanya saat daftar pasien dimuat.
3. Grant pending, expired, revoked, atau suspended tidak memberi akses baru.
4. Data yang ditambahkan pengguna harus dibedakan dari data yang diterbitkan sumber layanan berwenang.
5. Status appointment, pembayaran, check-in, dan pelayanan dipisahkan; satu status tidak menjadi bukti otomatis untuk status lainnya.
6. Data dari perangkat yang offline ditandai sebagai salinan terakhir; tidak menjadi bukti slot, pembayaran, atau hak akses terbaru.
7. Support, finance, admin, dan tenaga klinis hanya melihat informasi yang diperlukan oleh tugasnya.
8. Retry tidak menggandakan booking, pembayaran, undangan, atau catatan.
9. Audit tindakan sensitif mencatat actor, pasien, tindakan, waktu, hasil, dan referensi objek terkait; isi klinis tidak dimasukkan ke analitik umum.
10. Pengguna mendapat pesan yang menjelaskan dampak dan langkah berikutnya ketika izin, transaksi, atau koneksi bermasalah.

### 2.3 Register kapabilitas dan traceability

| ID | Kapabilitas | Keputusan | Batas delivery | Rujukan PRD |
|---|---|---|---|---|
| MAP-01 | Login multi-metode | Pertahankan | MVP; metode disetujui bisnis | §7.1 Identity and Security |
| MAP-02 | PIN, biometrik, step-up | Perluas | MVP | §7.1 Identity and Security |
| MAP-03 | Profil pasien | Perluas | MVP; preference lanjutan P1 | §7.2 Patient Profile |
| MAP-04 | Household dan delegasi | Redesain | MVP dasar; lifecycle lanjutan P1 | §7.3 Family, Dependent, and Access Grants |
| MAP-05 | Pilih pasien saat booking | Pertahankan pola | MVP | §7.5 Appointment and Check-In |
| MAP-06 | Booking lintas layanan | Generalisasi | MVP terbatas | §7.4–7.5 Directory / Appointment |
| MAP-07 | QR/token check-in | Pertahankan | Fallback MVP; QR sesuai kesiapan MVP/P1 | §7.5 dan §7.11 Provider/Admin Operations |
| MAP-08 | Pembayaran | Pertahankan bersyarat | MVP terbatas; promo P1 | §7.6 Payment, Invoice, and Refund |
| MAP-09 | Timeline kesehatan | Redesain | Aktivitas/dokumen MVP; domain klinis P1 | §7.7 Records and Documents |
| MAP-10 | Growth chart | Pertahankan khusus | P1 | §4.2 P1 Scope |
| MAP-11 | Kalender dan reminder | Perluas | Appointment MVP; obat/preventif P1 | §7.8 Calendar, Notification, and Messaging |
| MAP-12 | Direktori layanan | Perluas | MVP | §7.4 Directory and Service Discovery |
| MAP-13 | Notification center | Perluas | Transaksional MVP; edukasi P1 | §7.8 Calendar, Notification, and Messaging |
| MAP-14 | Onboarding | Redesain | MVP | §6.1 Onboarding Self-Managed Patient |
| MAP-15 | Vaksin sepanjang usia | Perluas | P1; booking vaksin terpilih dapat masuk MAP-06 MVP | §4.2 P1 Scope dan BRD §10.8 |

## 3. Detail per kapabilitas

### 3.1 MAP-01 — Email/password, phone OTP, OAuth → login multi-metode

**Keputusan dan nilai bisnis:** pertahankan metode yang relevan agar pengguna lama maupun pasien umum mudah masuk, dengan identitas akun yang konsisten. Fokusnya bukan menyediakan seluruh metode sejak hari pertama, tetapi memastikan metode yang dirilis memiliki verifikasi, recovery, dan pengelolaan sesi yang lengkap.

**Scope:** MVP mencakup metode login yang disetujui, verifikasi kontak, recovery, logout, dan daftar sesi aktif. Daftar penyedia OAuth serta metode utama masih keputusan produk. Notifikasi keamanan lanjutan mengikuti prioritas P1 PRD.

**Requirement:**

- `MAP-01-R01`: pengguna dapat mendaftar dan masuk melalui metode yang diaktifkan; pilihan yang belum tersedia tidak ditampilkan sebagai fungsi aktif.
- `MAP-01-R02`: kontak baru harus diverifikasi sebelum menjadi jalur recovery atau dipakai untuk tindakan sensitif.
- `MAP-01-R03`: menghubungkan metode login kedua memerlukan pembuktian kendali akun; kemiripan email/nama tidak cukup untuk menggabungkan akun atau pasien.
- `MAP-01-R04`: pengguna dapat melihat sesi/perangkat aktif dan mencabut sesi terpilih atau seluruh sesi sesuai kebijakan.
- `MAP-01-R05`: recovery memulihkan kendali akun tanpa membuka data pasien sebelum verifikasi selesai.

**Alur utama:** pilih metode → verifikasi credential/kontak → selesaikan pemeriksaan konflik akun bila ada → masuk → lanjut ke profil/onboarding atau tujuan semula. Recovery: pilih jalur terverifikasi → buktikan kendali → perbarui credential → tangani sesi lama → masuk kembali.

**Data dan operasi:** ID akun, metode terhubung, status verifikasi kontak, daftar sesi, waktu aktivitas, dan audit recovery/perubahan credential. Support memiliki alur untuk nomor hilang, kontak berganti, dan dugaan pengambilalihan akun tanpa meminta password atau OTP pengguna.

**Pengecualian:** OTP terlambat/kedaluwarsa, OAuth dibatalkan, nomor daur ulang, metode terhubung ke akun lain, dan sesi dicabut. Produk menyediakan retry/recovery yang jelas; batas percobaan dan masa berlaku perlu disepakati.

**Kriteria penerimaan:** kontak belum terverifikasi gagal dipakai untuk recovery; akun tidak tergabung otomatis; sesi yang dicabut gagal membaca resource terlindungi pada akses berikutnya; login ulang tidak membuat profil pasien duplikat.

**Indikator:** completion login, recovery berhasil, konflik akun, dan laporan account takeover. **Dependensi:** kebijakan metode login dan penanganan konflik identitas.

### 3.2 MAP-02 — PIN lokal 6 digit → PIN, biometrik, dan step-up auth

**Keputusan dan nilai bisnis:** perluas proteksi perangkat untuk pasien dan caregiver yang memakai ponsel bersama atau menyimpan beberapa profil. PIN membuka akses lokal; verifikasi ulang untuk aksi sensitif harus tetap membuktikan actor yang berwenang.

**Scope:** MVP mencakup PIN, biometrik jika perangkat mendukung, fallback, penguncian ulang, dan step-up. Usulan: pertahankan PIN enam digit untuk kontinuitas UX; kebijakan percobaan, timeout, dan reset ditetapkan saat review keamanan.

**Requirement:**

- `MAP-02-R01`: pengguna dapat mengaktifkan PIN dan memilih biometrik; kegagalan biometrik memiliki fallback yang aman.
- `MAP-02-R02`: perubahan identitas penting, pemberian akses luas, ekspor yang tersedia, dan penghapusan akun memerlukan verifikasi ulang sesuai risiko.
- `MAP-02-R03`: keberhasilan unlock lokal tidak menghidupkan kembali sesi atau grant yang telah dicabut.
- `MAP-02-R04`: reset PIN memerlukan autentikasi akun; PIN tidak dapat dibaca oleh support.

**Alur utama:** autentikasi akun → buat/konfirmasi PIN → pilih biometrik → aplikasi terkunci saat kondisi yang ditetapkan terpenuhi → unlock → tindakan sensitif memicu step-up → tindakan diteruskan hanya jika verifikasi dan izin masih valid.

**Data dan operasi:** status proteksi perangkat, konfigurasi unlock, hasil step-up, dan audit tindakan sensitif. Rahasia autentikasi tidak menjadi data profil pasien atau analitik.

**Pengecualian:** biometrik tidak tersedia/berubah, PIN salah berulang, lupa PIN, sesi expired, dan perangkat hilang. Bila step-up tidak dapat diselesaikan, tindakan sensitif tertahan dengan opsi recovery; tidak diturunkan menjadi pemeriksaan yang lebih lemah tanpa kebijakan.

**Kriteria penerimaan:** PIN salah tidak membuka data; fallback bekerja pada perangkat tanpa biometrik; sesi revoked tetap ditolak setelah unlock; membatalkan step-up tidak menjalankan tindakan; reset tercatat.

**Indikator:** unlock berhasil, kegagalan/reset PIN, dan abandonment step-up. **Dependensi:** MAP-01 dan daftar tindakan sensitif yang disepakati.

### 3.3 MAP-03 — Profil orang tua → profil pasien/self, emergency contact, preference

**Keputusan dan nilai bisnis:** perluas profil menjadi identitas penerima layanan untuk semua umur. Akun seseorang dapat bertindak untuk beberapa pasien, tetapi profil dirinya tetap terpisah dari profil yang dibantu.

**Scope:** MVP mencakup profil self, identitas minimum, level verifikasi, edit/koreksi, dan emergency contact sesuai tujuan pengumpulan. Preference bahasa/timezone/aksesibilitas lanjutan mengikuti P1 PRD; preference notifikasi minimum ada pada MAP-11/13.

**Requirement:**

- `MAP-03-R01`: pengguna membuat profil sendiri dengan nama, tanggal lahir, serta atribut administratif/kontak yang dibutuhkan; setiap field wajib memiliki alasan kebutuhan.
- `MAP-03-R02`: NIK tidak wajib pada awal onboarding kecuali layanan atau integrasi terpilih membutuhkannya dengan dasar yang disepakati.
- `MAP-03-R03`: tampilkan level verifikasi; verifikasi kontak tidak disamakan dengan verifikasi identitas atau klinis.
- `MAP-03-R04`: emergency contact memiliki nama, hubungan, dan kontak; penambahannya tidak memberikan akses data atau kewenangan booking.
- `MAP-03-R05`: perubahan field terverifikasi mengikuti alur koreksi; kemungkinan duplikasi masuk review, bukan auto-merge.

**Alur utama:** buat profil minimum → tampilkan status verifikasi → lengkapi kontak/preference bila dibutuhkan → gunakan profil untuk layanan → ajukan koreksi bila data terkunci atau berkonflik.

**Data dan operasi:** identitas pasien, relasi akun pemilik, status pengelolaan, level/sumber verifikasi, emergency contact, preference, dan riwayat koreksi. Operator membutuhkan antrean review duplikasi dan salah identitas.

**Pengecualian:** tanggal lahir tidak valid, kontak sama dipakai keluarga, profil sudah ada, atau nama berbeda dari dokumen. Identitas tidak digabung hanya karena memakai nomor telepon yang sama.

**Kriteria penerimaan:** profil self dapat dibuat tanpa menambah keluarga; emergency contact tidak muncul sebagai caregiver berizin; field terverifikasi tidak berubah diam-diam; pasien tanpa NIK dapat memakai layanan yang tidak mensyaratkannya.

**Indikator:** profil selesai, duplikasi terdeteksi, koreksi terselesaikan. **Dependensi:** kebijakan identitas dan data minimum per layanan.

### 3.4 MAP-04 — Multi-anak → household multi-generasi, invitation, delegation, consent

**Keputusan dan nilai bisnis:** redesain struktur keluarga agar anak, pasangan, orang tua, dan caregiver dapat berkoordinasi tanpa akses otomatis. Lansia yang mandiri tetap self-managed; usia saja tidak menjadi dasar status dependent.

**Scope:** MVP mencakup care circle, dependent sah, undangan dewasa, grant appointment/payment, review/revoke, dan sengketa akses. Klaim dependent menjadi self-managed, multi-caregiver lanjutan, dan expiry yang lebih granular masuk P1. Masa berlaku dasar undangan/grant perlu ditetapkan; P1 tidak menunda kemampuan revoke MVP.

**Requirement:**

- `MAP-04-R01`: bedakan “tambah dependent yang saya kelola” dari “undang pasien dewasa/caregiver”.
- `MAP-04-R02`: dependent memerlukan relasi dan pernyataan/bukti kewenangan sesuai risiko; household bukan bukti kewalian.
- `MAP-04-R03`: pasien dewasa menerima undangan dan memilih scope; penerimaan membership dan pemberian grant harus dapat dibedakan.
- `MAP-04-R04`: scope klinis luas tidak dipilih otomatis; appointment dan payment juga hanya aktif setelah pemberian izin.
- `MAP-04-R05`: pemilik profil/wali berwenang dapat melihat, mengurangi, atau mencabut grant; actor dan pasien dicatat terpisah.
- `MAP-04-R06`: sengketa dapat membekukan grant tanpa menghapus profil, transaksi, atau bukti audit.

**Alur utama:** buat care circle → tambah dependent atau kirim undangan → verifikasi relasi/recipient → pilih scope → aktifkan grant → tampilkan siapa dapat melakukan apa → review/revoke bila diperlukan.

**Data dan operasi:** membership, relasi pengelolaan, dasar kewenangan, recipient undangan, status/masa berlaku, scope grant, consent yang relevan, dan audit. Support menangani salah recipient, sengketa kewalian, dan pencabutan dengan jalur eskalasi yang jelas.

**Pengecualian:** invite ditolak/expired, recipient tidak cocok, grant dicabut saat booking, perubahan wali, atau konflik identitas. Keluar household tidak menghapus riwayat pasien atau kewajiban finansial historis.

**Kriteria penerimaan:** anggota baru tidak dapat membaca data sebelum grant aktif; caregiver booking-only tidak dapat membuka dokumen; revoke menghentikan akses berikutnya termasuk deep link; grant suspended tidak bisa dipakai untuk booking; audit tetap tersedia.

**Indikator:** invite accepted, grant revoked, access dispute, dan akses tidak sah. **Dependensi:** MAP-01/03, kebijakan wali/dependent, dan matriks akses.

### 3.5 MAP-05 — Pilih anak saat booking → pilih pasien yang dilayani

**Keputusan dan nilai bisnis:** pertahankan pola pemilihan subjek layanan, tetapi daftar berasal dari kewenangan actor dan kelayakan layanan. Ini mengurangi salah pasien ketika seseorang mengelola lebih dari satu anggota keluarga.

**Scope:** MVP patient switcher dalam booking dan review akhir; bukan pemilih seluruh anggota household tanpa filter izin.

**Requirement:**

- `MAP-05-R01`: tampilkan hanya profil dengan izin appointment aktif; kelayakan layanan ditunjukkan terpisah dari izin akses.
- `MAP-05-R02`: nama/konteks pasien terlihat sepanjang booking; actor dan payer ditampilkan terpisah pada review.
- `MAP-05-R03`: bila pasien diubah, evaluasi ulang syarat umur, layanan, formulir, harga, slot, dan jawaban spesifik pasien.
- `MAP-05-R04`: validasi ulang izin pada konfirmasi dan tindakan reschedule/cancel; pilihan yang sebelumnya valid tidak cukup.

**Alur utama:** pilih pasien → cari layanan yang sesuai → isi kebutuhan pasien → review identitas → konfirmasi. Saat mengganti pasien, jelaskan data yang harus diisi ulang; jangan menyalin jawaban klinis antarprofil.

**Data dan operasi:** patient ID, actor ID, referensi grant/relasi, payer bila ada, serta konteks eligibility. Operator booking melihat pasien yang dilayani dan actor administratif sesuai kebutuhan.

**Pengecualian:** izin dicabut setelah memilih slot, pasien serupa namanya, dependent belum diverifikasi, atau pasien tidak memenuhi kriteria layanan. Beri alasan dan opsi yang dapat dilakukan tanpa membuka profil tidak berizin.

**Kriteria penerimaan:** profil payment-only tidak dapat dipakai untuk membuat appointment; mengganti pasien membersihkan jawaban spesifik; konfirmasi gagal bila grant telah dicabut; ringkasan tidak menukar actor menjadi pasien.

**Indikator:** koreksi salah pasien dan abandonment setelah pemilihan profil. **Dependensi:** MAP-03/04/06.

### 3.6 MAP-06 — Booking imunisasi → booking lintas katalog layanan

**Keputusan dan nilai bisnis:** generalisasi proses reservasi untuk konsultasi, kontrol, vaksin, lab, dan home care. Jenis layanan yang dirilis ditentukan kesiapan mitra, bukan hanya tersedianya layar booking.

**Scope:** MVP terbatas pada layanan pilot yang memiliki katalog, kapasitas, harga, formulir, cancellation policy, dan penanggung jawab operasi. Telekonsultasi, lab, dan home care tidak otomatis termasuk MVP. Home care memerlukan validasi wilayah/alamat dan operasi kunjungan; lab mungkin memerlukan order/rujukan dan persiapan khusus.

**Requirement:**

- `MAP-06-R01`: katalog mendefinisikan jenis layanan, provider/lokasi/channel, durasi, kapasitas, eligibility, persiapan, harga, dan kebijakan.
- `MAP-06-R02`: formulir pra-kunjungan hanya meminta informasi yang relevan untuk layanan dan pasien terpilih.
- `MAP-06-R03`: slot diperiksa ulang dan ditahan dengan expiry; dua pengguna tidak memperoleh konfirmasi untuk kapasitas yang sama di luar aturan yang disetujui.
- `MAP-06-R04`: review menampilkan pasien, actor, payer, harga/estimasi, persiapan, serta dampak cancel/reschedule sebelum persetujuan.
- `MAP-06-R05`: reschedule/cancel mengikuti policy, memperbarui reminder, dan memicu penanganan finansial yang sesuai.
- `MAP-06-R06`: pembatalan provider menyediakan langkah berikutnya; kegagalan pembayaran/slot tidak menghasilkan booking confirmed palsu.

**Alur utama:** pilih pasien → pilih layanan/provider/channel → pilih slot → isi formulir → review → tahan slot → bayar bila diperlukan → konfirmasi → reminder → check-in → selesai/batal/no-show menurut operasi provider.

**Data dan operasi:** appointment, pasien/actor, snapshot layanan/harga/policy, slot, formulir, lokasi/channel, dan riwayat status. Admin harus dapat mengelola katalog, blackout, kapasitas, worklist, serta pembatalan provider.

**Pengecualian:** harga berubah, slot habis, hold expired, pembayaran terlambat, provider tidak tersedia, dan koneksi putus. Pembayaran setelah hold expired masuk penanganan exception/refund atau penawaran slot baru; jangan konfirmasi slot yang sudah dialokasikan.

**Kriteria penerimaan:** retry tidak menggandakan booking; harga berubah memerlukan review ulang; layanan nonaktif tidak dapat dipesan; cancellation memperbarui status/reminder; status completed berasal dari alur operasi yang sah, bukan pembayaran atau QR saja.

**Indikator:** search-to-confirmed, confirmed-to-attended, no-show, provider cancellation, konflik slot. **Dependensi:** MAP-05/08/11/12 dan kesiapan provider ops.

### 3.7 MAP-07 — QR check-in → QR/token dengan expiry dan fallback manual

**Keputusan dan nilai bisnis:** pertahankan identifikasi appointment saat kedatangan untuk mempercepat administrasi. Check-in membuktikan kedatangan sesuai prosedur provider, bukan bukti pelayanan selesai atau pembayaran lunas.

**Scope:** MVP harus menyediakan check-in manual dan worklist. QR dapat masuk MVP bila mitra siap, atau P1 bila perangkat/proses scan belum siap. Provider menentukan window check-in dan mekanisme verifikasi identitas; nilainya belum final.

**Requirement:**

- `MAP-07-R01`: token terkait appointment dan masa berlaku, tidak memuat diagnosis atau isi catatan medis.
- `MAP-07-R02`: validasi status, lokasi/provider, waktu, dan penggunaan token sebelum check-in diterima.
- `MAP-07-R03`: fallback manual memverifikasi appointment/identitas sesuai prosedur dan mencatat petugas serta alasan.
- `MAP-07-R04`: token lama invalid ketika appointment dibatalkan/dijadwal ulang; scan ulang tidak menggandakan check-in.

**Alur utama:** buka appointment valid → tampilkan token → petugas scan → validasi → konfirmasi kedatangan → status checked-in. Fallback: petugas cari referensi appointment → verifikasi minimum → check-in manual → audit.

**Data dan operasi:** referensi token, expiry, appointment, lokasi, waktu check-in, petugas, metode, dan hasil. Operasi memerlukan scanner atau worklist manual yang benar-benar dapat dipakai.

**Pengecualian:** screenshot token lama, salah cabang, datang terlalu awal/terlambat, scan berulang, dan jaringan putus. QR tersimpan offline tidak otomatis valid; petugas mengikuti fallback yang disepakati dan tidak menganggap salinan sebagai bukti status terkini.

**Kriteria penerimaan:** token expired/cancelled ditolak; replay tidak membuat check-in kedua; fallback tercatat; check-in tidak menandai payment paid atau appointment completed.

**Indikator:** check-in completion, waktu administrasi, fallback rate, invalid scan. **Dependensi:** MAP-06 dan provider ops.

### 3.8 MAP-08 — Midtrans/Stripe → invoice, pembayaran, refund, reconciliation

**Keputusan dan nilai bisnis:** pertahankan bersyarat. Gateway digunakan setelah merchant, metode, biaya, settlement, refund, dan penanggung jawab sengketa ditentukan. Mempertahankan nama gateway tidak mewajibkan dua gateway aktif pada MVP.

**Scope:** MVP terbatas mencakup invoice, metode terpilih, pembayaran terverifikasi, receipt, refund sesuai policy, dan rekonsiliasi. Promo/paket masuk P1 sesuai BRD; refund tidak boleh ditunda hanya karena promo ditunda.

**Requirement:**

- `MAP-08-R01`: invoice memisahkan pasien, actor, payer, merchant, item layanan, fee/pajak bila berlaku, dan total final.
- `MAP-08-R02`: paid ditetapkan dari verifikasi server; redirect/screenshot pengguna bukan bukti final.
- `MAP-08-R03`: retry/callback berulang tidak menggandakan charge atau order; hasil yang belum pasti ditampilkan sebagai pending/exception.
- `MAP-08-R04`: payer dapat membayar tanpa akses klinis; invoice dan receipt menampilkan data minimum yang diperlukan.
- `MAP-08-R05`: refund memiliki jumlah, alasan, policy, approval, status, estimasi, serta pemilik penanganan kegagalan.
- `MAP-08-R06`: finance dapat mencocokkan invoice, transaksi gateway, settlement, refund, dan exception; nominal mismatch tidak disembunyikan.

**Alur utama:** review invoice → pilih payer/metode → proses gateway → tunggu verifikasi → paid/failed/expired → receipt → konfirmasi appointment sesuai aturan. Refund: permintaan → evaluasi policy → persetujuan → proses → hasil/retry exception → pemberitahuan.

**Data dan operasi:** order/invoice, snapshot harga, payer, referensi gateway, status/nominal, settlement, refund, dan audit approval. Finance dan support tidak memperoleh akses dokumen klinis hanya untuk menangani transaksi.

**Pengecualian:** charge berhasil tetapi booking gagal, webhook terlambat, pembayaran ganda, jumlah tidak cocok, refund parsial/gagal, atau chargeback. Usulan: satu antrean exception dengan owner dan status yang dapat dilihat pengguna; SLA ditetapkan finance/ops.

**Kriteria penerimaan:** redirect tidak mengubah paid; callback duplikat tidak membuat transaksi baru; payer-only gagal membuka timeline; refund dapat ditelusuri; payment paid tidak menyembunyikan appointment cancelled/expired.

**Indikator:** payment completion, mismatch, duplicate charge, refund SLA breach, unreconciled transactions. **Dependensi:** MAP-06, merchant of record, kontrak gateway, serta kebijakan cancel/refund.

### 3.9 MAP-09 — Buku KIA/Sehat → timeline longitudinal dan ringkasan domain

**Keputusan dan nilai bisnis:** redesain tampilan yang berorientasi ibu/anak menjadi riwayat per pasien lintas usia. Buku KIA dapat menjadi dokumen/domain relevan, tetapi bukan struktur default seluruh pasien.

**Scope:** MVP menampilkan aktivitas layanan, dokumen yang ditambahkan pengguna, tanggal kejadian, sumber, dan status. P1 menambah ringkasan provider, alergi, obat, hasil lab, pengukuran, kondisi, dan vaksin bertahap; ini bukan janji RME penuh.

**Requirement:**

- `MAP-09-R01`: timeline terisolasi per pasien dengan filter tipe dan tanggal.
- `MAP-09-R02`: setiap item menampilkan tanggal kejadian terpisah dari waktu upload, tipe, sumber, dan status verifikasi.
- `MAP-09-R03`: pengguna dapat menambah dokumen/catatan yang dilabeli user-added; asal file berlogo faskes tidak otomatis menjadikannya provider-verified.
- `MAP-09-R04`: record terbitan provider tidak dapat diedit langsung oleh pasien; tersedia permintaan koreksi.
- `MAP-09-R05`: laporan salah pasien dapat mengarantina/membatasi item dari tampilan sambil menjaga bukti untuk investigasi berwenang.
- `MAP-09-R06`: ringkasan domain hanya mencerminkan sumber yang tersedia; kosong/unknown tidak ditampilkan sebagai “normal” atau “tidak memiliki kondisi”.

**Alur utama:** pilih pasien → buka timeline → filter → lihat detail/sumber → tambah dokumen atau laporkan kesalahan. Pada P1, sumber provider menerbitkan record melalui peran berwenang dan alur koreksi yang disepakati.

**Data dan operasi:** patient ID, event date, upload time, tipe, sumber/penerbit, verifikasi, file, versi/koreksi, izin, dan provenance. Operator memiliki antrean salah pasien/koreksi tanpa mengedit sejarah klinis sembarangan.

**Pengecualian:** file gagal upload, duplikat, tanggal tidak diketahui, sumber konflik, grant dicabut, dan dokumen salah pasien. Catatan yang saling berbeda tidak disatukan menjadi kesimpulan klinis otomatis.

**Kriteria penerimaan:** ganti pasien tidak menampilkan cache profil sebelumnya; upload berlabel user-added; tanggal kejadian tetap benar; caregiver tanpa documents scope ditolak; item quarantined tidak dibuka melalui deep link lama.

**Indikator:** dokumen berhasil ditambahkan/ditemukan, source-label coverage, wrong-patient incident, correction resolution. **Dependensi:** MAP-03/04 dan kebijakan sumber, koreksi, file, serta retensi.

### 3.10 MAP-10 — WHO growth chart → modul pediatrik khusus

**Keputusan dan nilai bisnis:** pertahankan khusus agar pengguna pediatrik tetap mendapat manfaat tanpa membuat pertumbuhan anak sebagai dashboard universal. Detail standar dan interpretasi memerlukan reviewer klinis; dokumen ini tidak menetapkan kurva atau rekomendasi medis.

**Scope:** P1; pengukuran pediatrik, riwayat, plot tervalidasi, dan sumber. Penentuan metrik, kelompok umur, standar/versi, kebutuhan koreksi usia, serta copy interpretasi masih terbuka.

**Requirement:**

- `MAP-10-R01`: modul hanya ditawarkan untuk konteks pasien yang sesuai berdasarkan aturan yang divalidasi.
- `MAP-10-R02`: simpan tanggal, nilai, unit, jenis pengukuran, sumber, serta atribut yang diperlukan standar terpilih.
- `MAP-10-R03`: nilai/unit tidak valid atau di luar rentang dukungan tidak diplot diam-diam; pengguna mendapat permintaan koreksi/review.
- `MAP-10-R04`: tampilkan standar/versi dan bedakan pengukuran mandiri dari provider; grafik tidak menghasilkan diagnosis atau perubahan terapi otomatis.

**Alur utama:** pilih pasien → buka pediatrik → tambah/lihat pengukuran → validasi → tampilkan grafik dan riwayat → koreksi atau konsultasikan melalui layanan yang tersedia bila diperlukan.

**Data dan operasi:** pengukuran bertanggal, sumber, unit, versi standar, dan koreksi. Reviewer klinis menyetujui aturan kalkulasi, rentang dukungan, serta salinan penjelasan sebelum rilis.

**Pengecualian:** DOB tidak pasti, unit tertukar, titik duplikat, input tidak masuk akal, dan pasien di luar rentang standar. Sistem menjelaskan keterbatasan data dan tidak memaksakan hasil.

**Kriteria penerimaan:** dashboard dewasa tidak menampilkan growth chart default; fixture yang disetujui reviewer menghasilkan plot konsisten; input tidak didukung ditolak/ditandai; semua titik memiliki sumber.

**Indikator:** completeness pengukuran, invalid input, dan koreksi. **Dependensi:** MAP-03/09 serta validasi klinis standar.

### 3.11 MAP-11 — Kalender offline → appointment, obat, kontrol, vaksin, pemeriksaan berkala

**Keputusan dan nilai bisnis:** perluas kalender agar pasien/caregiver dapat mengoordinasikan jadwal. Cakupan kalender tumbuh mengikuti fitur sumbernya, bukan membuat seluruh regimen obat atau program preventif masuk MVP.

**Scope:** MVP appointment dan reminder terkait, filter pasien berizin, serta salinan jadwal terakhir untuk akses offline yang diizinkan. P1 menambah obat, preventive care, vaksin, dan kontrol dari sumber tervalidasi. Kontrol yang sudah berupa appointment dapat tampil pada MVP.

**Requirement:**

- `MAP-11-R01`: kalender menampilkan pasien, tipe, tanggal/waktu/timezone, lokasi/channel, dan status yang relevan.
- `MAP-11-R02`: reschedule/cancel mengganti atau membatalkan reminder lama; retry sinkronisasi tidak menggandakan event.
- `MAP-11-R03`: tampilan offline memiliki penanda waktu sinkronisasi; perubahan reservasi memerlukan verifikasi online.
- `MAP-11-R04`: salinan lokal dibatasi berdasarkan izin; saat pencabutan diketahui, data/reminder terkait dibersihkan atau disembunyikan. Akses offline setelah revoke menjadi risiko yang harus ditangani dengan kebijakan cache/expiry, bukan dijanjikan dapat dicegah seketika tanpa koneksi.
- `MAP-11-R05`: pengguna mengatur kanal/quiet hours dan mendapat penjelasan jika izin notifikasi perangkat nonaktif; reminder bukan jaminan kehadiran atau kepatuhan obat.

**Alur utama:** appointment confirmed → event/reminder terbentuk → pengguna melihat kalender → jadwal berubah → sinkronisasi memperbarui event/reminder. P1: regimen/jadwal tervalidasi → reminder → catatan respons tanpa menyimpulkan keberhasilan terapi.

**Data dan operasi:** sumber event, versi jadwal, pasien, izin, timezone, konfigurasi reminder, status sync, dan waktu salinan. Ops dapat menelusuri reminder yang gagal atau stale.

**Pengecualian:** offline panjang, timezone berubah, push/local notification ganda, izin perangkat ditolak, grant expired, dan appointment berubah dari provider. Detail sensitif tidak muncul di lock screen secara default.

**Kriteria penerimaan:** cancellation tidak menyisakan reminder aktif setelah update diterima; offline ditandai; event tidak lintas profil tanpa izin; perubahan timezone tidak mengubah waktu layanan sebenarnya; notifikasi nonaktif tidak membuat layar mengklaim reminder pasti terkirim.

**Indikator:** stale reminder, duplicate event, delivery failure, dan reminder-to-attendance. **Dependensi:** MAP-04/06/13 serta kebijakan cache offline.

### 3.12 MAP-12 — Direktori faskes/nakes → discovery berdasarkan kebutuhan layanan

**Keputusan dan nilai bisnis:** perluas pencarian dari daftar fasilitas imunisasi menjadi akses layanan yang membantu pengguna menilai kecocokan, lokasi, jadwal, channel, dan biaya.

**Scope:** MVP pencarian keyword/lokasi, filter layanan/jadwal/channel/harga, dan detail provider. Freshness timestamp lanjutan mengikuti P1 PRD; validitas slot/harga tetap diperiksa sebelum konfirmasi MVP. Guest browsing masih keputusan produk.

**Requirement:**

- `MAP-12-R01`: bedakan fasilitas, tenaga kesehatan, dan item layanan; hubungan antarobjek dapat ditelusuri pengguna.
- `MAP-12-R02`: hasil menampilkan informasi untuk membandingkan layanan, bukan hanya nama dan foto.
- `MAP-12-R03`: harga pasti, mulai dari, estimasi, dan biaya belum tersedia diberi label berbeda.
- `MAP-12-R04`: label verified menjelaskan aspek yang diverifikasi; klaim pemasaran bukan credential klinis.
- `MAP-12-R05`: lokasi dapat diisi manual bila izin GPS ditolak; hasil kosong memiliki opsi ubah filter/lokasi.

**Alur utama:** pilih kebutuhan/lokasi → filter → bandingkan hasil → detail layanan/provider → pilih pasien/booking → validasi ulang harga dan slot.

**Data dan operasi:** fasilitas/provider, kategori layanan, alamat/wilayah, channel, jadwal, harga, kontak, persiapan, policy, verifikasi, dan status aktif. Admin bertanggung jawab memperbarui supply, bukan membiarkan katalog tak tersedia tetap bookable.

**Pengecualian:** hasil kosong, provider tidak aktif, harga belum pasti, jadwal kedaluwarsa, dan layanan tidak cocok dengan pasien. Pencarian tidak memberi diagnosis atau menjanjikan hasil klinis.

**Kriteria penerimaan:** pengguna tanpa GPS dapat mencari; layanan nonaktif tidak dapat dikonfirmasi; estimasi tidak ditampilkan sebagai harga final; filter channel/harga bekerja; detail memiliki next action yang sesuai kesiapan layanan.

**Indikator:** search-to-detail, detail-to-booking, zero-result rate, invalid catalog report. **Dependensi:** katalog dan provider onboarding/verification pada ops.

### 3.13 MAP-13 — Pesan pengumuman → notification center transaksional dan edukasi

**Keputusan dan nilai bisnis:** perluas pesan menjadi pusat status dan tindak lanjut. Pisahkan komunikasi layanan dari marketing agar pengguna memahami alasan pesan dan dapat mengatur preferensinya.

**Scope:** MVP pesan appointment/payment/refund, read/unread, deep link aman, preference, dan pemisahan consent marketing. Edukasi tersegmentasi/campaign serta alert keamanan lanjutan masuk P1 sesuai PRD.

**Requirement:**

- `MAP-13-R01`: setiap pesan memiliki kategori, konteks objek, waktu, status baca, dan tindakan yang masih valid.
- `MAP-13-R02`: push dan lock screen menggunakan informasi minimum; detail dibuka setelah autentikasi dan pemeriksaan grant.
- `MAP-13-R03`: menolak marketing tidak menghalangi booking atau akses notification center transaksional.
- `MAP-13-R04`: pesan lama tidak menjadi jalur akses setelah revoke; CTA appointment cancelled mengarah ke status terbaru.
- `MAP-13-R05`: edukasi P1 memiliki target, sumber, reviewer, versi, dan masa berlaku; segmentasi berdasarkan data sensitif memerlukan tujuan/izin yang disepakati.

**Alur utama:** perubahan status → buat pesan → kirim sesuai kanal/policy → pengguna membuka pusat notifikasi → autentikasi/otorisasi → buka objek terkini → tandai dibaca. Tidak terkirim via push tidak berarti item di pusat notifikasi hilang.

**Data dan operasi:** recipient, tipe pesan, referensi objek/pasien yang diperlukan, template/versi, delivery, read state, preference, dan consent. Ops memerlukan pengendalian audience serta review materi edukasi.

**Pengecualian:** perangkat tidak aktif, push gagal, pesan duplikat, recipient kehilangan grant, dan campaign dihentikan. Usulan: deduplikasi berdasarkan event dan recipient untuk mengurangi pesan berulang.

**Kriteria penerimaan:** diagnosis/nama obat tidak muncul pada lock screen default; deep link revoked ditolak; unread/read tersimpan; opt-out marketing tidak memblokir transaksi; objek yang berubah dibuka dalam status terbaru.

**Indikator:** delivery/open/action, opt-out, complaint, dan duplicate message. **Dependensi:** MAP-01/04/06/08/11 dan kebijakan komunikasi.

### 3.14 MAP-14 — Onboarding → tujuan, profil sendiri, keluarga kemudian

**Keputusan dan nilai bisnis:** redesain agar pasien mandiri dapat memperoleh manfaat tanpa dipaksa menjadi orang tua atau membuat household. Pilihan tujuan membantu orientasi, bukan diagnosis atau pemberian izin.

**Scope:** MVP login/verifikasi, pemberitahuan/persetujuan yang diperlukan, profil self minimum, keamanan perangkat, dan next action. Menambah keluarga serta melengkapi data nonwajib dapat dilakukan kemudian.

**Requirement:**

- `MAP-14-R01`: gunakan bahasa netral lintas umur; tujuan dapat berupa mencari layanan, mengatur jadwal, atau membantu keluarga.
- `MAP-14-R02`: keluarga bukan syarat akun aktif; alur guardian/caregiver tetap menjelaskan siapa pasien yang dilayani.
- `MAP-14-R03`: pisahkan persetujuan layanan/privacy, marketing, dan grant keluarga; pilihan tujuan tidak mengaktifkan semuanya.
- `MAP-14-R04`: onboarding dapat dilanjutkan setelah terputus tanpa membuat akun/profil duplikat.
- `MAP-14-R05`: permission perangkat dijelaskan saat manfaatnya relevan; penolakan GPS/push tidak menghalangi fungsi inti yang mempunyai alternatif.

**Alur utama:** pilih tujuan opsional → login/verifikasi → pahami pemberitahuan/persetujuan → buat profil self minimum → setup keamanan → home dengan booking/lengkapi profil/tambah keluarga. Recipient undangan kembali ke undangan setelah fondasi akun siap, dengan pemeriksaan izin terpisah.

**Data dan operasi:** progres onboarding, profil terkait, tujuan/preference bila dipilih, versi persetujuan, dan setup keamanan. Analytics memakai langkah funnel tanpa credential atau data klinis.

**Pengecualian:** invite expired, kontak belum terverifikasi, akun sudah ada, profil duplikat, dan permission ditolak. Pengguna harus dapat membedakan langkah wajib dari opsional.

**Kriteria penerimaan:** pasien dewasa dapat selesai tanpa keluarga; resume tidak membuat profil kedua; marketing tidak precondition; undangan tidak membuka data sebelum grant; penolakan GPS memungkinkan lokasi manual.

**Indikator:** onboarding completion, time-to-first-booking, drop-off per langkah, duplicate creation. **Dependensi:** MAP-01/02/03/04 dan copy UX yang tervalidasi.

### 3.15 MAP-15 — Vaksin anak → riwayat vaksin sepanjang usia

**Keputusan dan nilai bisnis:** perluas pencatatan vaksin untuk pasien semua umur, dengan program/rekomendasi yang memiliki sumber dan review. Riwayat vaksin, pengingat jadwal, dan eligibility klinis adalah tiga hal yang berbeda.

**Scope:** P1 mencakup riwayat, dokumen pendukung, sumber/verifikasi, dan program terpilih. Booking layanan vaksin pilot dapat tersedia pada MVP melalui MAP-06 tanpa engine rekomendasi vaksin sepanjang usia.

**Requirement:**

- `MAP-15-R01`: catat vaksin, tanggal, informasi dosis yang diketahui, provider/sumber, dan bukti bila ada; field tambahan tidak boleh memaksa pengguna mengarang data.
- `MAP-15-R02`: bedakan “diberikan”, “direncanakan”, “tidak diketahui”, dan “dibatalkan” sesuai model program; appointment completed sendiri bukan bukti vaksin diberikan.
- `MAP-15-R03`: program/jadwal memiliki sumber, versi, populasi sasaran, tanggal berlaku, dan persetujuan reviewer klinis.
- `MAP-15-R04`: data tidak cukup atau saling konflik memicu review/konfirmasi; sistem tidak memutuskan dosis tambahan otomatis.
- `MAP-15-R05`: perubahan program memperbarui jadwal mendatang secara transparan tanpa mengubah riwayat pemberian atau menciptakan reminder duplikat.

**Alur utama:** pilih pasien → lihat/tambah riwayat → label sumber/status → pilih program yang didukung bila memenuhi kebutuhan informasi → review jadwal → reminder → booking → sumber berwenang mencatat pemberian → timeline diperbarui.

**Data dan operasi:** event vaksin, pasien, sumber/verification, bukti, program/versi, jadwal, status, dan koreksi. Reviewer klinis mengelola program; provider berwenang memvalidasi pemberian. Produk tidak mengasumsikan semua booking vaksin berakhir dengan vaksinasi.

**Pengecualian:** riwayat hilang, dosis tidak diketahui, vaksin berbeda nama, tanggal konflik, pelayanan ditunda, atau program berubah. Hasil ditampilkan sebagai informasi tidak lengkap bila belum dapat dipastikan.

**Kriteria penerimaan:** pasien dewasa dapat memiliki riwayat vaksin; user-added tidak menjadi verified; paid/check-in tidak membuat event administered; jadwal mencantumkan sumber/versi; konflik tidak menghasilkan rekomendasi otomatis.

**Indikator:** source coverage, verified record, reminder duplication, dan program review coverage. **Dependensi:** MAP-03/06/09/11, katalog vaksin, dan review klinis.

## 4. Matriks akses minimum untuk elaborasi backlog

Matriks ini merupakan interpretasi kerja prinsip BRD/PRD; scope final dan verifikasi kewalian harus ditetapkan sebelum fitur terkait dirilis. Kata “berizin” berarti relasi/grant aktif dan sesuai objek tindakan, bukan hanya keanggotaan household.

| Tindakan | Pasien self | Wali sah | Caregiver | Payer-only | Operator |
|---|---|---|---|---|---|
| Ubah profil pasien | Milik sendiri; koreksi field verified | Sesuai kewenangan | Hanya scope profile yang diberikan | Tidak | Proses koreksi berwenang |
| Booking/reschedule/cancel | Milik sendiri | Berizin | Scope appointment | Tidak | Sesuai worklist dan policy |
| Bayar invoice | Invoice sendiri/yang dibagikan secara sah | Invoice yang berizin | Scope payment atau invoice terbatas | Invoice yang dibagikan secara sah | Finance/merchant sesuai tugas |
| Lihat dokumen klinis | Milik sendiri | Sesuai kewenangan | Scope documents/clinical eksplisit | Tidak | Role klinis berwenang; support tidak default |
| Memberi grant | Profil sendiri | Dasar kewalian yang sah | Tidak dapat mendelegasikan ulang secara default | Tidak | Tidak memberi izin atas nama pasien tanpa dasar |
| Check-in administratif | Appointment sendiri | Appointment berizin | Appointment berizin | Tidak | Petugas provider berwenang |
| Terbitkan record provider | Tidak | Tidak | Tidak | Tidak | Role penerbit berwenang |
| Menangani sengketa grant | Ajukan/revoke sesuai hak | Ajukan/revoke sesuai hak | Ajukan | Ajukan masalah transaksi | Support berwenang; tindakan diaudit |

## 5. Data lama dan kontinuitas pengguna

Bagian ini adalah kebutuhan migrasi yang harus diverifikasi terhadap source/data aktual, bukan asumsi bahwa migrasi produksi sudah diperlukan atau dilakukan.

| Data/pola asal | Target bisnis | Aturan kontinuitas |
|---|---|---|
| Akun orang tua | User account | Pertahankan identitas akun; jangan otomatis menganggap seluruh field sebagai profil self terverifikasi |
| Profil anak | Patient profile guardian-managed | Pertahankan ID/riwayat yang dapat ditelusuri; verifikasi dasar relasi dan provenance |
| Relasi parent-child | Care relationship + grant | Jangan menyalin menjadi akses full-record tanpa penilaian kebijakan |
| Booking imunisasi | Appointment layanan vaksin | Pertahankan pasien, actor bila diketahui, provider, harga, waktu, dan status historis |
| Transaksi gateway | Invoice/payment | Pertahankan referensi untuk reconciliation/refund; jangan mengulang charge |
| Buku sehat dan pengukuran | Timeline/domain pediatrik | Simpan sumber/tanggal; unknown tetap unknown, bukan verified |
| Jadwal lokal | Calendar/reminder | Cocokkan dengan status server sebelum menjadwalkan ulang; cegah notifikasi ganda |
| Pengumuman lama | Pesan historis | Jangan menganggap opt-in lama berlaku untuk semua tujuan marketing baru |
| PIN/sesi lama | Proteksi perangkat/sesi baru | Nilai kompatibilitas secara terpisah; jangan menganggap perubahan identitas aplikasi mempertahankan keamanan atau storage otomatis |

### 5.1 Skenario migrasi yang harus dipilih

- **Belum ada pengguna/data produksi:** fokus adaptasi model dan fixture; tidak perlu mengklaim migrasi data pengguna.
- **Ada pengguna/data produksi yang perlu dibawa:** susun inventaris, mapping field/status, dasar pemrosesan, validasi, komunikasi pengguna, rekonsiliasi jumlah/relasi, dan rencana rollback sebelum eksekusi.
- **Aplikasi baru dengan data lama tetap terpisah:** tentukan mekanisme claim/link/import dan bukti kendali; jangan menghubungkan profil hanya karena nama/kontak sama.

**Kriteria validasi bila migrasi dilakukan:** jumlah data dan relasi dapat direkonsiliasi; tidak ada profil tercampur; transaksi tidak diproses ulang; data klinis tidak mendapat verifikasi baru tanpa bukti; audit sumber tetap tersedia; pengguna lama memperoleh instruksi jika perlu login/verifikasi ulang.

## 6. Urutan adaptasi dan paket review

Urutan berikut mengikuti dependensi kapabilitas, bukan mengganti jadwal pada build timeline. Implementasi dapat memecah fitur ke beberapa increment; setiap increment harus memiliki hasil yang bisa diperiksa.

| Paket | Kapabilitas | Hasil yang dapat direview | Syarat lanjut |
|---|---|---|---|
| A — Identitas dan self | MAP-01/02/03/14 | Login → profil self → proteksi perangkat → home | Recovery, duplicate handling, dan pemisahan akun/pasien dapat dibuktikan |
| B — Keluarga berizin | MAP-04/05 | Dependent/invite → grant → eligible patient picker → revoke | Cross-profile access dan penanganan sengketa lolos skenario UAT |
| C — Akses layanan | MAP-12/06 | Katalog pilot → slot → booking → cancel/reschedule | Kesiapan provider, harga/policy, dan kapasitas terkonfirmasi |
| D — Transaksi dan kedatangan | MAP-08/07 | Invoice → verifikasi → reconciliation/refund → manual/QR check-in | Merchant/finance siap; exception dan fallback punya owner |
| E — Koordinasi dan dokumen | MAP-11/13/09 dasar | Kalender → pesan → dokumen → sumber → koreksi | Cache/reminder menghormati izin; wrong-patient containment siap |
| F — Pengelolaan kesehatan P1 | MAP-09 lanjutan/10/15/11 lanjutan | Domain klinis, growth, vaksin, reminder regimen | Sumber dan aturan klinis tervalidasi; fondasi MVP stabil |

Kalender/pesan minimum diperlukan untuk paket C/D; paket E memperdalam integrasinya. Katalog dan kesiapan operasi dapat dikerjakan paralel dengan fondasi identitas, tetapi booking terlindungi tetap bergantung pada pasien dan grant yang benar.

### 6.1 Template backlog per increment

Setiap increment mencatat:

1. ID MAP dan requirement BRD/PRD yang dilayani.
2. Persona, masalah, dan hasil bisnis yang diharapkan.
3. Batas in-scope/out-of-scope serta keputusan yang belum final.
4. Happy path dan state kosong/loading/offline/error/permission denied.
5. Data minimum, actor/pasien/payer, dan izin per tindakan.
6. Dampak operasi: siapa menangani kegagalan, koreksi, atau sengketa.
7. Kriteria penerimaan, skenario UAT, dan event pengukuran tanpa data sensitif.
8. Temuan source audit: komponen dapat digunakan, perlu diubah, atau perlu diganti, beserta alasannya.

## 7. Skenario UAT lintas fitur

| ID | Skenario | Hasil yang diharapkan |
|---|---|---|
| MAP-UAT-01 | Dewasa mandiri onboarding dan booking | Tidak wajib menambah anak/keluarga; pasien self benar sepanjang alur |
| MAP-UAT-02 | Wali booking untuk dua dependent | Slot, jawaban, invoice, dan reminder tidak tertukar antar pasien |
| MAP-UAT-03 | Caregiver appointment-only | Bisa booking; gagal membuka dokumen atau memberikan grant ulang |
| MAP-UAT-04 | Payer terpisah dari pasien dan actor | Bisa bayar invoice terbatas; tidak mendapat akses klinis |
| MAP-UAT-05 | Revoke setelah actor memilih slot | Konfirmasi berikutnya ditolak; tidak ada booking baru dengan izin lama |
| MAP-UAT-06 | Revoke sebelum membuka pesan/deep link | Objek pasien ditolak setelah pemeriksaan izin; audit historis tetap ada |
| MAP-UAT-07 | Dua pengguna memesan kapasitas terakhir | Hanya kapasitas yang sah dikonfirmasi; pengguna lain mendapat alternatif |
| MAP-UAT-08 | Pembayaran masuk setelah hold expired | Tidak mengambil slot milik orang lain; transaksi masuk exception yang ditangani |
| MAP-UAT-09 | Webhook/submit/scan dikirim berulang | Tidak ada charge, booking, atau check-in ganda |
| MAP-UAT-10 | Provider membatalkan appointment paid | Status terpisah jelas; reminder diubah; refund/reschedule mengikuti policy |
| MAP-UAT-11 | Dokumen terunggah ke pasien yang salah | Item dibatasi/quarantined, deep link tertutup, investigasi dan koreksi tercatat |
| MAP-UAT-12 | Kalender dibuka offline lalu ada revoke | Salinan diberi waktu sync; policy cache berlaku; saat revoke diterima data/reminder tidak lagi dapat dipakai |
| MAP-UAT-13 | Push/GPS ditolak pengguna | Lokasi manual dan pusat pesan tetap berfungsi; tidak ada klaim delivery palsu |
| MAP-UAT-14 | Sesi dicabut tetapi PIN lokal benar | Unlock lokal tidak memberikan akses resource terlindungi |
| MAP-UAT-15 | P1: data vaksin/growth tidak lengkap | Unknown dan batas data terlihat; tidak ada diagnosis/dosis otomatis |
| MAP-UAT-16 | Data historis diimpor bila relevan | Provenance/status/relasi terjaga; transaksi dan reminder tidak diulang |

## 8. Keputusan terbuka dan penanggung jawab

| ID | Keputusan | Pemilik review | Diperlukan untuk |
|---|---|---|---|
| MAP-DEC-01 | Metode login utama, OAuth, linking, dan recovery | Product + security/engineering | MAP-01/14 |
| MAP-DEC-02 | PIN enam digit, timeout, retry, dan metode step-up | Product + security/engineering | MAP-02 |
| MAP-DEC-03 | Data identitas minimum per layanan, kebutuhan NIK, review duplikasi | Product + ops/privacy | MAP-03/06 |
| MAP-DEC-04 | Pembuktian wali/dependent, scope default, expiry, sengketa, transisi self-managed | Product + privacy/legal/ops | MAP-04/05 |
| MAP-DEC-05 | Region/provider pilot, jenis layanan/channel, harga, cancellation, kapasitas | Business + provider ops | MAP-06/12 |
| MAP-DEC-06 | Window QR, perangkat scan, verifikasi manual, dan kesiapan MVP | Provider ops + product | MAP-07 |
| MAP-DEC-07 | Gateway, merchant of record, liability, refund/settlement SLA | Business + finance/ops | MAP-08 |
| MAP-DEC-08 | Jenis dokumen MVP, status sumber, file policy, koreksi/retensi | Product + privacy/clinical/ops | MAP-09 |
| MAP-DEC-09 | Standar/versi growth, atribut, rentang dukungan, interpretasi | Clinical reviewer + product | MAP-10 |
| MAP-DEC-10 | Batas offline/cache, isi reminder, kanal, quiet hours | Product + privacy/security/ops | MAP-11/13 |
| MAP-DEC-11 | Guest browsing, freshness, verifikasi direktori | Business + provider ops | MAP-12 |
| MAP-DEC-12 | Program vaksin, sumber/versi, review, penanganan konflik | Clinical reviewer + product/provider | MAP-15 |
| MAP-DEC-13 | Ada/tidaknya pengguna produksi dan strategi kontinuitas/migrasi | Product + engineering/ops/privacy | Semua kapabilitas terkait data lama |

Nilai numerik dan keputusan yang belum tersedia tetap terbuka. Detail dapat didesain dan diuji menggunakan asumsi yang diberi label, tetapi aktivasi layanan nyata memerlukan kesiapan pemilik operasional terkait.

## 9. Definition of ready dan definition of done

### 9.1 Ready untuk adaptasi fitur

- Nilai bisnis, persona, scope fase, serta requirement MAP/PRD jelas.
- Flow dan pengecualian dirancang, termasuk pasien salah, izin dicabut, dan offline bila relevan.
- Parameter bisnis yang menentukan perilaku fitur disetujui atau fitur tersebut masih dibatasi sebagai draft.
- Data, sumber, matriks izin, status, dan penanggung jawab operasi disepakati.
- Audit source membuktikan bagian yang dapat dipakai dan gap terhadap target; tidak hanya mengganti label “anak” menjadi “pasien”.
- Kriteria penerimaan/UAT dan indikator pengukuran disepakati.

### 9.2 Done untuk increment produk

- Alur dan pengecualian dalam scope memenuhi kriteria penerimaan.
- Actor, pasien, dan payer tetap terpisah; akses lintas profil sesuai grant.
- Status transaksi/appointment dan sumber record dapat dijelaskan serta ditelusuri.
- Operasi dapat menangani fallback, koreksi, refund, atau sengketa yang relevan.
- Salinan offline, reminder, dan deep link tidak menjadi jalur akses tanpa kontrol.
- Dokumentasi requirement, temuan source, keputusan, dan backlog diperbarui sesuai hasil akhir.
- Fitur P1 yang belum tersedia tidak ditampilkan seolah sudah aktif pada MVP.

## 10. Referensi dan batas interpretasi

- [BRD e-Patient](../plans/2026-09-30-e-patient-business-requirements.md): bagian 7–11 untuk model, pemetaan, fase, requirement, dan aturan bisnis.
- [PRD e-Patient](2026-10-02-e-patient-prd.md): bagian 4, 6–9, 13–16 untuk scope, flow, requirement, state, UAT, dan keputusan terbuka.
- [Build timeline](../plans/2026-10-04-e-patient-build-timeline.md): rujukan jadwal; paket adaptasi di dokumen ini adalah urutan dependensi.

Persyaratan klinis, legal, finansial, dan keamanan di sini adalah kebutuhan review produk yang diturunkan dari dokumen internal, bukan pernyataan kepatuhan atau rekomendasi klinis. Jika elaborasi ini mengubah keputusan BRD/PRD, perubahan harus disetujui dan dicatat pada sumber terlebih dahulu.
