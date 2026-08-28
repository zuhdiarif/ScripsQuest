import 'package:raion_hackjam/data/models/quest_model.dart';
import 'package:uuid/uuid.dart';

class ThesisCurriculum {
  const ThesisCurriculum._();

  static List<QuestModel> generateInitialThesisQuests(String userId) {
    final now = DateTime.now();
    const uuid = Uuid();

    return [
      QuestModel(
        id: uuid.v4(),
        userId: userId,
        type: QuestType.regular,
        title: 'Menentukan Topik & Masalah Penelitian',
        description:
            'Rumuskan latar belakang, rumusan masalah, dan research gap penelitian skripsi secara jelas.',
        feedbackNote: 'Fokus pada kejelasan urgensi masalah.',
        status: QuestStatus.inProgress,
        questOrder: 1,
        xpReward: 15,
        createdAt: now,
      ),
      QuestModel(
        id: uuid.v4(),
        userId: userId,
        type: QuestType.regular,
        title: 'Cari 5 Jurnal Referensi Utama',
        description:
            'Temukan minimal 5 jurnal terindeks (SINTA/Scopus) yang relevan dengan topik penelitianmu.',
        feedbackNote: 'Pilih jurnal terbitan 5 tahun terakhir.',
        status: QuestStatus.inProgress,
        questOrder: 2,
        xpReward: 20,
        createdAt: now,
      ),
      QuestModel(
        id: uuid.v4(),
        userId: userId,
        type: QuestType.regular,
        title: 'Menyusun Bab 1: Pendahuluan',
        description:
            'Tulis latar belakang, rumusan masalah, batasan masalah, tujuan, dan manfaat penelitian.',
        status: QuestStatus.notStarted,
        questOrder: 3,
        xpReward: 25,
        createdAt: now,
      ),
      QuestModel(
        id: uuid.v4(),
        userId: userId,
        type: QuestType.regular,
        title: 'Menyusun Bab 2: Tinjauan Pustaka',
        description:
            'Sintesis teori dasar, metode terkait, dan perbandingan dengan studi-studi terdahulu.',
        status: QuestStatus.notStarted,
        questOrder: 4,
        xpReward: 25,
        createdAt: now,
      ),
      QuestModel(
        id: uuid.v4(),
        userId: userId,
        type: QuestType.regular,
        title: 'Menyusun Bab 3: Metodologi Penelitian',
        description:
            'Rancang arsitektur sistem/alur penelitian, teknik pengumpulan data, dan metrik evaluasi.',
        status: QuestStatus.notStarted,
        questOrder: 5,
        xpReward: 30,
        createdAt: now,
      ),
      QuestModel(
        id: uuid.v4(),
        userId: userId,
        type: QuestType.regular,
        title: 'Bimbingan & Pengajuan Seminar Proposal',
        description:
            'Dapatkan persetujuan dospem dan lengkapi berkas untuk pelaksanaan Seminar Proposal (Sempro).',
        status: QuestStatus.notStarted,
        questOrder: 6,
        xpReward: 20,
        createdAt: now,
      ),
      QuestModel(
        id: uuid.v4(),
        userId: userId,
        type: QuestType.regular,
        title: 'Pengumpulan & Pra-pemrosesan Data',
        description:
            'Kumpulkan dataset primer/sekunder dan lakukan cleaning, transformasi, serta validasi data.',
        status: QuestStatus.notStarted,
        questOrder: 7,
        xpReward: 30,
        createdAt: now,
      ),
      QuestModel(
        id: uuid.v4(),
        userId: userId,
        type: QuestType.regular,
        title: 'Implementasi Metode & Pengembangan Sistem',
        description:
            'Bangun prototype, koding algoritma, dan lakukan pengujian fungsional modul utama.',
        status: QuestStatus.notStarted,
        questOrder: 8,
        xpReward: 35,
        createdAt: now,
      ),
      QuestModel(
        id: uuid.v4(),
        userId: userId,
        type: QuestType.regular,
        title: 'Menyusun Bab 4: Hasil & Pembahasan',
        description:
            'Visualisasikan grafik hasil eksperimen, analisis data temuan, dan bandingkan dengan hipotesis.',
        status: QuestStatus.notStarted,
        questOrder: 9,
        xpReward: 30,
        createdAt: now,
      ),
      QuestModel(
        id: uuid.v4(),
        userId: userId,
        type: QuestType.regular,
        title: 'Menyusun Bab 5: Kesimpulan & Saran',
        description:
            'Rangkum jawaban rumusan masalah dan berikan rekomendasi untuk penelitian lanjutan.',
        status: QuestStatus.notStarted,
        questOrder: 10,
        xpReward: 20,
        createdAt: now,
      ),
      QuestModel(
        id: uuid.v4(),
        userId: userId,
        type: QuestType.regular,
        title: 'Seminar Hasil Penelitian (Semhas)',
        description:
            'Presentasikan temuan skripsi di hadapan dosen penguji dan catat masukan revisi.',
        status: QuestStatus.notStarted,
        questOrder: 11,
        xpReward: 35,
        createdAt: now,
      ),
      QuestModel(
        id: uuid.v4(),
        userId: userId,
        type: QuestType.regular,
        title: 'Penyelesaian Revisi Pasca-Semhas',
        description:
            'Selesaikan poin-poin revisi dari penguji dan mintakan tanda tangan persetujuan naskah.',
        status: QuestStatus.notStarted,
        questOrder: 12,
        xpReward: 25,
        createdAt: now,
      ),
      QuestModel(
        id: uuid.v4(),
        userId: userId,
        type: QuestType.regular,
        title: 'Kelengkapan Berkas & Pendaftaran Sidang',
        description:
            'Cek plagiasi (Turnitin < 20%), bebas tanggungan perpus, dan daftar Sidang Skripsi.',
        status: QuestStatus.notStarted,
        questOrder: 13,
        xpReward: 25,
        createdAt: now,
      ),
      QuestModel(
        id: uuid.v4(),
        userId: userId,
        type: QuestType.regular,
        title: 'Sidang Akhir Skripsi & Yudisium',
        description:
            'Pertahankan naskah skripsi di Sidang Akhir dan raih gelar sarjanamu! 🎓⚔️',
        status: QuestStatus.notStarted,
        questOrder: 14,
        xpReward: 50,
        createdAt: now,
      ),
    ];
  }

  static List<QuestModel> filterTodayQuests(
    List<QuestModel> allQuests, {
    int limit = 4,
  }) {
    final activeQuests = allQuests
        .where((q) => q.status == QuestStatus.inProgress)
        .toList();

    if (activeQuests.isEmpty) {
      return allQuests
          .where((q) => q.status == QuestStatus.notStarted)
          .take(limit)
          .toList();
    }
    return activeQuests.take(limit).toList();
  }

  static double calculateThesisProgress(int completedQuests, int totalQuests) {
    if (totalQuests <= 0) return 0.0;
    return (completedQuests / totalQuests).clamp(0.0, 1.0);
  }
}
