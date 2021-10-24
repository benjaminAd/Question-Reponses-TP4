import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questions_reponses/cubit/question_cubit.dart';
import 'package:questions_reponses/data/model/question.dart';
import 'package:questions_reponses/data/provider/questions_firebase_provider.dart';
import 'package:questions_reponses/views/screen/questions_view.dart';
import 'package:questions_reponses/views/widget/error_view.dart';
import 'package:questions_reponses/views/widget/loading_view.dart';

class GoToGame extends StatelessWidget {
  String theme;
  GoToGame({ Key? key, required this.theme }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final QuestionsFirebaseProvider _questionsFirebaseProvider =
      new QuestionsFirebaseProvider();
    return FutureBuilder(
          future: _questionsFirebaseProvider.getQuestionsFromTheme(this.theme),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorView(error: snapshot.error.toString());
            }
            if (snapshot.hasData) {
              return Provider<QuestionCubit>(
                create: (_) => QuestionCubit(),
                child:
                    QuestionsView(questions: snapshot.data! as List<Question>),
              );
            }
            return Loading();
          });
  }
}