import 'package:al_quran/hive_model/bookmarks_hive_model.dart';
import 'package:hive/hive.dart';

class Boxes{
  Box<BookmarksHiveModel>getFavourites()=>
      Hive.box<BookmarksHiveModel>('bookmarksStorage');
}