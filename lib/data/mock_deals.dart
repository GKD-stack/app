import 'package:shop/models/deal_models.dart';

class MockDealData {
  static final positions = <DealPosition>[
    DealPosition(
      dealId: 'CMB-2021-7A',
      tranche: 'Class A',
      collateralType: 'Small Business ABS',
      region: 'US',
      dealName: 'Cobalt Funding 2021-7A',
    ),
    DealPosition(
      dealId: 'RMBS-2020-1',
      tranche: 'Mezz',
      collateralType: 'Non-QM RMBS',
      region: 'CA/FL',
      dealName: 'Sunset Mortgage Trust 2020-1',
    ),
    DealPosition(
      dealId: 'AUTO-2022-D',
      tranche: 'Equity',
      collateralType: 'Subprime Auto',
      region: 'Southeast',
      dealName: 'Rev Motor Credit 2022-D',
    ),
    DealPosition(
      dealId: 'CLO-2020-5',
      tranche: 'Class B',
      collateralType: 'CLO',
      region: 'Global',
      dealName: 'Granite CLO 2020-5',
    ),
  ];

  static Map<String, List<TriggerSnapshot>> triggerHistory = {
    'CMB-2021-7A': [
      TriggerSnapshot(
        period: DateTime(2024, 1),
        ocCushion: 7.2,
        icCushion: 1.36,
        delinquencyRate: 3.2,
        defaultRate: 0.3,
        stepUpMonthsRemaining: 12,
      ),
      TriggerSnapshot(
        period: DateTime(2024, 4),
        ocCushion: 6.5,
        icCushion: 1.29,
        delinquencyRate: 4.1,
        defaultRate: 0.5,
        stepUpMonthsRemaining: 9,
      ),
      TriggerSnapshot(
        period: DateTime(2024, 7),
        ocCushion: 5.9,
        icCushion: 1.22,
        delinquencyRate: 5.0,
        defaultRate: 0.7,
        stepUpMonthsRemaining: 6,
      ),
      TriggerSnapshot(
        period: DateTime(2024, 10),
        ocCushion: 4.6,
        icCushion: 1.18,
        delinquencyRate: 5.9,
        defaultRate: 0.9,
        stepUpMonthsRemaining: 3,
      ),
    ],
    'RMBS-2020-1': [
      TriggerSnapshot(
        period: DateTime(2024, 1),
        ocCushion: 9.4,
        icCushion: 1.45,
        delinquencyRate: 1.1,
        defaultRate: 0.1,
        stepUpMonthsRemaining: 14,
      ),
      TriggerSnapshot(
        period: DateTime(2024, 4),
        ocCushion: 9.2,
        icCushion: 1.42,
        delinquencyRate: 1.4,
        defaultRate: 0.1,
        stepUpMonthsRemaining: 11,
      ),
      TriggerSnapshot(
        period: DateTime(2024, 7),
        ocCushion: 8.7,
        icCushion: 1.39,
        delinquencyRate: 1.7,
        defaultRate: 0.2,
        stepUpMonthsRemaining: 8,
      ),
      TriggerSnapshot(
        period: DateTime(2024, 10),
        ocCushion: 8.2,
        icCushion: 1.34,
        delinquencyRate: 2.1,
        defaultRate: 0.2,
        stepUpMonthsRemaining: 5,
      ),
    ],
    'AUTO-2022-D': [
      TriggerSnapshot(
        period: DateTime(2024, 1),
        ocCushion: 6.0,
        icCushion: 1.08,
        delinquencyRate: 4.8,
        defaultRate: 1.8,
        stepUpMonthsRemaining: 10,
      ),
      TriggerSnapshot(
        period: DateTime(2024, 4),
        ocCushion: 5.4,
        icCushion: 1.04,
        delinquencyRate: 5.5,
        defaultRate: 2.1,
        stepUpMonthsRemaining: 7,
      ),
      TriggerSnapshot(
        period: DateTime(2024, 7),
        ocCushion: 4.9,
        icCushion: 0.99,
        delinquencyRate: 6.3,
        defaultRate: 2.4,
        stepUpMonthsRemaining: 4,
      ),
      TriggerSnapshot(
        period: DateTime(2024, 10),
        ocCushion: 4.1,
        icCushion: 0.93,
        delinquencyRate: 6.8,
        defaultRate: 2.9,
        stepUpMonthsRemaining: 2,
      ),
    ],
    'CLO-2020-5': [
      TriggerSnapshot(
        period: DateTime(2024, 1),
        ocCushion: 4.8,
        icCushion: 1.09,
        delinquencyRate: 0.6,
        defaultRate: 0.7,
        stepUpMonthsRemaining: 9,
      ),
      TriggerSnapshot(
        period: DateTime(2024, 4),
        ocCushion: 4.5,
        icCushion: 1.07,
        delinquencyRate: 0.8,
        defaultRate: 0.9,
        stepUpMonthsRemaining: 6,
      ),
      TriggerSnapshot(
        period: DateTime(2024, 7),
        ocCushion: 3.9,
        icCushion: 1.03,
        delinquencyRate: 1.1,
        defaultRate: 1.3,
        stepUpMonthsRemaining: 3,
      ),
      TriggerSnapshot(
        period: DateTime(2024, 10),
        ocCushion: 3.4,
        icCushion: 0.98,
        delinquencyRate: 1.4,
        defaultRate: 1.6,
        stepUpMonthsRemaining: 1,
      ),
    ],
  };

  static Map<String, MacroEnvironment> macroRegimes = {
    'CMB-2021-7A': MacroEnvironment(
      regime: MacroRegime.moderatelyStressed,
      indicators: [
        MacroIndicator(name: 'Small business delinquencies', value: 5.8, zScore: 1.1, yoyChange: 0.7),
        MacroIndicator(name: 'Regional unemployment', value: 5.1, zScore: 0.8, yoyChange: 0.4),
      ],
    ),
    'RMBS-2020-1': MacroEnvironment(
      regime: MacroRegime.normal,
      indicators: [
        MacroIndicator(name: 'HPA YoY', value: 2.8, zScore: -0.2, yoyChange: -0.1),
        MacroIndicator(name: 'Mortgage delinquency', value: 1.9, zScore: 0.3, yoyChange: 0.2),
      ],
    ),
    'AUTO-2022-D': MacroEnvironment(
      regime: MacroRegime.severelyStressed,
      indicators: [
        MacroIndicator(name: 'Used car prices YoY', value: -7.4, zScore: -1.3, yoyChange: -0.9),
        MacroIndicator(name: 'Subprime charge-offs', value: 8.2, zScore: 1.6, yoyChange: 1.1),
      ],
    ),
    'CLO-2020-5': MacroEnvironment(
      regime: MacroRegime.moderatelyStressed,
      indicators: [
        MacroIndicator(name: 'CCC migration', value: 6.4, zScore: 1.2, yoyChange: 0.5),
        MacroIndicator(name: 'Loan default rate', value: 3.3, zScore: 1.0, yoyChange: 0.6),
      ],
    ),
  };
}
