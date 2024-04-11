
// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/app_quiz.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/models/state.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'questions.dart';
import 'state_test.mocks.dart';

void main() {

  final client = MockClient();

  when(client.get(Uri.parse('https://stevecassidy.github.io/harry-potter-quiz-app/lib/data/questions.json')))
      .thenAnswer((_) async => http.Response(jsonEncode(questionsJson), 200));

  testWidgets('Full App', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    
    await tester.pumpWidget(ChangeNotifierProvider(
         create: (context) => StateModel(client),
         child: const Quiz(),
    ));

    // should start showing the home screen
    final titleFinder = find.text("Harry Potter Quiz App");
    final startFinder = find.text("Start the Quiz");

    expect(titleFinder, findsOneWidget);
    expect(startFinder, findsOneWidget);

    // tap the start button and we should move to the quiz
    await tester.tap(startFinder);

    await tester.pump();

    // verify we're on the question screen by text
    Finder questionFinder;
    Finder answerFinder;
    Finder questionTextFinder;
    for(int i = 1; i <= questions.length; i++) {
      questionFinder = find.text("Question $i");
      questionTextFinder = find.byKey(const Key('question-text'));

      if(i == 1) answerFinder = find.text("Hedwig");
      else if(i == 2) answerFinder = find.text("Hogwarts Express");
      else if(i == 3) answerFinder = find.text("Pensieve");
      else if(i == 4) answerFinder = find.text("Quidditch");
      else if(i == 5) answerFinder = find.text("Azkaban");
      else if(i == 6) answerFinder = find.text("Platform 9¾");
      else answerFinder = find.text("null");
      
      expect(questionFinder, findsOneWidget);
      expect(answerFinder, findsOneWidget);
      expect(questionTextFinder, findsOneWidget);
    
      // tap the start button and we should move to the quiz
      await tester.tap(answerFinder);
      await tester.pump();
    }

    //final resultFinder = find.text("You have answered 6 out of 6 Questions Correctly!");
    final restartFinder = find.text("Restart Quiz");
    //expect(resultFinder, findsOneWidget);
    expect(restartFinder, findsOneWidget);
    await tester.tap(restartFinder);
    await tester.pump();

    expect(titleFinder, findsOneWidget);
    expect(startFinder, findsOneWidget);

  });
}
