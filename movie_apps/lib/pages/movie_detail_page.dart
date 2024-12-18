import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';

class MovieDetailPage extends ConsumerWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieDetailAsync = ref.watch(movieDetailProvider(movie.id));

    return Scaffold(
      body: movieDetailAsync.when(
        data: (movieDetail) => CustomScrollView(
          slivers: [
            // App Bar with Movie Poster
            SliverAppBar(
              expandedHeight: 400,
              pinned: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                    // Gradient overlay
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.black87,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Movie Details
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    // Rating
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: movie.voteAverage / 2,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 24.0,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${movie.voteAverage.toStringAsFixed(1)}/10',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${movie.voteCount} votes)',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Synopsis
                    Text(
                      'Synopsis',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    // Cast
                    if (movieDetail.cast.isNotEmpty) ...[
                      Text(
                        'Cast',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movieDetail.cast.length,
                          itemBuilder: (context, index) {
                            final cast = movieDetail.cast[index];
                            return Container(
                              width: 120,
                              padding: const EdgeInsets.only(right: 16),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: cast.profilePath.isNotEmpty
                                          ? 'https://image.tmdb.org/t/p/w200${cast.profilePath}'
                                          : 'https://via.placeholder.com/100x150',
                                      width: 100,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                            width: 100,
                                            height: 120,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.person),
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: Text(
                                      cast.name,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
