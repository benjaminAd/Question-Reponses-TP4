import 'package:questions_reponses/Utils/constants.dart';
import 'package:questions_reponses/data/model/question.dart';
import 'package:questions_reponses/data/repositories/questions_repositories.dart';

class QuestionsFirebaseProvider {
  final QuestionsRepository _repository = new QuestionsRepository();

  Future<List<Question>> getAllQuestions() async {
    return await _repository.getAllQuestions().then(
        (value) => value.docs.map((e) => Question.fromJson(e.data())).toList());
  }

  Future<List<Question>> getQuestionsFromTheme(String theme) async {
    if (theme == Constants.general_theme) {
      return getAllQuestions();
    }
    return await _repository.getQuestionsFromTheme(theme).then(
        (value) => value.docs.map((e) => Question.fromJson(e.data())).toList());
  }

  Future<List<String>> getAllTheme() async {
    return await _repository.getAllQuestions().then((value) => value.docs
        .map((e) => Question.fromJson(e.data()).theme)
        .toList()
        .toSet()
        .toList());
  }

  Future<void> addQuestion(Question question) async {
    await _repository.addQuestion(question.toJson());
  }
}
