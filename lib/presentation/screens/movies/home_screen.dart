// ignore: unused_import
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/presentation/views/views.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'home-screen';
  final int pageIndex;

  const HomeScreen({super.key, required this.pageIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAnimatingFromTab = false;
  //final viewRoutes = const <Widget>[HomeView(), SizedBox(), FavoritesView()];
  late final PageController _pageController;

  static const List<Widget> viewRoutes = [
    HomeView(),
    SizedBox(),
    FavoritesView(),
  ];
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.pageIndex);
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.pageIndex != widget.pageIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted || !_pageController.hasClients) return;

        final currentPage = _pageController.page?.round();

        if (currentPage == widget.pageIndex) return;

        _isAnimatingFromTab = true;

        await _pageController.animateToPage(
          widget.pageIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );

        if (mounted) {
          _isAnimatingFromTab = false;
        }
      });
    }
  }

  void _onPageChanged(int index) {
    // Evita modificar la ruta mientras la animación cruza otras páginas.
    if (_isAnimatingFromTab) return;

    // Evita navegar dos veces.
    if (index == widget.pageIndex) return;

    context.go('/home/$index');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: widget.pageIndex,
      ),
    );
  }
}
