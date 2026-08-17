import 'package:hive/hive.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';

part 'article_model.g.dart';

@HiveType(typeId: 0)
class ArticleModel extends ArticleEntity {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String title;

  @HiveField(2)
  @override
  final String? description;

  @HiveField(3)
  @override
  final String? url;

  @HiveField(4)
  @override
  final String? urlToImage;

  @HiveField(5)
  @override
  final String? publishedAt;

  @HiveField(6)
  @override
  final String? content;

  @HiveField(7)
  @override
  final String? sourceName;

  const ArticleModel({
    required this.id,
    required this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.sourceName,
  }) : super(
    id: id,
    title: title,
    description: description,
    url: url,
    urlToImage: urlToImage,
    publishedAt: publishedAt,
    content: content,
    sourceName: sourceName,
  );

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final source = json['source'] as Map<String, dynamic>?;
    final articleUrl = json['url'] as String? ?? '';

    return ArticleModel(
      id: articleUrl.isNotEmpty ? articleUrl : json['publishedAt'] as String? ?? DateTime.now().toIso8601String(),
      title: json['title'] as String? ?? 'Sans titre',
      description: json['description'] as String?,
      url: articleUrl,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String?,
      content: json['content'] as String?,
      sourceName: source != null ? source['name'] as String? : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
      'source': {
        'name': sourceName,
      },
    };
  }

  factory ArticleModel.fromEntity(ArticleEntity entity) {
    return ArticleModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      url: entity.url,
      urlToImage: entity.urlToImage,
      publishedAt: entity.publishedAt,
      content: entity.content,
      sourceName: entity.sourceName,
    );
  }
}