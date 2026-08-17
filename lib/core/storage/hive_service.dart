import 'package:hive_flutter/hive_flutter.dart';
import 'package:mjumbe/features/news/data/models/article_model.dart';

class HiveService {
  static const String cachedArticlesBoxName = 'cached_articles_box';
  static const String bookmarkedArticlesBoxName = 'bookmarked_articles_box';

  static Future<void> init() async {
    // Initialisation de Hive pour Flutter (crée le répertoire local de stockage)
    await Hive.initFlutter();

    // Enregistrement de l'adapter généré pour le type ArticleModel
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ArticleModelAdapter());
    }

    // Ouverture des boxes
    await Hive.openBox<ArticleModel>(cachedArticlesBoxName);
    await Hive.openBox<ArticleModel>(bookmarkedArticlesBoxName);
  }

  static Box<ArticleModel> get cachedArticlesBox =>
      Hive.box<ArticleModel>(cachedArticlesBoxName);

  static Box<ArticleModel> get bookmarkedArticlesBox =>
      Hive.box<ArticleModel>(bookmarkedArticlesBoxName);
}