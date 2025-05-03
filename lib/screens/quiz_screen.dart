import 'dart:convert';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:enm_quiz_app/models/TestDosyası.dart';
import 'package:enm_quiz_app/screens/score_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  TestModel? _veriler;
  int _currentQuestionIndex = 0;
  int _score = 0;
  String? kAdi;

  int _currentDuration = 10;
  final CountDownController _controller = CountDownController();

  @override
  void initState() {
    super.initState();
    _getUsername();
    _loadQuestions();
  }

  //Kullanıcı Adı Çekme
  void _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    kAdi = prefs.getString("Kullanıcı Adı");
    setState(() {});
  }

  //Soruları Getirme
  void _loadQuestions() async {
    final sorular = await rootBundle.loadString('assets/files/questions.json');
    final dataJson = jsonDecode(sorular);
    setState(() {
      _veriler = TestModel.fromJson(dataJson);
      _setQuestionDuration();
      _controller.start();
    });
  }

  void _setQuestionDuration() {
    final soru = _veriler!.sorular[_currentQuestionIndex];
    _currentDuration = 16;
  }

  //Sonraki Soruya Gecme
  void _goToNextQuestion() {
    if (_currentQuestionIndex < (_veriler!.sorular.length - 1)) {
      setState(() {
        _currentQuestionIndex++;
        _setQuestionDuration();
      });
      _controller.restart(duration: _currentDuration);
    } else {
      _finishQuiz();
    }
  }

  //Seçenek Seçimi
  void _selectAnswer(String selectedAnswer) {
    final currentSoru = _veriler!.sorular[_currentQuestionIndex];
    final correctAnswer =
        _veriler!.cevap.firstWhere((c) => c.id == currentSoru.id).cevap;

    if (selectedAnswer == correctAnswer) _score++;

    _goToNextQuestion();
  }

  //Test Bitimi
  void _finishQuiz() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("last_score", _score);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (_) => ScoreScreen(
              score: _score,
              total: _veriler!.sorular.length,
              kAdi: kAdi ?? "Kullanıcı",
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_veriler == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final soru = _veriler!.sorular[_currentQuestionIndex];
    final secenek = _veriler!.siklar.firstWhere((s) => s.id == soru.id);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Soru ${_currentQuestionIndex + 1}/${_veriler!.sorular.length}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red.shade700,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    //Geri Sayım Sayacı
                    CircularCountDownTimer(
                      width: 200,
                      height: 100,
                      duration: _currentDuration,
                      fillColor: Colors.red.shade700,
                      ringColor: Colors.red.shade200,
                      isReverseAnimation: true,
                      controller: _controller,
                      isReverse: true,
                      isTimerTextShown: true,
                      textStyle: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      onComplete: _goToNextQuestion,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      soru.question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              //Seçenek Butonları
              _buildOptionButton(secenek.a),
              _buildOptionButton(secenek.b),
              _buildOptionButton(secenek.c),
              _buildOptionButton(secenek.d),
              const SizedBox(height: 20),
              //Boş Geçme Butonu
              ElevatedButton.icon(
                onPressed: _goToNextQuestion,
                icon: const Icon(Icons.skip_next, color: Colors.white),
                label: const Text(
                  "Soruyu Boş Bırak",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade300,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Seçenek Butonu Tasarımı
  Widget _buildOptionButton(String optionText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () => _selectAnswer(optionText),
        style: ElevatedButton.styleFrom(
          elevation: 4,
          backgroundColor: Colors.white,
          foregroundColor: Colors.red.shade700,
          shadowColor: Colors.red.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.red.shade300),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        child: Text(optionText),
      ),
    );
  }
}
