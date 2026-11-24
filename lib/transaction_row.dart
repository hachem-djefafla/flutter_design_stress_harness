import 'package:flutter/material.dart';
import 'stress_profile.dart';

/// Naive Figma-to-Flutter implementation: passes Happy Path, overflows in production.
class BrokenTransactionRow extends StatelessWidget {
  const BrokenTransactionRow({super.key, required this.item});

  final TransactionItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.merchantName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              item.formattedAmount,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Hardened layout contract:
/// - Bounds amount width and scales down gracefully on compact screens.
/// - Switches to a vertical stack at large accessibility text scales (> 1.35x).
class SafeTransactionRow extends StatelessWidget {
  const SafeTransactionRow({super.key, required this.item});

  final TransactionItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scaledBaseSize = MediaQuery.textScalerOf(context).scale(16);
    final stackVertically = scaledBaseSize > 21.6; // > 1.35x text scale

    final merchantDetails = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.merchantName,
          maxLines: stackVertically ? 3 : 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          item.status,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall,
        ),
      ],
    );

    final amountText = FittedBox(
      fit: BoxFit.scaleDown,
      alignment: stackVertically
          ? AlignmentDirectional.centerStart
          : AlignmentDirectional.centerEnd,
      child: Text(
        item.formattedAmount,
        maxLines: 1,
        softWrap: false,
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (stackVertically) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  merchantDetails,
                  const SizedBox(height: 10),
                  amountText,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: merchantDetails),
                const SizedBox(width: 12),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth * 0.48,
                  ),
                  child: amountText,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
  