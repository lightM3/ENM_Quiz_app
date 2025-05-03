import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreHistoryPage extends StatefulWidget {
  const ScoreHistoryPage({Key? key}) : super(key: key);

  @override
  State<ScoreHistoryPage> createState() => _ScoreHistoryPageState();
}

class _ScoreHistoryPageState extends State<ScoreHistoryPage> {
  List<String> scores = [];

  @override
  void initState() {
    super.initState();
    loadScores();
  }

  Future<void> loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      scores = prefs.getStringList('scoreList') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Geçmiş Skorlar')),
      body:
          scores.isEmpty
              ? const Center(child: Text('Henüz kayıtlı skor yok.'))
              : ListView.builder(
                itemCount: scores.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(scores[index]));
                },
              ),
    );
  }
}
