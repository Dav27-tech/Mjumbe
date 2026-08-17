import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_bloc.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_event.dart';

class ArticleDetailPage extends StatelessWidget {
  final ArticleEntity article;

  const ArticleDetailPage({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_border_rounded),
                onPressed: () {
                  context.read<NewsBloc>().add(ToggleBookmarkEvent(article));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Action sur le signet enregistrée'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: article.urlToImage != null && article.urlToImage!.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: article.urlToImage!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: theme.colorScheme.surface,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: theme.colorScheme.surface,
                  child: const Icon(Icons.broken_image, size: 50),
                ),
              )
                  : Container(
                color: theme.colorScheme.surface,
                child: const Icon(Icons.newspaper, size: 80),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.sourceName != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        article.sourceName!,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    article.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (article.publishedAt != null)
                    Text(
                      article.publishedAt!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 20),
                  Text(
                    article.description ?? 'Aucune description disponible.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article.content ?? '',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}