import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/data/mock_deals.dart';
import 'package:shop/models/deal_models.dart';
import 'package:shop/services/deal_monitor_service.dart';

class DealMonitorScreen extends StatefulWidget {
  const DealMonitorScreen({super.key});

  @override
  State<DealMonitorScreen> createState() => _DealMonitorScreenState();
}

class _DealMonitorScreenState extends State<DealMonitorScreen> {
  late final DealMonitorService _service;
  late final List<DealSignal> _signals;
  DealSignal? _selectedSignal;

  @override
  void initState() {
    super.initState();
    _service = DealMonitorService();
    _signals = _service.buildSignals(
      positions: MockDealData.positions,
      history: MockDealData.triggerHistory,
      macro: MockDealData.macroRegimes,
    );
    _selectedSignal = _signals.first;
  }

  @override
  Widget build(BuildContext context) {
    final highRisk = _signals.where((s) => s.riskScore >= 0.45).length;
    final macroStressed =
        _signals.where((s) => s.macroRegime != MacroRegime.normal).length;
    final averageDrop = _signals
            .map((s) => s.cushionTrend)
            .where((trend) => trend < 0)
            .fold<double>(0, (prev, value) => prev + value.abs()) /
        max(1, _signals.length);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deal Trigger Early-Warning Monitor'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Automated view of trigger cushions, collateral performance and macro context. '
                'Rank deals by deterioration velocity and environment stress.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatCard(
                    label: 'Deals flagged',
                    value: '$highRisk',
                    subtitle: 'Risk score >= 0.45',
                    icon: Icons.warning_amber_rounded,
                    color: Colors.deepOrange,
                  ),
                  _StatCard(
                    label: 'Avg cushion erosion',
                    value: '-${averageDrop.toStringAsFixed(1)} pts',
                    subtitle: 'Last 3 periods',
                    icon: Icons.trending_down,
                    color: Colors.red,
                  ),
                  _StatCard(
                    label: 'Macro stressed',
                    value: '$macroStressed',
                    subtitle: 'Non-normal regimes',
                    icon: Icons.public,
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _SectionHeader(
                title: 'Top deals with fastest cushion deterioration',
                subtitle:
                    'Combines cushion distance to trigger, trend velocity, volatility and macro stress.',
              ),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: min(4, _signals.length),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final signal = _signals[index];
                  return _DealDigestTile(
                    signal: signal,
                    onTap: () {
                      setState(() => _selectedSignal = signal);
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              _SectionHeader(
                title: 'Deal detail view',
                subtitle:
                    'Track cushions over time, collateral metrics and macro overlays for context.',
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<DealSignal>(
                              isExpanded: true,
                              value: _selectedSignal,
                              items: _signals
                                  .map(
                                    (signal) => DropdownMenuItem(
                                      value: signal,
                                      child: Text('${signal.deal.dealName} (${signal.deal.tranche})'),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) => setState(() => _selectedSignal = value),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            backgroundColor:
                                _selectedSignal?.riskColor().withOpacity(0.15),
                            label: Text(
                              'Score ${_selectedSignal?.riskScore.toStringAsFixed(2) ?? '--'}',
                              style: TextStyle(
                                color: _selectedSignal?.riskColor(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_selectedSignal != null)
                        _DealDetail(signal: _selectedSignal!),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DealDetail extends StatelessWidget {
  const _DealDetail({required this.signal});

  final DealSignal signal;

  String _trendText() {
    final change = signal.cushionTrend;
    final latest = signal.currentCushion;
    final previous = latest - change;
    final direction = change < 0 ? 'down' : 'up';
    return 'Cushion $direction ${change.abs().toStringAsFixed(1)} pts → ${latest.toStringAsFixed(1)} over last 3 periods.'
        ' Delinquencies ${signal.history.last.delinquencyRate.toStringAsFixed(1)}%,'
        ' defaults ${signal.history.last.defaultRate.toStringAsFixed(1)}%.';
  }

  @override
  Widget build(BuildContext context) {
    final history = signal.history;
    final latest = history.last;
    final formatter = DateFormat('MMM yy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                title: 'Current cushion',
                value: '${signal.currentCushion.toStringAsFixed(1)} pts',
                subtitle:
                    'OC ${latest.ocCushion.toStringAsFixed(1)} | IC ${latest.icCushion.toStringAsFixed(2)}',
              ),
            ),
            Expanded(
              child: _MetricTile(
                title: 'Volatility',
                value: signal.cushionVolatility.toStringAsFixed(2),
                subtitle: 'Std dev of cushion',
              ),
            ),
            Expanded(
              child: _MetricTile(
                title: 'Macro regime',
                value: signal.macroLabel(),
                subtitle: 'Environment overlay',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: _TrendSparkline(history: history),
        ),
        const SizedBox(height: 12),
        Text(
          _trendText(),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: signal.history
              .map(
                (snap) => Chip(
                  avatar: const Icon(Icons.calendar_today, size: 16),
                  label: Text(
                    '${formatter.format(snap.period)} • ${snap.ocCushion.toStringAsFixed(1)} OC'
                    ' / ${snap.icCushion.toStringAsFixed(2)} IC • ${snap.delinquencyRate.toStringAsFixed(1)}% delinq',
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        Text(
          'Macro indicators',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: MockDealData.macroRegimes[signal.deal.dealId]!
              .indicators
              .map(
                (indicator) => _MacroChip(indicator: indicator),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _DealDigestTile extends StatelessWidget {
  const _DealDigestTile({required this.signal, required this.onTap});

  final DealSignal signal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final latest = signal.history.last;
    final change = signal.cushionTrend;
    final changeLabel = change < 0
        ? '-${change.abs().toStringAsFixed(1)} pts'
        : '+${change.toStringAsFixed(1)} pts';

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: signal.riskColor().withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        signal.deal.dealName,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${signal.deal.dealId} • ${signal.deal.tranche} • ${signal.deal.collateralType}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Chip(
                      backgroundColor: signal.riskColor().withOpacity(0.12),
                      label: Text(
                        'Score ${signal.riskScore.toStringAsFixed(2)}',
                        style: TextStyle(color: signal.riskColor()),
                      ),
                    ),
                    Text(
                      signal.macroLabel(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _Badge(
                  icon: Icons.shield_rounded,
                  label: 'Cushion ${signal.currentCushion.toStringAsFixed(1)} pts',
                ),
                const SizedBox(width: 8),
                _Badge(icon: Icons.trending_down, label: changeLabel),
                const SizedBox(width: 8),
                _Badge(
                  icon: Icons.assessment,
                  label:
                      'Delinq ${latest.delinquencyRate.toStringAsFixed(1)}% | Default ${latest.defaultRate.toStringAsFixed(1)}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  const _MacroChip({required this.indicator});

  final MacroIndicator indicator;

  @override
  Widget build(BuildContext context) {
    final stressColor = indicator.zScore >= 1
        ? Colors.red.shade600
        : (indicator.zScore.abs() > 0.5
            ? Colors.orange.shade700
            : Colors.green.shade700);
    final arrow = indicator.yoyChange >= 0 ? '▲' : '▼';
    return Chip(
      avatar: Icon(Icons.public, color: stressColor, size: 18),
      label: Text(
        '${indicator.name}: ${indicator.value.toStringAsFixed(1)} (${indicator.zScore.toStringAsFixed(1)}σ, $arrow${indicator.yoyChange.abs().toStringAsFixed(1)}% YoY)',
        style: TextStyle(color: stressColor),
      ),
    );
  }
}

class _TrendSparkline extends StatelessWidget {
  const _TrendSparkline({required this.history});

  final List<TriggerSnapshot> history;

  @override
  Widget build(BuildContext context) {
    final ocSeries = history.map((e) => e.ocCushion).toList();
    final icSeries = history.map((e) => e.icCushion * 100).toList();
    final labels = history.map((e) => DateFormat('MMM').format(e.period)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: CustomPaint(
                  painter: _SparklinePainter(
                    ocSeries,
                    color: Colors.blueAccent,
                    label: 'OC cushion',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomPaint(
                  painter: _SparklinePainter(
                    icSeries,
                    color: Colors.deepPurple,
                    label: 'IC cushion (x100)',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels
              .map((label) => Text(label, style: Theme.of(context).textTheme.bodySmall))
              .toList(),
        ),
      ],
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter(this.data, {required this.color, required this.label});

  final List<double> data;
  final Color color;
  final String label;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final minValue = data.reduce(min);
    final maxValue = data.reduce(max);
    final range = max(maxValue - minValue, 0.001);

    final points = <Offset>[];
    for (var i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final normalizedY = (data[i] - minValue) / range;
      final y = size.height - (normalizedY * size.height);
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);
    textPainter.paint(canvas, Offset(0, 0));
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.color != color;
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold, color: color),
                ),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
