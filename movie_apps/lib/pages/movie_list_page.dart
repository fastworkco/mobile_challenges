import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/movie_provider.dart';
import '../providers/auth_provider.dart';
import '../models/movie.dart';
import 'movie_detail_page.dart';

class MovieListPage extends ConsumerWidget {
  const MovieListPage({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsyncValue = ref.watch(movieListProvider);
    final currentListType = ref.watch(movieListTypeProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          authState.username != null 
              ? '${_getGreeting()}, ${authState.username}!'
              : 'Welcome to Movies',
        ),
      ),
      body: Column(
        children: [
          // Filter buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: currentListType == null,
                  onSelected: (_) => ref.read(movieListTypeProvider.notifier).state = null,
                ),
                FilterChip(
                  label: const Text('Now Playing'),
                  selected: currentListType == 'now_playing',
                  onSelected: (_) => ref.read(movieListTypeProvider.notifier).state = 'now_playing',
                ),
                FilterChip(
                  label: const Text('Coming Soon'),
                  selected: currentListType == 'upcoming',
                  onSelected: (_) => ref.read(movieListTypeProvider.notifier).state = 'upcoming',
                ),
              ],
            ),
          ),
          // Movie list
          Expanded(
            child: moviesAsyncValue.when(
              data: (movies) => MovieListView(movies: movies),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}

class MovieListView extends StatelessWidget {
  final List<Movie> movies;

  const MovieListView({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MovieListItem(movie: movie);
      },
    );
  }
}

class MovieListItem extends StatelessWidget {
  final Movie movie;

  const MovieListItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailPage(movie: movie),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Movie Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: 'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Movie Title
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Star Rating
                    RatingBarIndicator(
                      rating: movie.voteAverage / 2, // Convert to 5-star scale
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                    ),
                    Text(
                      '${movie.voteAverage.toStringAsFixed(1)}/10',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
