import 'package:flutter/foundation.dart' hide Category;
import 'package:app_management/models/category.dart';
import 'package:app_management/services/database_service.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Category? getCategoryById(int id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    _categories = await DatabaseService.instance.getCategories();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateLimit(int categoryId, int limitMinutes) async {
    await DatabaseService.instance.updateCategoryLimit(categoryId, limitMinutes);
    final index = _categories.indexWhere((c) => c.id == categoryId);
    if (index != -1) {
      _categories[index] = _categories[index].copyWith(
        dailyLimitMinutes: limitMinutes,
      );
      notifyListeners();
    }
  }
}
