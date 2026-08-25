class AppConstants {
  AppConstants._();

  static const String appName = 'Thesis Quest';

  static const int smallQuestXp = 10;
  static const int mainQuestXp = 25;
  static const int revisionQuestXp = 20;
  static const int checkpointXp = 50;

  static const int maxGuildMembers = 10;
  static const int minPasswordLength = 8;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  static const int guildCodeLength = 8;

  static const List<int> levelThresholds = [
    0,
    100,
    250,
    450,
    700,
    1000,
    1400,
    1900,
    2500,
    3200,
  ];

  static const List<String> thesisStages = [
    'Belum Mulai',
    'Menentukan Topik',
    'Proposal',
    'Seminar Proposal',
    'Literature Review',
    'Pengumpulan Data',
    'Analisis Data',
    'Penulisan',
    'Revisi',
    'Persiapan Sidang',
  ];

  static const List<String> questStatuses = [
    'not_started',
    'in_progress',
    'completed',
  ];

  static const List<String> defaultGoalTemplates = [
    'Menentukan Topik',
    'Mencari Referensi',
    'Menulis Draft',
    'Mengolah Data',
    'Menyelesaikan Revisi',
  ];
}
