import '../entities/evaluation.dart';
import '../entities/evaluation_result.dart';

class CalculateEvaluationScoreUseCase {
  const CalculateEvaluationScoreUseCase();

  double call(List<EvaluationScore> scores) {
    if (scores.isEmpty) return 0.0;

    double totalScore = 0.0;
    double maxPossibleScore = 0.0;

    for (final score in scores) {
      totalScore += score.score;
      maxPossibleScore += score.maxScore;
    }

    return maxPossibleScore > 0 ? totalScore : 0.0;
  }

  double calculatePercentage(List<EvaluationScore> scores) {
    if (scores.isEmpty) return 0.0;

    double totalScore = 0.0;
    double maxPossibleScore = 0.0;

    for (final score in scores) {
      totalScore += score.score;
      maxPossibleScore += score.maxScore;
    }

    return maxPossibleScore > 0 ? (totalScore / maxPossibleScore) * 100 : 0.0;
  }

  String calculateGrade(List<EvaluationScore> scores) {
    final percentage = calculatePercentage(scores);
    
    if (percentage >= 90) return 'A';
    if (percentage >= 80) return 'B';
    if (percentage >= 70) return 'C';
    if (percentage >= 60) return 'D';
    return 'F';
  }
} 