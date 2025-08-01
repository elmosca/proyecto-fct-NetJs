import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/evaluation.dart';
import '../../domain/entities/evaluation_criteria.dart';

abstract class EvaluationLocalDataSource {
  Future<void> cacheEvaluations(List<Evaluation> evaluations);
  Future<List<Evaluation>> getCachedEvaluations();
  Future<void> cacheEvaluationCriteria(List<EvaluationCriteria> criteria);
  Future<List<EvaluationCriteria>> getCachedEvaluationCriteria();
  Future<void> clearCache();
}

class EvaluationLocalDataSourceImpl implements EvaluationLocalDataSource {
  final SharedPreferences _prefs;
  static const String _evaluationsKey = 'cached_evaluations';
  static const String _criteriaKey = 'cached_evaluation_criteria';

  const EvaluationLocalDataSourceImpl(this._prefs);

  @override
  Future<void> cacheEvaluations(List<Evaluation> evaluations) async {
    final evaluationsJson = evaluations.map((e) => e.toJson()).toList();
    await _prefs.setString(_evaluationsKey, jsonEncode(evaluationsJson));
  }

  @override
  Future<List<Evaluation>> getCachedEvaluations() async {
    final evaluationsString = _prefs.getString(_evaluationsKey);
    if (evaluationsString == null) return [];

    final evaluationsJson = jsonDecode(evaluationsString) as List;
    return evaluationsJson.map((json) => Evaluation.fromJson(json)).toList();
  }

  @override
  Future<void> cacheEvaluationCriteria(
      List<EvaluationCriteria> criteria) async {
    final criteriaJson = criteria.map((c) => c.toJson()).toList();
    await _prefs.setString(_criteriaKey, jsonEncode(criteriaJson));
  }

  @override
  Future<List<EvaluationCriteria>> getCachedEvaluationCriteria() async {
    final criteriaString = _prefs.getString(_criteriaKey);
    if (criteriaString == null) return [];

    final criteriaJson = jsonDecode(criteriaString) as List;
    return criteriaJson
        .map((json) => EvaluationCriteria.fromJson(json))
        .toList();
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(_evaluationsKey);
    await _prefs.remove(_criteriaKey);
  }
}
