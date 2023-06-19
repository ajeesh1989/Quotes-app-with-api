import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shimmer/shimmer.dart';
import 'package:flutter_share/flutter_share.dart';

import 'about.dart';

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
  late SharedPreferences _preferences;

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

  Future<void> loadFavorites() async {
    final favorites = _preferences.getStringList('favorites');
    if (favorites != null) {
      setState(() {
        _favorites.addAll(favorites);
      });
    }
  }

  Future<void> saveFavorites() async {
    await _preferences.setStringList('favorites', _favorites);
  }

  void copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: '$_quote - $_author'));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quote copied to clipboard')),
    );
  }

  Future<void> shareQuote() async {
    final quote = '$_quote - $_author';
    await FlutterShare.share(
      title: 'Share Quote',
      text: quote,
      chooserTitle: 'Share via',
    );
  }

  void _showTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select your category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTypeListTile('Life', 'life'),
              _buildTypeListTile('Love', 'love'),
              _buildTypeListTile('Friendship', 'friendship'),
              _buildTypeListTile('Success', 'success'),
              _buildTypeListTile('Wisdom', 'wisdom'),
              _buildTypeListTile('Happiness', 'happiness'),
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
    final quote = '$_quote - $_author';
    if (!_favorites.contains(quote)) {
      setState(() {
        _favorites.add(quote);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quote added to favorites')),
      );
      saveFavorites();
    }
  }

  void removeFromFavorites(String quote) {
    setState(() {
      _favorites.remove(quote);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quote removed from favorites')),
    );
    saveFavorites();
  }

  Widget buildFavoritesList() {
    if (_favorites.isEmpty) {
      return const ListTile(
        title: Center(child: Text('No favorite quotes')),
        // subtitle: Text('Add quotes to your favorites'),
      );
    }

    return Card(
      child: ListView.separated(
        itemCount: _favorites.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (BuildContext context, int index) {
          final quote = _favorites[index];
          return Dismissible(
            key: Key(quote),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => removeFromFavorites(quote),
            background: Container(
              color: Colors.teal,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: ListTile(
              title: Text(quote),
              onTap: () => copyToClipboard(context),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((preferences) {
      _preferences = preferences;
      loadFavorites();
    });
    fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    final String quoteType = _selectedType.isNotEmpty
        ? 'Showing $_selectedType Quotes'
        : 'Showing Random Quotes';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quotify',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showTypeDialog,
            icon: const Icon(Icons.format_quote),
          ),
        ],
      ),
      drawer: SizedBox(
        width: 180,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.teal),
                child: Center(
                  child: Text(
                    'Quotify',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              ListTile(
                title: const Text('About'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const AboutApp()),
                  );
                },
              ),
              ListTile(
                title: const Text('Back to app'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 320,
              ),
              Center(
                child: RichText(
                  text: const TextSpan(
                    text: 'Developer ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'aj_labs',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.teal[100]!,
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
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: const Color.fromARGB(255, 232, 243, 242),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        quoteType,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  Card(
                    color: const Color.fromARGB(255, 215, 239, 237),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '"$_quote"',
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "- $_author -",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () => addToFavorites(),
                                icon: Icon(
                                  _favorites.contains('$_quote - $_author')
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      _favorites.contains('$_quote - $_author')
                                          ? Colors.teal
                                          : null,
                                ),
                              ),
                              IconButton(
                                onPressed: () => copyToClipboard(context),
                                icon: const Icon(Icons.content_copy),
                              ),
                              IconButton(
                                onPressed: fetchQuote,
                                icon: const Icon(Icons.arrow_forward),
                              ),
                              IconButton(
                                onPressed: () => shareQuote(),
                                icon: const Icon(Icons.share),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Favorite Quotes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(child: buildFavoritesList()),
                ],
              ),
            ),
    );
  }
}
