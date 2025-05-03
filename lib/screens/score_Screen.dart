import 'package:enm_quiz_app/screens/score_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreScreen extends StatefulWidget {
  final int score;
  final int total;

  ScoreScreen({
    super.key,
    required this.score,
    required this.total,
    required String kAdi,
  });

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  String? kAdi;

  @override
  void initState() {
    super.initState();
    loadUsernameAndSaveScore();
  }

  Future<void> loadUsernameAndSaveScore() async {
    final prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('Kullanıcı Adı') ?? 'Bilinmiyor';
    setState(() {
      kAdi = storedName;
    });

    final List<String> scores = prefs.getStringList('scoreList') ?? [];
    final String now = DateTime.now().toString();
    final String scoreEntry =
        'Kullanıcı: $storedName | Skor: ${widget.score} | $now';
    scores.add(scoreEntry);
    await prefs.setStringList('scoreList', scores);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEBEE),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFD32F2F),
        title: const Text(
          "Sonuç",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScoreHistoryPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tebrikler! ${kAdi ?? ''}",
                textAlign: TextAlign.center,
                style: GoogleFonts.ebGaramond(
                  textStyle: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Skorunuz",
                      style: GoogleFonts.ebGaramond(
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${widget.score} / ${widget.total}",
                      style: GoogleFonts.ebGaramond(
                        textStyle: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD32F2F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  backgroundColor: const Color(0xFFD32F2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.home, color: Colors.white),
                label: const Text(
                  "Ana Menüye Dön",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
