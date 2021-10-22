// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:questions_reponses/Utils/constants.dart';
import 'package:questions_reponses/cubit/dropdown_cubit.dart';
import 'package:questions_reponses/data/provider/questions_firebase_provider.dart';
import 'package:questions_reponses/views/screen/add_question_view.dart';
import 'package:questions_reponses/views/widget/error_view.dart';
import 'package:questions_reponses/views/widget/loading_view.dart';
import 'package:questions_reponses/views/widget/switch_theme.dart';

import 'go_to_game.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final QuestionsFirebaseProvider _questionsFirebaseProvider =
      new QuestionsFirebaseProvider();
  late String dropdownValue;
  late bool gameOn;
  @override
  void initState() {
    dropdownValue = 'Général';
    gameOn = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<DropdownCubit>(
        create: (context) => DropdownCubit(Constants.general_theme),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Bienvenue dans Question / Réponse",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Image(
                    image: AssetImage("images/homeImage.png"),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                FutureBuilder<List<String>>(
                    future: _questionsFirebaseProvider.getAllTheme(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.hasError) {
                        return ErrorView(error: snapshot.error.toString());
                      }
                      if (snapshot.hasData) {
                        List<String> theme = [Constants.general_theme];
                        theme.addAll(snapshot.data!);
                        return BlocBuilder<DropdownCubit, String>(
                            builder: (context, stateDropDown) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: DropdownButton<String>(
                              value: stateDropDown,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              underline: Container(
                                  height: 2,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                              onChanged: (String? newValue) {
                                context
                                    .read<DropdownCubit>()
                                    .changeDropdownValue(newValue!);
                              },
                              isExpanded: true,
                              items: theme
                                  .map((e) => DropdownMenuItem<String>(
                                        value: e,
                                        child: Text(
                                          e,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          );
                        });
                      }
                      return Loading();
                    }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BlocBuilder<DropdownCubit, String>(
                        builder: (context, state) {
                          return ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GoToGame(theme: state)));
                              },
                              child: Text("Jouer"));
                        },
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddQuestion()));
                          },
                          child: Text("Ajouter")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showPicker(context, false);
          },
          child: Icon(FontAwesomeIcons.cog),
          backgroundColor: Theme.of(context).colorScheme.primary),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showPicker(BuildContext context, bool state) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Theme.of(context).colorScheme.primary,
            height: MediaQuery.of(context).size.height*0.1,
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
