import 'package:flutter/material.dart';
import 'package:themovie/services/ApiService.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MovieListPage(),
    );
  }
}

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  List<dynamic> _moviesList = [];
  List<dynamic> _filteredMovies = [];
  bool _isLoading = true;
  int _currentPage = 1;
  int _totalPages = 1;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMovies(page: _currentPage);
    _searchController.addListener(_filterMovies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Movie List"),
              centerTitle: true,
            ),
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: "Search Movie",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              _isLoading
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                  : Expanded(
                      child: Column(children: [
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 3 / 1,
                          ),
                          itemCount: _filteredMovies.length,
                          itemBuilder: (context, index) {
                            final movie = _filteredMovies[index];
                            return Card(
                              color: Colors.white,
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80.0,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        bottomLeft: Radius.circular(12.0),
                                      ),
                                      color: Colors.blue.shade100,
                                    ),
                                    child: movie['poster_path'] != null
                                        ? ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(12.0),
                                              bottomLeft: Radius.circular(12.0),
                                            ),
                                            child: Image.network(
                                              // ignore: prefer_interpolation_to_compose_strings
                                              "https://image.tmdb.org/t/p/w220_and_h330_face/" +
                                                  movie['poster_path'],
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Icon(
                                            Icons.image,
                                            size: 50,
                                            color: Colors.blue.shade300,
                                          ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie['title'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Colors.blueAccent,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4.0),
                                        if (movie['overview'] != "")
                                          Text(
                                            "Description: ${movie['overview'].toString().length > 150 ? movie['overview'].substring(0, 150) + '...' : movie['overview']}",
                                            style: const TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      if (_totalPages > 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildPageButtons(),
                        ),
                    ]))
            ])));
  }

  Future<void> fetchMovies({int page = 1}) async {
    try {
      final movies = await ApiService.listMovies(page: page);
      setState(() {
        _moviesList = movies["results"];
        _filteredMovies = movies["results"];
        _isLoading = false;
        _totalPages = movies["total_pages"];
        if (_totalPages > 20) _totalPages = 20;
      });
    } catch (e) {
      print("Error fetching movies: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _filterMovies({int page = 1}) async {
    final query = _searchController.text;
    if (query.length > 2) {
      final movies = await ApiService.filterMovies(query, page: page);
      setState(() {
        _filteredMovies = movies["results"];
        _isLoading = false;
        _totalPages = movies['total_pages'];
        if (_totalPages > 20) _totalPages = 20;
      });
    } else {
      setState(() {
        _filteredMovies = _moviesList;
      });
    }
  }

  void _changePage(int newPage) {
    setState(() {
      _currentPage = newPage;
      _isLoading = true;
    });
    final query = _searchController.text;
    if (query.length > 2) {
      _filterMovies(page: _currentPage);
    } else {
      fetchMovies(page: _currentPage);
    }
  }

  Widget _buildPageButton(int page) {
    return GestureDetector(
      onTap: _currentPage != page ? () => _changePage(page) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          page.toString(),
          style: TextStyle(
            color: _currentPage == page ? Colors.deepPurple : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
  List<Widget> _buildPageButtons() {
    const int visibleRange = 3;
    List<Widget> buttons = [];

    if (_totalPages <= 10) {
      for (int i = 1; i <= _totalPages; i++) {
        buttons.add(_buildPageButton(i));
      }
    } else {
      if (_currentPage > 1) {
        buttons.add(_buildPageButton(1));
        if (_currentPage > visibleRange + 2) {
          buttons.add(Text("...", style: TextStyle(color: Colors.deepPurple)));
        }
      }

      int start = (_currentPage - visibleRange).clamp(1, _totalPages);
      int end = (_currentPage + visibleRange).clamp(1, _totalPages);

      for (int i = start; i <= end; i++) {
        buttons.add(_buildPageButton(i));
      }

      if (_currentPage < _totalPages - visibleRange - 1) {
        buttons.add(Text("...", style: TextStyle(color: Colors.deepPurple)));
        buttons.add(_buildPageButton(_totalPages));
      }
    }

    return buttons;
  }
}
