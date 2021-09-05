import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/const/const.dart';
import 'package:sqflite/sqflite.dart';

class Category {
   int ID;
   String name;
   String image;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnMainCategoryID: ID,
      columnCategoryName: name,
      columnCategoryImage: name,
    };
    return map;
  }

  Category();

  Category.fromMap(Map<String, dynamic> map) {
    ID = map[columnMainCategoryID];
    name = map[columnCategoryName];
    image = map[columnCategoryImage];
  }
}

class CategoryProvider {
  Future<Category> getCategoryById(Database db, int id) async {
    var maps = await db.query(tableCategoryName,
        columns: [
          columnMainCategoryID,
          columnCategoryName,
          columnCategoryImage,
        ],
        where: '$columnMainCategoryID=?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Category.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Category>> getCategories(Database db) async {
    var maps = await db.query(tableCategoryName, columns: [
      columnMainCategoryID,
      columnCategoryName,
      columnCategoryImage,
    ]);
    if (maps.length > 0) {
      return maps.map((category) => Category.fromMap(category)).toList();
    }
    return null;
  }
}

class CategoryList extends StateNotifier<List<Category>> {
  CategoryList(List<Category> state) : super(state ?? []);

  void addAll(List<Category> category) {
    state.addAll(category);
  }

  void add(Category category) {
    state = [
      ...state,
      category,
    ];
  }
}
