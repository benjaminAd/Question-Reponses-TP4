class Question {
  late String question;
  late String path;
  late String theme;
  late bool correctAnswer;

  Question(this.question, this.path, this.theme,this.correctAnswer);

  Question.fromJson(Map<String, dynamic> json) {
    this.question = (json['question'] != null) ? json['question'] : "";
    this.path = (json['path'] != null) ? json['path'] : "";
    this.theme = (json['theme']!=null) ? json['theme'] :"";
    this.correctAnswer =
        (json['correctAnswer'] != null) ? json['correctAnswer'] : false;
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'path': path,
      'theme' : theme,
      'correctAnswer': correctAnswer,
    };
  }
}
