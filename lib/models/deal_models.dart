import 'package:flutter/material.dart';

enum MacroRegime { normal, moderatelyStressed, severelyStressed }

class DealPosition {
  DealPosition({
    required this.dealId,
    required this.tranche,
    required this.collateralType,
    required this.region,
    required this.dealName,
  });

  final String dealId;
  final String tranche;
  final String collateralType;
  final String region;
  final String dealName;
}

class TriggerSnapshot {
  TriggerSnapshot({
    required this.period,
    required this.ocCushion,
    required this.icCushion,
    required this.delinquencyRate,
    required this.defaultRate,
    required this.stepUpMonthsRemaining,
  });

  final DateTime period;
  final double ocCushion;
  final double icCushion;
  final double delinquencyRate;
  final double defaultRate;
  final double stepUpMonthsRemaining;
}

class MacroIndicator {
  MacroIndicator({
    required this.name,
    required this.value,
    required this.zScore,
    required this.yoyChange,
  });

  final String name;
  final double value;
  final double zScore;
  final double yoyChange;
}

class MacroEnvironment {
  MacroEnvironment({
    required this.regime,
    required this.indicators,
  });

  final MacroRegime regime;
  final List<MacroIndicator> indicators;
}

class DealSignal {
  DealSignal({
    required this.deal,
    required this.riskScore,
    required this.currentCushion,
    required this.cushionTrend,
    required this.cushionVolatility,
    required this.macroRegime,
    required this.history,
  });

  final DealPosition deal;
  final double riskScore;
  final double currentCushion;
  final double cushionTrend;
  final double cushionVolatility;
  final MacroRegime macroRegime;
  final List<TriggerSnapshot> history;

  Color riskColor() {
    if (riskScore >= 0.7) return Colors.red.shade600;
    if (riskScore >= 0.45) return Colors.orange.shade600;
    return Colors.green.shade600;
  }

  String macroLabel() {
    switch (macroRegime) {
      case MacroRegime.normal:
        return 'Normal';
      case MacroRegime.moderatelyStressed:
        return 'Moderately stressed';
      case MacroRegime.severelyStressed:
        return 'Severely stressed';
    }
  }
}
