import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mjumbe/app/theme/app_theme.dart';
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
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.backgroundLight,
            leading: const BackButton(color: AppTheme.primaryNeutral),
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_border_rounded, color: AppTheme.primaryNeutral),
                onPressed: () {
                  context.read<NewsBloc>().add(ToggleBookmarkEvent(article));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Action sur le signet effectuée'),
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
                placeholder: (context, url) => Container(color: Colors.grey.shade100),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade100,
                  child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              )
                  : Container(
                color: Colors.grey.shade100,
                child: const Icon(Icons.newspaper, size: 80, color: Colors.grey),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.sourceName != null)
                    Text(
                      article.sourceName!.toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.secondaryNeutral,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 1.2,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryNeutral,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (article.publishedAt != null)
                    Text(
                      article.publishedAt!,
                      style: const TextStyle(
                        color: AppTheme.secondaryNeutral,
                        fontSize: 13,
                      ),
                    ),
                  const SizedBox(height: 32),
                  const Divider(height: 1, color: AppTheme.borderLight),
                  const SizedBox(height: 32),
                  Text(
                    article.description ?? '',
                    style: const TextStyle(
                      color: AppTheme.primaryNeutral,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    article.content ?? '',
                    style: const TextStyle(
                      color: AppTheme.secondaryNeutral,
                      fontSize: 16,
                      height: 1.7,
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
