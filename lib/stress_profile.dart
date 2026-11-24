import 'package:flutter/material.dart';

enum StressScenario {
  happyPath('Happy Path'),
  worstCase('Worst-Case Strings'),
  arabicRtl('Arabic RTL'),
  largeFont('1.8x Font Scale');

  const StressScenario(this.label);
  final String label;

  TextDirection get textDirection =>
      this == StressScenario.arabicRtl ? TextDirection.rtl : TextDirection.ltr;

  double get textScale => this == StressScenario.largeFont ? 1.8 : 1.0;
}

class TransactionItem {
  const TransactionItem({
    required this.merchantName,
    required this.formattedAmount,
    required this.status,
  });

  final String merchantName;
  final String formattedAmount;
  final String status;

  static List<TransactionItem> sampleFor(StressScenario scenario) {
    switch (scenario) {
      case StressScenario.happyPath:
        return const [
          TransactionItem(
            merchantName: 'Amine K.',
            formattedAmount: '2,500.00 DZD',
            status: 'Completed',
          ),
          TransactionItem(
            merchantName: 'Café Atlas',
            formattedAmount: '450.00 DZD',
            status: 'Completed',
          ),
        ];
      case StressScenario.worstCase:
      case StressScenario.largeFont:
        return const [
          TransactionItem(
            merchantName: 'SARL Société Générale de Distribution et Logistique Internationale',
            formattedAmount: '148,950,000.00 DZD',
            status: 'Pending Settlement',
          ),
          TransactionItem(
            merchantName:
                'EURL Pharmacie Centrale & Équipements Médicaux Spécialisés',
            formattedAmount: '9,845,200.50 DZD',
            status: 'Completed',
          ),
        ];
      case StressScenario.arabicRtl:
        return const [
          TransactionItem(
            merchantName:
                'شركة التوزيع والخدمات اللوجستية العامة - فرع الجزائر العاصمة',
            formattedAmount: '148,950,000.00 د.ج',
            status: 'مكتملة',
          ),
          TransactionItem(
            merchantName: 'صيدلية الأمل المركزية للمستلزمات الطبية',
            formattedAmount: '12,400.00 د.ج',
            status: 'قيد المعالجة',
          ),
        ];
    }
  }
}
