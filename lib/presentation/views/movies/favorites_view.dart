import 'package:cinemapedia/presentation/screens/storage/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/movies_masonry.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  ConsumerState<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends ConsumerState<FavoritesView>
    with AutomaticKeepAliveClientMixin<FavoritesView> {
  int reloadVersion = 0;

  @override
  void initState() {
    super.initState();

    final favoriteMovies = ref.read(favoriteMoviesProvider);

    if (favoriteMovies.isEmpty) {
      ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    }
  }

  Future<void> reloadFavoriteMovies() async {
    await ref.read(favoriteMoviesProvider.notifier).reloadMovies();

    if (!mounted) return;

    setState(() {
      reloadVersion++;
    });
  } // Esta llave te faltaba.

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final favoriteMovies = ref.watch(favoriteMoviesProvider);
    final myMovieList = favoriteMovies.values.toList();

    final emptyStateIconColor = Theme.of(context).colorScheme.secondary;

    final emptyStateTextColor = Theme.of(context).colorScheme.tertiary;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppbar(),
      ),
      body: RefreshIndicator(
        onRefresh: reloadFavoriteMovies,
        child: myMovieList.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.75,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_rounded,
                          size: 100,
                          color: emptyStateIconColor,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Aún no tienes favoritos',
                          style: TextStyle(color: emptyStateTextColor),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : MovieMasonry(
                key: ValueKey('favorites-masonry-$reloadVersion'),
                movies: myMovieList,
                loadNextPage: () {
                  return ref
                      .read(favoriteMoviesProvider.notifier)
                      .loadNextPage();
                },
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
