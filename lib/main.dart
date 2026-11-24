import 'package:flutter/material.dart';

import 'design_stress_harness.dart';
import 'stress_profile.dart';
import 'transaction_row.dart';

void main() => runApp(const StressDemoApp());

class StressDemoApp extends StatefulWidget {
  const StressDemoApp({super.key});

  @override
  State<StressDemoApp> createState() => _StressDemoAppState();
}

class _StressDemoAppState extends State<StressDemoApp> {
  StressScenario _scenario = StressScenario.happyPath;
  bool _useSafeLayout = true;

  @override
  Widget build(BuildContext context) {
    final items = TransactionItem.sampleFor(_scenario);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: Scaffold(
        body: DesignStressHarness(
          scenario: _scenario,
          onScenarioChanged: (value) => setState(() => _scenario = value),
          useSafeLayout: _useSafeLayout,
          onLayoutModeChanged: (value) =>
              setState(() => _useSafeLayout = value),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _useSafeLayout
                  ? SafeTransactionRow(item: item)
                  : BrokenTransactionRow(item: item);
            },
          ),
        ),
      ),
    );
  }
}
