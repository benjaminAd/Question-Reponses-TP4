import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:questions_reponses/cubit/image_cubit.dart';
import 'package:questions_reponses/data/model/question.dart';
import 'package:questions_reponses/data/provider/image_provider.dart';
import 'package:questions_reponses/data/provider/questions_firebase_provider.dart';
import 'package:questions_reponses/views/screen/home.dart';
import 'package:questions_reponses/views/widget/floating_action_custom.dart';
import 'package:questions_reponses/views/widget/switch_theme.dart';

class AddQuestion extends StatefulWidget {
  AddQuestion({Key? key}) : super(key: key);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final TextEditingController _themeController = new TextEditingController();
  final TextEditingController _questionController = new TextEditingController();
  bool _isSwitchOn = false;
  final QuestionsFirebaseProvider _questionsFirebaseProvider =
      new QuestionsFirebaseProvider();
  final ImageFirebaseProvider _imageFirebaseProvider =
      new ImageFirebaseProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajout d'une question"),
      ),
      body: Provider<ImageCubit>(
        create: (context) => ImageCubit(),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Builder(
              builder: (BuildContext ctxScaffold) {
                return BlocBuilder<ImageCubit, File?>(
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Text("Ajouter une thématique et une question"),
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextField(
                            controller: _themeController,
                            decoration:
                                InputDecoration(hintText: "Ajouter un thème"),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Text("Ajouter une question"),
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextField(
                            controller: _questionController,
                            decoration: InputDecoration(
                                hintText: "Ajouter une question"),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        if (state != null)
                          Image.file(
                            state,
                            width: MediaQuery.of(context).size.width * 0.8,
                          ),
                        if (state != null)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                        (state != null)
                            ? ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<ImageCubit>()
                                      .sendCorrectImage(null);
                                },
                                child: Text("Enlever l'image"))
                            : ElevatedButton(
                                onPressed: () {
                                  _showPicker(context);
                                },
                                child: Text("Ajouter une image")),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Text("La réponse à votre question"),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Faux"),
                              Switch(
                                  value: _isSwitchOn, onChanged: _updateAnswer),
                              Text("Vrai"),
                            ],
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              print(_questionController.text);
                              if (_questionController.text != "" &&
                                  state != null &&
                                  _themeController.text != "") {
                                _imageFirebaseProvider
                                    .uploadImage(state)
                                    .then((value) {
                                  _questionsFirebaseProvider
                                      .addQuestion(new Question(
                                          _questionController.text,
                                          "/" + basename(state.path),
                                          _themeController.text,
                                          _isSwitchOn))
                                      .then((value) {
                                    //Navigator.push(context,
                                    //  MaterialPageRoute(builder: (context)=>QuestionsView(questions: questions,)));
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  });
                                });
                              } else {
                                Scaffold.of(ctxScaffold).showSnackBar(SnackBar(
                                  content:
                                      Text("Veuillez remplir tout les liens"),
                                  duration: Duration(milliseconds: 500),
                                ));
                              }
                            },
                            child: Text("Ajouter la question")),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionCustom(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  _imgFromGallery(BuildContext context) async {
    // ignore: deprecated_member_use
    File imageFromGallery = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100);
    context.read<ImageCubit>().sendCorrectImage(imageFromGallery);
  }

  _imgFromCamera(BuildContext context) async {
    // ignore: deprecated_member_use
    File imageFromCamera = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 100);
    context.read<ImageCubit>().sendCorrectImage(imageFromCamera);
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery(context);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _updateAnswer(bool value) {
    setState(() {
      _isSwitchOn = value;
      print("Switch ->" + _isSwitchOn.toString());
    });
  }

  @override
  void dispose() {
    _themeController.dispose();
    _questionController.dispose();
    super.dispose();
  }
}
