 import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 119, 176),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image.png',
              width: 200,
              height: 200,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage()),
                );
              },
              child: const Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> questions = [
    Question(
      'What programming language is Flutter built with?',
      ['Dart', 'Java', 'Python'],
      0,
    ),
    Question(
      'What does the main() function do in a Flutter app?',
      [
        'It is the entry point of the app',
        'It defines the app layout',
        'It handles user interactions'
      ],
      0,
    ),
    Question(
      'What is a widget in Flutter?',
      [
        'A component used for building the user interface',
        'A data model for storing app data',
        'A function that performs a specific task'
      ],
      0,
    ),
    Question(
      'What is the widget used for handling user input in Flutter?',
      ['TextField', 'Text', 'Container'],
      0,
    ),
    Question(
      'Which widget is used for displaying a list of scrollable items in Flutter?',
      ['ListView', 'GridView', 'Stack'],
      0,
    ),
  ];

  int currentQuestionIndex = 0;
  int score = 0;
  List<int> selectedAnswers = List.filled(6, -1);
  List<int> correctAnswers = [];

  void checkAnswer(int selectedAnswerIndex) {
    setState(() {
      selectedAnswers[currentQuestionIndex] = selectedAnswerIndex;
      correctAnswers.add(questions[currentQuestionIndex].correctAnswerIndex);

      if (selectedAnswerIndex ==
          questions[currentQuestionIndex].correctAnswerIndex) {
        score++;
      }

      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ResultPage(
                  score: score,
                  totalQuestions: questions.length,
                  correctAnswers: correctAnswers,
                  selectedAnswers: selectedAnswers,
                  questions: questions)),
        );
      }
    });
  }

  void goBack() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 63, 18, 228),
      appBar: AppBar(
        title: const Text('Flutter Quiz'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Question ${currentQuestionIndex + 1}/${questions.length}',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              questions[currentQuestionIndex].questionText,
              style: const TextStyle(fontSize: 24, color: Color.fromARGB(255, 240, 236, 236)),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            // Wrap the Column with Expanded widget
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0;
                    i < questions[currentQuestionIndex].choices.length;
                    i++)
                  RadioListTile<int>(
                    title: Text(
                      questions[currentQuestionIndex].choices[i],
                      style: const TextStyle(color: Colors.white),
                    ),
                    value: i,
                    groupValue: selectedAnswers[currentQuestionIndex],
                    onChanged: (int? value) {
                      setState(() {
                        selectedAnswers[currentQuestionIndex] = value!;
                      });
                    },
                  ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: goBack,
                child: const Text('◀ back'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  checkAnswer(selectedAnswers[currentQuestionIndex]);
                },
                child: Text(currentQuestionIndex < questions.length - 1
                    ? 'go Next ⏩'
                    : 'Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final List<int> correctAnswers;
  final List<int> selectedAnswers;
  final List<Question> questions;

  const ResultPage(
      {Key? key,
      required this.score,
      required this.totalQuestions,
      required this.correctAnswers,
      required this.selectedAnswers,
      required this.questions})
      : super(key: key);
@override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: const Color.fromARGB(255, 63, 18, 228),
      appBar: AppBar(
        title: const Text('Result of quize'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Quiz Completed!',
              style:  TextStyle(fontSize: 24, color: Colors.white),
            ),
            Text(
              'Your Score: $score/$totalQuestions',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            for (int i = 0; i < totalQuestions; i++)
              Text(
                'Question ${i + 1}: ${correctAnswers[i] == selectedAnswers[i] ? 'Correct' : 'Incorrect'}, Correct Answer: ${questions[i].choices[questions[i].correctAnswerIndex]}',
                style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 243, 236, 236)),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(
                    context, ModalRoute.withName(Navigator.defaultRouteName));
              },
              child: const Text('Restart Quiz'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Finish'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Thank you',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class Question {
  final String questionText;
  final List<String> choices;
  final int correctAnswerIndex;

  Question(this.questionText, this.choices, this.correctAnswerIndex);
}