import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  List<String> _favorites = [];
  String _selectedType = '';

  Future<void> fetchQuote() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://api.quotable.io/random?tags=$_selectedType')); // Include selected type in the API request

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
              ListTile(
                title: const Text('Life'),
                onTap: () {
                  _updateSelectedType('life');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Love'),
                onTap: () {
                  _updateSelectedType('love');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Friendship'),
                onTap: () {
                  _updateSelectedType('friendship');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Success'),
                onTap: () {
                  _updateSelectedType('success');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Wisdom'),
                onTap: () {
                  _updateSelectedType('wisdom');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Happiness'),
                onTap: () {
                  _updateSelectedType('happiness');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Courage'),
                onTap: () {
                  _updateSelectedType('courage');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
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
    // Check if the quote is not already in favorites
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
        title: const Text('Quote App'),
        actions: [
          IconButton(
            onPressed: _showTypeDialog,
            icon: const Icon(Icons.format_quote),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _quote,
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  _author,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: fetchQuote,
                      child: const Text('New Quote'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => copyToClipboard(context),
                      child: const Text('Copy'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: addToFavorites,
                      child: const Icon(Icons.favorite),
                      style: ElevatedButton.styleFrom(
                        primary: _favorites.contains('$_quote - $_author')
                            ? Colors.red
                            : null,
                      ),
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
        selectedItemColor: Colors.blue,
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
    _favorites = List.from(widget.favorites); // Create a copy of favorites
  }

  void _removeFromFavorites(int index) {
    final quote = _favorites[index];
    setState(() {
      _favorites.removeAt(index); // Remove the quote at the specified index
    });
    widget.removeFromFavorites(quote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Favorite Quotes'),
      ),
      body: ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(_favorites[index]),
              trailing: IconButton(
                onPressed: () => _removeFromFavorites(index),
                icon: const Icon(Icons.delete),
              ),
            ),
          );
        },
      ),
    );
  }
}
