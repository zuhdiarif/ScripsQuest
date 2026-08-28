class AppConstants {
  AppConstants._();

  static const String appName = 'ScripsQuest';

  static const String supabaseUrl = 'https://fxthtprqiaatxgtkwpdm.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ4dGh0cHJxaWFhdHhndGt3cGRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODc4NTE2NTAsImV4cCI6MjEwMzQyNzY1MH0.lgQMITTcrMaDoDALytwl8I28j4VakNlXFJ-RaI9J9uU';

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
