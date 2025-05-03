class TestModel {
  final List<Soru> sorular;
  final List<Secenek> siklar;
  final List<Cevap> cevap;

  TestModel(this.sorular, this.siklar, this.cevap);

  factory TestModel.fromJson(Map<String, dynamic> json) {
    final List jsonSorular = json['questions'];
    final List jsonSiklar = json['choices'];
    final List jsonCevap = json['answers'];

    return TestModel(
      jsonSorular.map((e) => Soru.fromJson(e)).toList(),
      jsonSiklar.map((e) => Secenek.fromJson(e)).toList(),
      jsonCevap.map((e) => Cevap.fromJson(e)).toList(),
    );
  }
}

class Soru {
  final int id;
  final String question;

  Soru(this.id, this.question);

  Soru.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      question = json['question'];
}

class Secenek {
  final int id;
  final String a;
  final String b;
  final String c;
  final String d;

  Secenek(this.id, this.a, this.b, this.c, this.d);

  Secenek.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      a = json['choice1'],
      b = json['choice2'],
      c = json['choice3'],
      d = json['choice4'];
}

class Cevap {
  final String cevap;
  final int id;

  Cevap(this.cevap, this.id);

  Cevap.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      cevap = json['answer'];
}
