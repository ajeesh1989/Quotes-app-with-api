import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shimmer/shimmer.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: QuoteScreen(),
  ));
}

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({Key? key}) : super(key: key);

  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  String _quote = '';
  String _author = '';
  bool _isLoading = true;
  final List<String> _favorites = [];
  String _selectedType = '';

  Future<void> fetchQuote() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://api.quotable.io/random?tags=$_selectedType'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _quote = data['content'];
        _author = data['author'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _quote = 'Error occurred while fetching the quote';
        _author = '';
        _isLoading = false;
      });
    }
  }

  void copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: '$_quote - $_author'));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quote copied to clipboard')),
    );
  }

  void _showTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Quote Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTypeListTile('Life', 'life'),
              _buildTypeListTile('Love', 'love'),
              _buildTypeListTile('Friendship', 'friendship'),
              _buildTypeListTile('Success', 'success'),
              _buildTypeListTile('Wisdom', 'wisdom'),
              _buildTypeListTile('Happiness', 'happiness'),
              _buildTypeListTile('Courage', 'courage'),
            ],
          ),
        );
      },
    );
  }

  ListTile _buildTypeListTile(String title, String type) {
    return ListTile(
      title: Text(title),
      onTap: () {
        _updateSelectedType(type);
        Navigator.pop(context);
      },
    );
  }

  void _updateSelectedType(String type) {
    setState(() {
      _selectedType = type;
    });
    fetchQuote();
  }

  void addToFavorites() {
    if (!_favorites.contains('$_quote - $_author')) {
      setState(() {
        _favorites.add('$_quote - $_author');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quote added to favorites')),
      );
    }
  }

  void removeFromFavorites(String quote) {
    setState(() {
      _favorites.remove(quote);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quote removed from favorites')),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: [
            const Text(
              'Quote App',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            const SizedBox(width: 8),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showTypeDialog,
            icon: const Icon(Icons.format_quote),
          ),
        ],
      ),
      body: _isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 30,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  Card(
                    color: const Color.fromARGB(255, 225, 242, 241),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 24,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                height: 17,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 48,
                        height: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 48,
                        height: 48,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_selectedType.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      _selectedType.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                Card(
                  color: const Color.fromARGB(255, 225, 242, 241),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Text(
                              '"$_quote"',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '- $_author -',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 17,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: fetchQuote,
                      icon: const Icon(Icons.arrow_forward),
                      color: Colors.teal,
                      iconSize: 28,
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () => copyToClipboard(context),
                      icon: const Icon(Icons.copy),
                      color: Colors.teal,
                      iconSize: 28,
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: addToFavorites,
                      icon: Icon(
                        Icons.favorite_outline,
                        color: _favorites.contains('$_quote - $_author')
                            ? Colors.red
                            : Colors.teal,
                      ),
                      color: Colors.teal,
                      iconSize: 28,
                    ),
                  ],
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote),
            label: 'Quote',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.teal,
        onTap: _onBottomNavigationItemTap,
      ),
    );
  }

  void _onBottomNavigationItemTap(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => FavoriteQuotesScreen(
            favorites: _favorites,
            removeFromFavorites: removeFromFavorites,
          ),
        ),
      );
    }
  }
}

class FavoriteQuotesScreen extends StatefulWidget {
  final List<String> favorites;
  final Function(String) removeFromFavorites;

  const FavoriteQuotesScreen({
    Key? key,
    required this.favorites,
    required this.removeFromFavorites,
  }) : super(key: key);

  @override
  _FavoriteQuotesScreenState createState() => _FavoriteQuotesScreenState();
}

class _FavoriteQuotesScreenState extends State<FavoriteQuotesScreen> {
  late List<String> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = List.from(widget.favorites);
  }

  void _removeFromFavorites(int index) {
    final quote = _favorites[index];
    setState(() {
      _favorites.removeAt(index);
    });
    widget.removeFromFavorites(quote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: const Text(
          'Favorite Quotes',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      body: _favorites.isEmpty
          ? const Center(
              child: Text(
                'No favorite quotes yet.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      _favorites[index],
                      style:
                          const TextStyle(fontFamily: 'Poppins', fontSize: 18),
                    ),
                    trailing: IconButton(
                      onPressed: () => _removeFromFavorites(index),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.teal,
                        size: 30,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
