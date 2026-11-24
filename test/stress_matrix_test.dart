import 'package:flutter/material.dart';
import 'package:flutter_design_stress_harness/stress_profile.dart';
import 'package:flutter_design_stress_harness/transaction_row.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Worst-case layout stress matrix (360dp compact viewport)', () {
    for (final scenario in StressScenario.values) {
      testWidgets(
        'SafeTransactionRow renders without overflow under ${scenario.label}',
        (tester) async {
          tester.view.physicalSize = const Size(360, 640);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          final items = TransactionItem.sampleFor(scenario);

          await tester.pumpWidget(
            MaterialApp(
              home: Directionality(
                textDirection: scenario.textDirection,
                child: MediaQuery.withClampedTextScaling(
                  minScaleFactor: scenario.textScale,
                  maxScaleFactor: scenario.textScale,
                  child: Scaffold(
                    body: ListView(
                      padding: const EdgeInsets.all(16),
                      children: items
                          .map((item) => SafeTransactionRow(item: item))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets('BrokenTransactionRow overflows under worst-case strings', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final worstItem = TransactionItem.sampleFor(StressScenario.worstCase)
          .first;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: BrokenTransactionRow(item: worstItem)),
        ),
      );

      final exception = tester.takeException();
      expect(exception, isA<FlutterError>());
    });
  });
}
