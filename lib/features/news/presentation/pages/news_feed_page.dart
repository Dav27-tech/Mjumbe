import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mjumbe/app/router/app_router.dart';
import 'package:mjumbe/app/theme/app_theme.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_bloc.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_event.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_state.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  State<NewsFeedPage> createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _categories = const [
    {'id': 'general', 'label': 'Général'},
    {'id': 'technology', 'label': 'Tech'},
    {'id': 'business', 'label': 'Business'},
    {'id': 'sports', 'label': 'Sports'},
    {'id': 'entertainment', 'label': 'Culture'},
    {'id': 'health', 'label': 'Santé'},
    {'id': 'science', 'label': 'Science'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCategorySelected(String categoryId) {
    _searchController.clear();
    context.read<NewsBloc>().add(FetchTopHeadlinesEvent(category: categoryId));
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      context.read<NewsBloc>().add(SearchNewsEvent(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LUMA NEWS',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync_rounded, size: 22),
            onPressed: () {
              context.read<NewsBloc>().add(
                const FetchTopHeadlinesEvent(forceRefresh: true),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche épurée
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: _onSearchSubmitted,
              decoration: InputDecoration(
                hintText: 'Rechercher une actualité',
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppTheme.secondaryNeutral),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    context.read<NewsBloc>().add(const FetchTopHeadlinesEvent());
                  },
                )
                    : null,
              ),
            ),
          ),

          // Sélecteur de Catégories
          BlocSelector<NewsBloc, NewsState, String>(
            selector: (state) => state is NewsLoaded ? state.activeCategory : 'general',
            builder: (context, activeCategory) {
              return SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = activeCategory == category['id'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        selected: isSelected,
                        showCheckmark: true,
                        checkmarkColor: Colors.white,
                        label: Text(category['label']!),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.secondaryNeutral,
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        selectedColor: AppTheme.primaryNeutral,
                        backgroundColor: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isSelected ? AppTheme.primaryNeutral : AppTheme.borderLight,
                          ),
                        ),
                        onSelected: (_) => _onCategorySelected(category['id']!),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 16.0),

          // Fil d'actualités principal
          Expanded(
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                if (state is NewsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryNeutral),
                  );
                } else if (state is NewsError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_off_rounded, size: 48, color: AppTheme.borderLight),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppTheme.secondaryNeutral, fontSize: 14),
                          ),
                          const SizedBox(height: 24),
                          TextButton.icon(
                            onPressed: () {
                              context.read<NewsBloc>().add(const FetchTopHeadlinesEvent());
                            },
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is NewsLoaded) {
                  if (state.articles.isEmpty) {
                    return const Center(
                      child: Text(
                        'Aucun résultat disponible',
                        style: TextStyle(color: AppTheme.secondaryNeutral),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppTheme.primaryNeutral,
                    onRefresh: () async {
                      context.read<NewsBloc>().add(
                        FetchTopHeadlinesEvent(
                          category: state.activeCategory,
                          forceRefresh: true,
                        ),
                      );
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: state.articles.length,
                      itemBuilder: (context, index) {
                        final article = state.articles[index];
                        return _NewsCard(article: article);
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final ArticleEntity article;

  const _NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(AppRouter.articleDetail, extra: article);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: article.urlToImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    memCacheWidth: 800,
                    memCacheHeight: 450,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: Icon(Icons.image_rounded, color: Colors.grey, size: 32),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.image_not_supported_rounded, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            if (article.sourceName != null)
              Text(
                article.sourceName!.toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.secondaryNeutral,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              article.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppTheme.primaryNeutral,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            if (article.description != null) ...[
              const SizedBox(height: 8),
              Text(
                article.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppTheme.secondaryNeutral,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppTheme.borderLight),
          ],
        ),
      ),
    );
  }
}
