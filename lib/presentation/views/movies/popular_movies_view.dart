import 'package:cinemapedia/presentation/screens/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/widgets/movies/movies_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularsView extends ConsumerStatefulWidget {
  const PopularsView({super.key});

  @override
  ConsumerState<PopularsView> createState() => _PopularsViewState();
}

class _PopularsViewState extends ConsumerState<PopularsView>
    with AutomaticKeepAliveClientMixin<PopularsView> {
  int reloadVersion = 0;
  @override
  void initState() {
    super.initState();
    final popularMovies = ref.read(popularMoviesProvider);
    if (popularMovies.isEmpty) {
      ref.read(popularMoviesProvider.notifier).loadNextPage();
    }
  }

  Future<void> reloadPopularMovies() async {
    await ref.read(popularMoviesProvider.notifier).reloadMovies();
    if (!mounted) return;
    setState(() {
      reloadVersion++;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final popularMovies = ref.watch(popularMoviesProvider);

    debugPrint(
      'PopularsView build: '
      '${popularMovies.length} peliculas'
      'version $reloadVersion',
    );

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: reloadPopularMovies,
        child: MovieMasonry(
          key: ValueKey('popular-masonry$reloadVersion'),
          movies: popularMovies,
          loadNextPage: () {
            return ref.read(popularMoviesProvider.notifier).loadNextPage();
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
