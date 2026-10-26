# Sistem Pakar Diagnosis Penyakit Tanaman Cabai (SWI-Prolog)

Proyek tugas mata kuliah **AI with PROLOG** (Logic, Rules and Representation).
Program ini menebak penyakit tanaman cabai dari gejala yang dijawab pengguna (y/n), lalu menampilkan penyakit beserta solusi penanganannya.

- **Kelompok:** [nomor kelompok]
- **Anggota:** Arkan, Azhar, Adit, Rifqi
- **Mata kuliah / kelas:** [nama mata kuliah / kelas]
- **Video tutorial:** [tempel tautan YouTube di sini setelah diunggah]

## Isi repositori

| File | Keterangan |
| --- | --- |
| `penyakit_cabai.pl` | Program utama: fakta, aturan, mesin inferensi, dan antarmuka konsultasi |
| `README.md` | Panduan ini |

## Cakupan sistem

- 16 gejala (`g01` sampai `g16`)
- 5 penyakit: Antraknosa (Patek), Layu Fusarium, Virus Kuning (Gemini Virus), Bercak Daun Cercospora, Busuk Pangkal Batang (Phytophthora)
- Setiap penyakit punya satu aturan IF-THEN: penyakit terdiagnosis jika **semua** gejalanya terpenuhi

| Penyakit | Gejala yang harus ada |
| --- | --- |
| Antraknosa | g01, g02, g03 |
| Layu Fusarium | g04, g05, g06 |
| Virus Kuning | g07, g08, g09, g10 |
| Bercak Daun | g11, g12, g13 |
| Busuk Pangkal Batang | g14, g15, g16 |

## Cara menjalankan

1. Unduh dan instal SWI-Prolog dari <https://www.swi-prolog.org/Download.html>.
2. Unduh file `penyakit_cabai.pl` dari repositori ini.
3. Buka SWI-Prolog, lalu muat file. Cara paling mudah: **File > Consult...**, pilih `penyakit_cabai.pl`. Atau ketik (sesuaikan lokasi folder):

   ```prolog
   ?- [penyakit_cabai].
   ```

4. Jalankan konsultasi:

   ```prolog
   ?- konsultasi.
   ```

5. Jawab setiap pertanyaan dengan `y` (ya) atau `n` (tidak), lalu tekan Enter. Jawaban selain `y` atau `ya` dianggap tidak.

Contoh tampilan (jawaban pengguna ada setelah tanda `:`):

```
=== SISTEM PAKAR PENYAKIT TANAMAN CABAI ===
Jawab dengan y (ya) atau n (tidak).

Apakah tanaman cabai buah muncul bercak cekung berwarna hitam atau cokelat? (y/n): n
Apakah tanaman cabai daun layu dan menguning mulai dari daun bagian bawah? (y/n): y
...
--- HASIL DIAGNOSIS ---
Penyakit : Layu Fusarium
Solusi   : ...
```

Sistem hanya menanyakan gejala yang masih perlu. Kalau satu gejala suatu penyakit dijawab `n`, penyakit itu langsung dilewati.

## Query tanpa tanya-jawab

Untuk pengujian cepat, tanpa ditanya satu per satu:

```prolog
?- diagnosa_dari([g04,g05,g06], P).
P = fusarium ;
false.

?- gejala_penyakit(fusarium).
```

`diagnosa_dari/2` menjawab: "gejala-gejala ini menandakan penyakit apa?". Tekan `;` untuk melihat jawaban berikutnya. `false.` berarti sudah tidak ada jawaban lain.

## Cara kerja singkat

1. **Basis fakta:** `gejala/2` dan `penyakit/2` menyimpan daftar gejala dan penyakit.
2. **Basis aturan:** `aturan/2` memuat gejala yang harus ada untuk tiap penyakit.
3. **Mesin inferensi:** `diagnosis/1` mengecek semua gejala sebuah penyakit. `tanya/1` bertanya ke pengguna dan menyimpan jawabannya (`assertz`), sehingga pertanyaan yang sama tidak diulang.
4. **Hasil:** `konsultasi/0` mengumpulkan semua penyakit yang cocok dengan `findall/3`, lalu `laporan/1` menampilkan penyakit dan solusinya.

## Keterbatasan

- Ini sistem sederhana untuk pembelajaran, bukan pengganti penyuluh pertanian atau ahli.
- Penyakit hanya terdeteksi jika **semua** gejala dalam aturannya dijawab `y`.
- Pengetahuan terbatas pada 5 penyakit dan 16 gejala di atas.

## Lisensi

Dibuat untuk keperluan tugas kuliah. [Tambahkan lisensi jika diperlukan, misalnya MIT.]