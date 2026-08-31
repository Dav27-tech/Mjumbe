import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mjumbe/app/router/app_router.dart';
import 'package:mjumbe/app/theme/app_theme.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';
import 'package:mjumbe/injection_container.dart' as di;
import 'package:mjumbe/features/news/domain/usecases/toggle_bookmark.dart';
import 'package:mjumbe/features/news/data/datasources/news_local_data_source.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  late Future<List<ArticleEntity>> _bookmarksFuture;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  void _loadBookmarks() {
    setState(() {
      _bookmarksFuture = di.sl<NewsLocalDataSource>().getBookmarkedArticles();
    });
  }

  Future<void> _removeBookmark(ArticleEntity article) async {
    await di.sl<ToggleBookmark>()(article);
    _loadBookmarks();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Article retiré des signets'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('SIGNETS'),
      ),
      body: FutureBuilder<List<ArticleEntity>>(
        future: _bookmarksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryNeutral));
          }

          final articles = snapshot.data ?? [];

          if (articles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bookmark_outline_rounded, size: 64, color: AppTheme.borderLight),
                  const SizedBox(height: 16),
                  const Text(
                    'Aucun signet enregistré',
                    style: TextStyle(color: AppTheme.primaryNeutral, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Retrouvez ici les articles que vous sauvegardez.',
                    style: TextStyle(color: AppTheme.secondaryNeutral, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return _BookmarkItem(
                article: article,
                onRemove: () => _removeBookmark(article),
              );
            },
          );
        },
      ),
    );
  }
}

class _BookmarkItem extends StatelessWidget {
  final ArticleEntity article;
  final VoidCallback onRemove;

  const _BookmarkItem({required this.article, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(AppRouter.articleDetail, extra: article),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryNeutral),
                  ),
                  const SizedBox(height: 4),
                  if (article.sourceName != null)
                    Text(
                      article.sourceName!.toUpperCase(),
                      style: const TextStyle(color: AppTheme.secondaryNeutral, fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 18, color: AppTheme.secondaryNeutral),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
