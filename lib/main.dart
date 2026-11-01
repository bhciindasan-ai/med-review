import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MedReviewApp());
}

class MedReviewApp extends StatelessWidget {
  const MedReviewApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MED REVIEW',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        textTheme: GoogleFonts.lexendTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const QuizScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuestionModel {
  final String category;
  final String questionText;
  final List<OptionModel> options;
  final String rationale;

  QuestionModel({
    required this.category,
    required this.questionText,
    required this.options,
    required this.rationale,
  });
}

class OptionModel {
  final String text;
  final bool isCorrect;

  OptionModel({required this.text, required this.isCorrect});
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<QuestionModel> rawQuestions = [
    QuestionModel(
      category: "Orthopedic Trauma",
      questionText: "Which physical examination test is most sensitive for detecting a complete anterior cruciate ligament (ACL) tear?",
      options: [
        OptionModel(text: "Lachman test", isCorrect: true),
        OptionModel(text: "McMurry test", isCorrect: false),
        OptionModel(text: "Apley compression test", isCorrect: false),
        OptionModel(text: "Valgus stress test at 30 degrees", isCorrect: false),
      ],
      rationale: "The Lachman test is performed with the knee flexed at 20 to 30 degrees and is widely considered the most sensitive clinical test for ACL tears because it isolates the anterolateral bundle.",
    ),
    QuestionModel(
      category: "Orthopedic Trauma",
      questionText: "A patient presents with a midshaft humeral fracture after arm wrestling. Which nerve is most at risk for injury?",
      options: [
        OptionModel(text: "Ulnar nerve", isCorrect: false),
        OptionModel(text: "Radial nerve in the spiral groove", isCorrect: true),
        OptionModel(text: "Axillary nerve", isCorrect: false),
        OptionModel(text: "Median nerve", isCorrect: false),
      ],
      rationale: "The radial nerve travels closely along the posterior aspect of the humerus within the spiral groove, making it highly vulnerable during midshaft humeral fractures.",
    ),
    QuestionModel(
      category: "Medical-Surgical",
      questionText: "A patient with left-sided heart failure is admitted to the unit. Which clinical manifestation should the nurse expect to assess?",
      options: [
        OptionModel(text: "Jugular venous distention (JVD)", isCorrect: false),
        OptionModel(text: "Dependent peripheral edema", isCorrect: false),
        OptionModel(text: "Bilaterally crackles in lung bases", isCorrect: true),
        OptionModel(text: "Hepatosplenomegaly", isCorrect: false),
      ],
      rationale: "Left-sided heart failure results in pulmonary congestion and increased pulmonary hydrostatic pressure, leading to dyspnea, orthopnea, and inspiratory crackles. JVD and peripheral edema are hallmarks of right-sided failure.",
    ),
    QuestionModel(
      category: "Pharmacology",
      questionText: "A client receiving intravenous regular insulin develops acute diaphoresis, tremors, and confusion. What is the immediate nursing priority?",
      options: [
        OptionModel(text: "Administer 15-20 grams of a fast-acting oral carbohydrate if conscious", isCorrect: true),
        OptionModel(text: "Recheck blood glucose in two hours", isCorrect: false),
        OptionModel(text: "Administer a long-acting insulin dose", isCorrect: false),
        OptionModel(text: "Encourage physical exercise to burn excess glucose", isCorrect: false),
      ],
      rationale: "The client is exhibiting signs of acute hypoglycemia. If conscious and able to swallow, the immediate intervention is to administer 15-20g of fast-acting carbohydrates.",
    ),
    QuestionModel(
      category: "Critical Care",
      questionText: "A nurse is managing a client with a chest tube connected to a water-seal system. Continuous bubbling is observed in the water-seal chamber. What does this indicate?",
      options: [
        OptionModel(text: "Normal lung re-expansion progress", isCorrect: false),
        OptionModel(text: "An air leak in the drainage system or chest cavity", isCorrect: true),
        OptionModel(text: "Obstruction in the chest tube catheter", isCorrect: false),
        OptionModel(text: "Normal suction control pressure regulation", isCorrect: false),
      ],
      rationale: "Intermittent bubbling during expiration is normal, but continuous bubbling in the water-seal chamber indicates an air leak somewhere in the system or around the insertion site.",
    ),
    QuestionModel(
      category: "Medical-Surgical",
      questionText: "An emergency department client with chronic kidney disease (CKD) has a serum potassium level of 6.8 mEq/L. Which electrocardiogram (ECG) change is most characteristic of this imbalance?",
      options: [
        OptionModel(text: "U waves", isCorrect: false),
        OptionModel(text: "Flattened T waves", isCorrect: false),
        OptionModel(text: "Tall, peaked T waves", isCorrect: true),
        OptionModel(text: "Prolonged QT intervals", isCorrect: false),
      ],
      rationale: "Severe hyperkalemia (potassium > 5.0 mEq/L) commonly presents with tall, peaked T waves on an ECG, which can rapidly progress to widened QRS complexes and ventricular arrhythmias if untreated.",
    ),
  ];

