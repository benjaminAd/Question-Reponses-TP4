import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:questions_reponses/cubit/question_cubit.dart';
import 'package:questions_reponses/Utils/triplet.dart';
import 'package:questions_reponses/data/model/question.dart';
import 'package:questions_reponses/data/provider/image_provider.dart';
import 'package:questions_reponses/views/widget/error_view.dart';
import 'package:questions_reponses/views/screen/home.dart';
import 'package:questions_reponses/views/widget/loading_view.dart';
import 'package:questions_reponses/views/widget/switch_theme.dart';

class QuestionsView extends StatefulWidget {
  List<Question> _questions = [];

  List<Question> get questions => this._questions;

  set questions(List<Question> value) => this._questions = value;

  QuestionsView({Key? key, required List<Question> questions})
      : super(key: key) {
    this._questions = questions;
  }

  @override
  _QuestionsViewState createState() => _QuestionsViewState();
}

class _QuestionsViewState extends State<QuestionsView> {
  List<Question> _questions = [];
  final ImageFirebaseProvider _imageFirabeseProvider =
      new ImageFirebaseProvider();
  @override
  void initState() {
    super.initState();
    this._questions = widget.questions;
  }

  @override
  Widget build(BuildContext context) {
    context.read<QuestionCubit>().questions = this._questions;
    return Scaffold(
      appBar: AppBar(
        title: Text("Questions / Réponses"),
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.chevronLeft),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              child: BlocBuilder<QuestionCubit, Triplet<Question, int, int>>(
                builder: (context, pair) {
                  print(pair.key.path);
                  return FutureBuilder<String>(
                      future: _imageFirabeseProvider
                          .getImageFromPath(pair.key.path),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasError) {
                          print("error ->" + snapshot.error.toString());
                          return ErrorView(error: snapshot.error.toString());
                        }
                        if (snapshot.hasData) {
                          return Image.network(snapshot.data!);
                        }
                        return Loading();
                      });
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child:
                      BlocBuilder<QuestionCubit, Triplet<Question, int, int>>(
                    builder: (context, pair) => Text(
                      pair.key.question,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => {
                          context
                              .read<QuestionCubit>()
                              .checkAnswer(true, context)
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.1)),
                        ),
                        child: Text("Vrai"),
                      ),
                      ElevatedButton(
                        onPressed: () => {
                          context
                              .read<QuestionCubit>()
                              .checkAnswer(false, context)
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.1)),
                        ),
                        child: Text("Faux"),
                      ),
                      BlocBuilder<QuestionCubit, Triplet<Question, int, int>>(
                        builder: (context, triplet) => ElevatedButton(
                          onPressed: () => {
                            (triplet.secondValue >=
                                    context
                                        .read<QuestionCubit>()
                                        .questions
                                        .length)
                                ? context.read<QuestionCubit>().resetAll()
                                : context
                                    .read<QuestionCubit>()
                                    .changeQuestion(false, context)
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.1)),
                          ),
                          child: (triplet.secondValue >=
                                  context
                                      .read<QuestionCubit>()
                                      .questions
                                      .length)
                              ? Icon(Icons.restart_alt)
                              : Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  BlocBuilder<QuestionCubit, Triplet<Question, int, int>>(
                    builder: (context, triplet) => Text(
                        '${triplet.value} / ${context.read<QuestionCubit>().questions.length}'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showPicker(context);
          },
          child: Icon(FontAwesomeIcons.cog),
          backgroundColor: Theme.of(context).colorScheme.primary),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Theme.of(context).colorScheme.primary,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Thème",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    ),
                    ChangeThemeButtonWidget(),
                  ],
                )
              ],
            ),
          );
        });
  }
}
