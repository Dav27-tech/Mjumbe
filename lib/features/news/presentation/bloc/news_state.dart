import 'package:equatable/equatable.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<ArticleEntity> articles;
  final String activeCategory;
  final String? infoMessage;

  const NewsLoaded({
    required this.articles,
    this.activeCategory = 'general',
    this.infoMessage,
  });

  @override
  List<Object?> get props => [articles, activeCategory, infoMessage];
}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);

  @override
  List<Object?> get props => [message];
}