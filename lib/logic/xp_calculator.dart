import 'package:raion_hackjam/data/models/quest_model.dart';

class XpCalculator {
  const XpCalculator._();

  static int xpForQuest(QuestType type) {
    switch (type) {
      case QuestType.regular:
        return 10;
      case QuestType.revision:
        return 20;
    }
  }

  static int xpForCheckpoint() => 50;
}
