% ==========================================================
% SISTEM PAKAR DIAGNOSIS PENYAKIT TANAMAN CABAI
% AI with PROLOG - Logic, Rules and Representation
% Jalankan di SWI-Prolog:
%   ?- [penyakit_cabai].
%   ?- konsultasi.
% ==========================================================

:- dynamic gejala_ya/1, gejala_tidak/1.

% ----------------------------------------------------------
% 1. BASIS FAKTA: daftar gejala  gejala(Kode, Deskripsi)
% ----------------------------------------------------------
gejala(g01, 'buah muncul bercak cekung berwarna hitam atau cokelat').
gejala(g02, 'bercak pada buah melebar dan berlingkar-lingkar').
gejala(g03, 'buah mengering dan keriput').
gejala(g04, 'daun layu dan menguning mulai dari daun bagian bawah').
gejala(g05, 'pangkal batang berwarna cokelat dan jika dibelah terlihat berkas cokelat').
gejala(g06, 'tanaman layu padahal tanah cukup lembab').
gejala(g07, 'daun menguning terang (kuning cerah)').
gejala(g08, 'daun keriting dan melengkung ke atas').
gejala(g09, 'pertumbuhan tanaman kerdil').
gejala(g10, 'terdapat kutu kebul (serangga putih kecil) di bawah daun').
gejala(g11, 'daun muncul bercak bulat berwarna cokelat').
gejala(g12, 'bagian tengah bercak berwarna abu-abu keputihan').
gejala(g13, 'daun yang berbercak mudah gugur').
gejala(g14, 'pangkal batang busuk, basah, dan berwarna gelap').
gejala(g15, 'tanaman layu mendadak dalam waktu singkat').
gejala(g16, 'lahan sering tergenang atau drainase buruk').

% ----------------------------------------------------------
% 2. BASIS FAKTA: daftar penyakit  penyakit(Kode, Nama)
% ----------------------------------------------------------
penyakit(antraknosa,  'Antraknosa (Patek)').
penyakit(fusarium,    'Layu Fusarium').
penyakit(virus_kuning,'Virus Kuning (Gemini Virus)').
penyakit(bercak_daun, 'Bercak Daun Cercospora').
penyakit(busuk_batang,'Busuk Pangkal Batang (Phytophthora)').

% ----------------------------------------------------------
% 3. BASIS ATURAN
%    aturan(Penyakit, DaftarGejalaYangHarusAda)
%    IF semua gejala terpenuhi THEN penyakit terdiagnosis
% ----------------------------------------------------------
aturan(antraknosa,   [g01, g02, g03]).
aturan(fusarium,     [g04, g05, g06]).
aturan(virus_kuning, [g07, g08, g09, g10]).
aturan(bercak_daun,  [g11, g12, g13]).
aturan(busuk_batang, [g14, g15, g16]).

% ----------------------------------------------------------
% 4. SOLUSI penanganan  solusi(Penyakit, Teks)
% ----------------------------------------------------------
solusi(antraknosa,
  'Buang dan musnahkan buah terinfeksi, semprot fungisida berbahan aktif mankozeb, atur jarak tanam agar tidak lembab.').
solusi(fusarium,
  'Cabut dan musnahkan tanaman sakit, lakukan rotasi tanaman, gunakan agens hayati Trichoderma pada tanah.').
solusi(virus_kuning,
  'Kendalikan kutu kebul dengan insektisida atau perangkap kuning, cabut tanaman terinfeksi, gunakan mulsa perak.').
solusi(bercak_daun,
  'Pangkas daun terinfeksi, semprot fungisida tembaga, hindari penyiraman yang membasahi daun.').
solusi(busuk_batang,
  'Perbaiki drainase, buat bedengan lebih tinggi, aplikasikan fungisida sistemik dan Trichoderma.').

% ----------------------------------------------------------
% 5. MESIN INFERENSI
% ----------------------------------------------------------

% diagnosis(P): P terdiagnosis jika semua gejalanya terpenuhi
diagnosis(P) :-
    aturan(P, DaftarGejala),
    semua_gejala(DaftarGejala).

semua_gejala([]).
semua_gejala([G|Sisa]) :-
    tanya(G),
    semua_gejala(Sisa).

% tanya(G): sukses jika pengguna menjawab ya.
% Jawaban disimpan agar pertanyaan yang sama tidak diulang.
tanya(G) :- gejala_ya(G), !.
tanya(G) :- gejala_tidak(G), !, fail.
tanya(G) :-
    gejala(G, Teks),
    format('Apakah tanaman cabai ~w? (y/n): ', [Teks]),
    read_line_to_string(user_input, Jawab),
    string_lower(Jawab, J),
    (   memberchk(J, ["y", "ya"])
    ->  assertz(gejala_ya(G))
    ;   assertz(gejala_tidak(G)), fail
    ).

% ----------------------------------------------------------
% 6. ANTARMUKA KONSULTASI
% ----------------------------------------------------------
konsultasi :-
    retractall(gejala_ya(_)),
    retractall(gejala_tidak(_)),
    nl,
    writeln('=== SISTEM PAKAR PENYAKIT TANAMAN CABAI ==='),
    writeln('Jawab dengan y (ya) atau n (tidak).'), nl,
    findall(P, diagnosis(P), Hasil),
    laporan(Hasil).

laporan([]) :-
    nl,
    writeln('Penyakit tidak terdeteksi berdasarkan aturan yang ada.'),
    writeln('Silakan konsultasi dengan penyuluh pertanian.').
laporan(Hasil) :-
    Hasil \= [],
    nl,
    writeln('--- HASIL DIAGNOSIS ---'),
    forall(member(P, Hasil), tampilkan(P)).

tampilkan(P) :-
    penyakit(P, Nama),
    solusi(P, Saran),
    format('Penyakit : ~w~n', [Nama]),
    format('Solusi   : ~w~n~n', [Saran]).

% ----------------------------------------------------------
% 7. QUERY TANPA TANYA-JAWAB (untuk demo dan pengujian)
%    ?- diagnosa_dari([g04,g05,g06], P).
% ----------------------------------------------------------
diagnosa_dari(DaftarGejala, P) :-
    aturan(P, Syarat),
    subset(Syarat, DaftarGejala).

% Lihat gejala sebuah penyakit:
%   ?- gejala_penyakit(fusarium).
gejala_penyakit(P) :-
    aturan(P, Gs),
    penyakit(P, Nama),
    format('Gejala ~w:~n', [Nama]),
    forall(member(G, Gs),
           ( gejala(G, T), format('  - ~w~n', [T]) )).
