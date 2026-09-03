import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mjumbe/app/theme/app_theme.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_bloc.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_event.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailPage extends StatelessWidget {
  final ArticleEntity article;

  const ArticleDetailPage({
    super.key,
    required this.article,
  });

  Future<void> _openOriginalArticle(BuildContext context) async {
    final url = article.url;
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun lien disponible pour cet article.')),
      );
      return;
    }

    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d’ouvrir le lien de l’article.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                icon: const Icon(Icons.open_in_new_rounded, color: AppTheme.primaryNeutral),
                tooltip: 'Ouvrir l’article original',
                onPressed: () => _openOriginalArticle(context),
              ),
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
                width: double.infinity,
                height: 300,
                memCacheWidth: 1200,
                memCacheHeight: 800,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade100,
                  child: const Center(
                    child: Icon(Icons.image_rounded, size: 48, color: Colors.grey),
                  ),
                ),
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
                  const SizedBox(height: 24),
                  if (article.url != null && article.url!.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: () => _openOriginalArticle(context),
                        icon: const Icon(Icons.open_in_new_rounded),
                        label: const Text('Ouvrir l’article original'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryNeutral,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: AppTheme.borderLight),
                          ),
                        ),
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
