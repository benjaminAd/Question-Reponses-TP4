// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:questions_reponses/Utils/constants.dart';

class QuestionsRepository {
  var _questionsdb =
      FirebaseFirestore.instance.collection(Constants.questions_reference);

  Future<QuerySnapshot> getAllQuestions() {
    return _questionsdb.get();
  }

  Future<QuerySnapshot> getQuestionsFromTheme(String theme){
    return _questionsdb.where(Constants.theme_field,isEqualTo: theme).get();
  }

  Future<DocumentReference> addQuestion(Map<String,dynamic> question){
    return _questionsdb.add(question);
  }
}
