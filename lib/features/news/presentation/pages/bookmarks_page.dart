import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mjumbe/app/router/app_router.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_bloc.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_event.dart';
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
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Mes Signets',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<ArticleEntity>>(
        future: _bookmarksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur de chargement des signets: ${snapshot.error}',
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }

          final articles = snapshot.data ?? [];

          if (articles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_outline_rounded,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Aucun article enregistré',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vos articles sauvegardés apparaîtront ici\nmême en mode hors-ligne.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Dismissible(
                key: Key(article.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _removeBookmark(article),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
                ),
                child: _BookmarkCard(
                  article: article,
                  onRemove: () => _removeBookmark(article),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  final ArticleEntity article;
  final VoidCallback onRemove;

  const _BookmarkCard({
    required this.article,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: InkWell(
            onTap: () {
              context.push(AppRouter.articleDetail, extra: article);
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 90,
                        height: 90,
                        child: CachedNetworkImage(
                          imageUrl: article.urlToImage!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.white10,
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.white10,
                            child: const Icon(Icons.broken_image, color: Colors.white38),
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.article_rounded, color: Colors.white38, size: 40),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (article.sourceName != null)
                          Text(
                            article.sourceName!.toUpperCase(),
                            style: TextStyle(
                              color: theme.colorScheme.secondary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          article.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (article.publishedAt != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            article.publishedAt!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_remove_rounded, color: Colors.redAccent),
                    onPressed: onRemove,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}