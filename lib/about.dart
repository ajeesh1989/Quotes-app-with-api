import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text('What is Quatify'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.justify,
                "Quotify is a quote app that allows users to explore and engage with a vast collection of inspiring quotes. With Quotify, users can discover meaningful quotes, copy them for personal use, add them to their favorites, and share them on social media platforms. The app offers a user-friendly interface and a seamless experience for quote enthusiasts.",
                style: TextStyle(fontSize: 15),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  textAlign: TextAlign.justify,
                  "1.Explore Quotes: Quotify provides a diverse range of quotes, including love, life,friendship,success,happiness etc and thought-provoking content. Users can browse through a vast collection of quotes from various categories.",
                  style: TextStyle(fontSize: 15)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.justify,
                "2.Favorites: Quotify allows users to create a personalized collection of favorite quotes. By adding quotes to their favorites, users can easily revisit and reflect on the quotes that resonate with them the most.",
                style: TextStyle(fontSize: 15),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.justify,
                "3.Social Sharing: Users can share quotes directly from the app to their favorite social media platforms, such as Facebook, Twitter, Instagram, or WhatsApp. This feature enables users to spread inspiration and thought-provoking content with their friends and followers.",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.justify,
                "4.Personalization: Quotify allows users to customize their experience by choosing their preferred quote categories or authors. This feature ensures that users receive quotes that align with their interests and preferences.",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.justify,
                "5.Copy Quotes: With a simple tap, users can easily copy their favorite quotes to their device's clipboard. This feature enables users to save quotes for personal use, such as adding them to notes or sharing them via messaging apps.",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
