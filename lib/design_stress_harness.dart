import 'package:flutter/material.dart';

import 'stress_profile.dart';

/// Wraps any screen to toggle worst-case content, RTL direction, and large text scaling live.
class DesignStressHarness extends StatelessWidget {
  const DesignStressHarness({
    super.key,
    required this.scenario,
    required this.onScenarioChanged,
    required this.useSafeLayout,
    required this.onLayoutModeChanged,
    required this.child,
  });

  final StressScenario scenario;
  final ValueChanged<StressScenario> onScenarioChanged;
  final bool useSafeLayout;
  final ValueChanged<bool> onLayoutModeChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: StressScenario.values.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(item.label),
                            selected: scenario == item,
                            onSelected: (_) => onScenarioChanged(item),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SwitchListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      useSafeLayout
                          ? 'Mode: Hardened Layout (SafeTransactionRow)'
                          : 'Mode: Naive Layout (BrokenTransactionRow)',
                    ),
                    value: useSafeLayout,
                    onChanged: onLayoutModeChanged,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Directionality(
            textDirection: scenario.textDirection,
            child: MediaQuery.withClampedTextScaling(
              minScaleFactor: scenario.textScale,
              maxScaleFactor: scenario.textScale,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
