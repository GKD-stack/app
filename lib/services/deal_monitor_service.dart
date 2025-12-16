import 'dart:math';

import 'package:shop/models/deal_models.dart';

class DealMonitorService {
  List<DealSignal> buildSignals({
    required List<DealPosition> positions,
    required Map<String, List<TriggerSnapshot>> history,
    required Map<String, MacroEnvironment> macro,
  }) {
    return positions.map((position) {
      final dealHistory = history[position.dealId] ?? [];
      final sortedHistory = [...dealHistory]..sort((a, b) => a.period.compareTo(b.period));
      final macroEnv = macro[position.dealId] ??
          MacroEnvironment(regime: MacroRegime.normal, indicators: const []);
      final cushionTrend = _cushionTrend(sortedHistory);
      final volatility = _cushionVolatility(sortedHistory);
      final current = sortedHistory.isNotEmpty
          ? min(sortedHistory.last.ocCushion, sortedHistory.last.icCushion)
          : 0.0;

      final regimeScore = _macroScore(macroEnv.regime);
      final riskScore = _blendScores(
        current,
        cushionTrend,
        volatility,
        regimeScore,
        stepUpMonths: sortedHistory.isNotEmpty
            ? sortedHistory.last.stepUpMonthsRemaining
            : 0.0,
      );

      return DealSignal(
        deal: position,
        riskScore: riskScore,
        currentCushion: current,
        cushionTrend: cushionTrend,
        cushionVolatility: volatility,
        macroRegime: macroEnv.regime,
        history: sortedHistory,
      );
    }).toList()
      ..sort((a, b) => b.riskScore.compareTo(a.riskScore));
  }

  double _cushionTrend(List<TriggerSnapshot> history) {
    if (history.length < 2) return 0.0;
    final latest = min(history.last.ocCushion, history.last.icCushion);
    final earlierIndex = max(0, history.length - 4);
    final earlier = min(history[earlierIndex].ocCushion, history[earlierIndex].icCushion);
    return latest - earlier;
  }

  double _cushionVolatility(List<TriggerSnapshot> history) {
    if (history.length < 2) return 0.0;
    final cushions = history
        .map((e) => min(e.ocCushion, e.icCushion))
        .toList();
    final mean = cushions.reduce((a, b) => a + b) / cushions.length;
    final variance = cushions.fold<double>(
      0.0,
      (prev, value) => prev + pow(value - mean, 2),
    ) /
        cushions.length;
    return sqrt(variance);
  }

  double _macroScore(MacroRegime regime) {
    switch (regime) {
      case MacroRegime.normal:
        return 0.0;
      case MacroRegime.moderatelyStressed:
        return 0.35;
      case MacroRegime.severelyStressed:
        return 0.6;
    }
  }

  double _blendScores(
    double cushion,
    double trend,
    double volatility,
    double macroScore, {
    required double stepUpMonths,
  }) {
    final cushionPressure = cushion < 5 ? (5 - cushion) / 5 : 0.0;
    final erosion = trend < 0 ? min(trend.abs() / 5, 1.0) : 0.0;
    final volatilityScore = min(volatility / 3, 1.0);
    final stepUpRisk = stepUpMonths <= 6 ? (6 - stepUpMonths) / 6 : 0.0;

    final weighted = (cushionPressure * 0.35) +
        (erosion * 0.25) +
        (volatilityScore * 0.15) +
        (macroScore * 0.15) +
        (stepUpRisk * 0.1);

    return double.parse(weighted.clamp(0.0, 1.0).toStringAsFixed(2));
  }
}
