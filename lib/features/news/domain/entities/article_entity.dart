import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;
  final String? sourceName;

  const ArticleEntity({
    required this.id,
    required this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.sourceName,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    url,
    urlToImage,
    publishedAt,
    content,
    sourceName,
  ];
}