import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RandomWordsState();
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];

  final _biggerFont = const TextStyle(fontSize: 18.0);

  final _save = new Set<WordPair>();

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          //奇数的item加一个分割线
          if (i.isOdd) return new Divider();
          //获取实际单词的下表
          final index = i ~/ 2;
          if (index >= _suggestions.length)
            _suggestions.addAll(generateWordPairs().take(10));
          return _buildRow(_suggestions[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("this is the first listview demo"),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _onPushSave)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildRow(WordPair suggestion) {
    final alreadySaved = _save.contains(suggestion);

    return new ListTile(
      title: new Text(
        suggestion.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _save.remove(suggestion);
          } else {
            _save.add(suggestion);
          }
        });
      },
    );
  }

  _onPushSave() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final tiles = _save.map((pair) {
        return new ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });

      final divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();
      return new Scaffold(
        appBar: new AppBar(
          title: Text("Saved Suggestions"),
        ),
        body: new ListView(
          children: divided,
        ),
      );
    }));
  }
}
