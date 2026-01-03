import 'package:flutter/material.dart';
import 'dart:math';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int? selectedAnswer;
  bool showResult = false;
  int correctCount = 0;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> questions = [
    {
      'question': '다음 중 Flutter의 상태 관리 방법이 아닌 것은?',
      'options': ['Provider', 'Riverpod', 'Redux', 'Django'],
      'correct': 3,
    },
    {
      'question': 'Dart 언어에서 변수를 선언할 때 사용하는 키워드가 아닌 것은?',
      'options': ['var', 'let', 'final', 'const'],
      'correct': 1,
    },
    {
      'question': 'Flutter에서 StatefulWidget의 상태를 변경할 때 사용하는 메서드는?',
      'options': ['update()', 'setState()', 'refresh()', 'rebuild()'],
      'correct': 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.1, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (showResult) return;

    setState(() {
      selectedAnswer = index;
    });
  }

  void _submitAnswer() {
    if (selectedAnswer == null) return;

    setState(() {
      showResult = true;
      if (selectedAnswer == questions[currentQuestionIndex]['correct']) {
        correctCount++;
      }
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      _fadeController.reverse().then((_) {
        setState(() {
          currentQuestionIndex++;
          selectedAnswer = null;
          showResult = false;
        });
        _fadeController.forward();
        _slideController.reset();
        _slideController.forward();
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F8FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF87CEEB),
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '완료!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                '총 ${questions.length}문제 중 $correctCount개 정답',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      currentQuestionIndex = 0;
                      selectedAnswer = null;
                      showResult = false;
                      correctCount = 0;
                    });
                    _fadeController.forward();
                    _slideController.forward();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF87CEEB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 헤더
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '문제 ${currentQuestionIndex + 1}/${questions.length}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F8FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '정답 $correctCount개',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF87CEEB),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 진행률
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / questions.length,
                  backgroundColor: const Color(0xFFF0F8FF),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF87CEEB),
                  ),
                  minHeight: 6,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 문제 영역
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 문제
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FBFF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            currentQuestion['question'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[900],
                              height: 1.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 보기
                        ...List.generate(
                          currentQuestion['options'].length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildOptionButton(
                              index,
                              currentQuestion['options'][index],
                              currentQuestion['correct'],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 하단 버튼
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: showResult ? _nextQuestion : _submitAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF87CEEB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    showResult
                        ? (currentQuestionIndex < questions.length - 1
                              ? '다음 문제'
                              : '완료')
                        : '정답 확인',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(int index, String text, int correctIndex) {
    bool isSelected = selectedAnswer == index;
    bool isCorrect = index == correctIndex;

    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (showResult) {
      if (isCorrect) {
        backgroundColor = const Color(0xFFE8F5E9);
        borderColor = const Color(0xFF4CAF50);
        textColor = const Color(0xFF2E7D32);
      } else if (isSelected && !isCorrect) {
        backgroundColor = const Color(0xFFFFEBEE);
        borderColor = const Color(0xFFEF5350);
        textColor = const Color(0xFFC62828);
      } else {
        backgroundColor = const Color(0xFFF8FBFF);
        borderColor = const Color(0xFFE0E0E0);
        textColor = Colors.grey[700]!;
      }
    } else {
      backgroundColor = isSelected
          ? const Color(0xFFF0F8FF)
          : const Color(0xFFF8FBFF);
      borderColor = isSelected
          ? const Color(0xFF87CEEB)
          : const Color(0xFFE0E0E0);
      textColor = isSelected ? const Color(0xFF87CEEB) : Colors.grey[700]!;
    }

    return GestureDetector(
      onTap: () => _selectAnswer(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor,
            width: isSelected || (showResult && isCorrect) ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: showResult && isCorrect
                    ? const Color(0xFF4CAF50)
                    : (showResult && isSelected && !isCorrect)
                    ? const Color(0xFFEF5350)
                    : isSelected
                    ? const Color(0xFF87CEEB)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 2),
              ),
              child: showResult
                  ? Icon(
                      isCorrect
                          ? Icons.check
                          : (isSelected ? Icons.close : null),
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
