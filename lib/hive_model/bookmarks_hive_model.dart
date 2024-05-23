import 'package:hive/hive.dart';

part 'bookmarks_hive_model.g.dart';

@HiveType(typeId: 0)
class BookmarksHiveModel extends HiveObject {
  @HiveField(0)
  var surahNumber;

  @HiveField(1)
  var verseNumber;

  @HiveField(2)
  var surahName;

  @HiveField(3)
  var index;

  @HiveField(4)
  var surahIndex;

  @HiveField(5)
  var verseTranslation;

  @HiveField(6)
  var  translationLanguage;
}