  late List<QuestionModel> questions;
  int currentIndex = 0;
  OptionModel? selectedOption;
  bool isAnswered = false;
  String? selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    _loadAndRandomizeQuestions();
  }

  void _loadAndRandomizeQuestions() {
    var filtered = selectedCategory == "All" 
        ? rawQuestions 
        : rawQuestions.where((q) => q.category == selectedCategory).toList();

    questions = filtered.map((q) {
      var shuffledOptions = List<OptionModel>.from(q.options)..shuffle(Random());
      return QuestionModel(
        category: q.category,
        questionText: q.questionText,
        options: shuffledOptions,
        rationale: q.rationale,
      );
    }).toList();
    currentIndex = 0;
    selectedOption = null;
    isAnswered = false;
  }

  void _answerQuestion(OptionModel option) {
    if (isAnswered) return;
    setState(() {
      selectedOption = option;
      isAnswered = true;
    });
  }

  void _nextQuestion() {
    setState(() {
      if (currentIndex < questions.length - 1) {
        currentIndex++;
        selectedOption = null;
        isAnswered = false;
      } else {
        currentIndex = questions.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text("No questions available for this category.", style: GoogleFonts.lexend(fontSize: 16)),
        ),
      );
    }

    if (currentIndex >= questions.length) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Quiz Completed!", style: GoogleFonts.lexend(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => setState(() => _loadAndRandomizeQuestions()),
                child: const Text("Restart Review"),
              ),
            ],
          ),
        ),
      );
    }

    final q = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("MED REVIEW", style: GoogleFonts.lexend(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(label: Text(q.category)),
                Text("Question ${currentIndex + 1} of ${questions.length}", style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              q.questionText,
              style: GoogleFonts.lexend(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            ...q.options.map((option) {
              Color btnColor = Colors.white;
              Color borderColor = Colors.grey.shade300;
              Color textColor = Colors.black87;

              if (isAnswered) {
                if (option.isCorrect) {
                  btnColor = Colors.green.shade50;
                  borderColor = Colors.green;
                  textColor = Colors.green.shade900;
                } else if (option == selectedOption) {
                  btnColor = Colors.red.shade50;
                  borderColor = Colors.red;
                  textColor = Colors.red.shade900;
                }
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: btnColor,
                    side: BorderSide(color: borderColor, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _answerQuestion(option),
                  child: Text(
                    option.text,
                    style: GoogleFonts.lexend(fontSize: 15, color: textColor),
                  ),
                ),
              );
            }).toList(),
            if (isAnswered) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border(left: BorderSide(color: Colors.blue.shade700, width: 4)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rationale:", style: GoogleFonts.lexend(fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                    const SizedBox(height: 4),
                    Text(q.rationale, style: GoogleFonts.lexend(fontSize: 14, color: Colors.blue.shade900)),
                  ],
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                  onPressed: _nextQuestion,
                  child: Text("Next Question", style: GoogleFonts.lexend(fontWeight: FontWeight.w600)),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}