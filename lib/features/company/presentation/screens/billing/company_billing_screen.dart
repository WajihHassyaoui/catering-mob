import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/models/invoice_model.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/status_badge.dart';

class CompanyBillingScreen extends ConsumerWidget {
  const CompanyBillingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoices = MockData.invoices;
    final unpaid = invoices.where((i) => !i.isPaid).toList();
    final paid = invoices.where((i) => i.isPaid).toList();
    final totalDue = unpaid.fold<double>(0, (sum, i) => sum + i.total);
    final paidTotal = paid.fold<double>(0, (sum, i) => sum + i.total);

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            AppSpacing.xl,
            AppSpacing.pagePadding,
            AppSpacing.huge,
          ),
          children: [
            Text('Billing',
                style: AppTypography.displayMedium.copyWith(fontSize: 34)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Invoices, due dates, and transaction history for company catering.',
              style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
            ),
            const SizedBox(height: AppSpacing.xl),
            _SummaryBanner(
                unpaidCount: unpaid.length,
                totalDue: totalDue,
                paidTotal: paidTotal),
            const SizedBox(height: AppSpacing.sectionSpacing),
            SectionHeader(
              title: 'All invoices',
              subtitle: invoices.isEmpty
                  ? 'Nothing has been issued yet.'
                  : '${invoices.length} invoices in this workspace.',
            ),
            const SizedBox(height: AppSpacing.md),
            if (invoices.isEmpty)
              const EmptyStateWidget(
                icon: Icons.receipt_outlined,
                title: 'No invoices yet',
                message:
                    'Invoices from group orders and catering will appear here.',
              )
            else
              ...invoices.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child:
                          _InvoiceCard(invoice: entry.value, index: entry.key),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  final int unpaidCount;
  final double totalDue;
  final double paidTotal;

  const _SummaryBanner({
    required this.unpaidCount,
    required this.totalDue,
    required this.paidTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        gradient: AppColors.warmGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.terracotta.withAlpha(50),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.receipt_long_rounded,
                    color: AppColors.white),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('\$${totalDue.toStringAsFixed(2)} due',
                        style: AppTypography.headingMd
                            .copyWith(color: AppColors.white)),
                    Text(
                      '$unpaidCount unpaid invoice${unpaidCount == 1 ? '' : 's'}',
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.white.withAlpha(205)),
                    ),
                  ],
                ),
              ),
              AppButton(
                label: 'Pay all',
                fullWidth: false,
                variant: AppButtonVariant.ghost,
                onPressed: unpaidCount == 0 ? null : () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                    label: 'Paid total',
                    value: '\$${paidTotal.toStringAsFixed(0)}'),
              ),
              Container(
                  width: 1, height: 42, color: AppColors.white.withAlpha(70)),
              const Expanded(
                child: _SummaryMetric(label: 'Payment terms', value: 'Net 30'),
              ),
            ],
          ),
        ],
      ),
    ).animate().fade(duration: 280.ms).slideY(begin: 0.05, end: 0);
  }
}

class _SummaryMetric extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: AppTypography.titleLg.copyWith(color: AppColors.white)),
        Text(label,
            style: AppTypography.caption
                .copyWith(color: AppColors.white.withAlpha(190))),
      ],
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  final int index;

  const _InvoiceCard({required this.invoice, required this.index});

  @override
  Widget build(BuildContext context) {
    final accent = invoice.isPaid
        ? AppColors.oliveGreen
        : invoice.isOverdue
            ? AppColors.errorRed
            : AppColors.warmGold;
    return GestureDetector(
      onTap: () => context.push('/company/invoices/${invoice.id}'),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.warmIvory,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border:
              Border.all(color: accent.withAlpha(invoice.isOverdue ? 70 : 24)),
          boxShadow: const [
            BoxShadow(
              color: AppColors.ambientShadow,
              blurRadius: 22,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: accent.withAlpha(22),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                      invoice.isPaid
                          ? Icons.check_circle_outline_rounded
                          : Icons.receipt_outlined,
                      color: accent),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(invoice.invoiceNumber, style: AppTypography.titleMd),
                      Text(
                        _invoiceType(invoice.invoiceType),
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.mutedText),
                      ),
                    ],
                  ),
                ),
                StatusBadge.fromStatus(invoice.status, size: BadgeSize.small),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _InvoiceMetric(
                      label: 'Amount',
                      value: invoice.formattedTotal,
                      color: AppColors.terracotta),
                ),
                Expanded(
                  child: _InvoiceMetric(
                    label: 'Due date',
                    value: _fmtDate(invoice.dueDate),
                    color: invoice.isOverdue
                        ? AppColors.errorRed
                        : AppColors.charcoal,
                    alignEnd: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                minHeight: 6,
                value: invoice.isPaid
                    ? 1
                    : invoice.isOverdue
                        ? 0.92
                        : 0.36,
                color: accent,
                backgroundColor: accent.withAlpha(22),
              ),
            ),
            if (!invoice.isPaid) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Pay now',
                icon: Icons.payments_outlined,
                onPressed: () {},
              ),
            ],
          ],
        ),
      ),
    )
        .animate()
        .fade(delay: Duration(milliseconds: index * 80), duration: 260.ms);
  }

  String _invoiceType(String type) {
    switch (type) {
      case 'group_order':
        return 'Group order';
      case 'catering':
        return 'Catering event';
      case 'meal_prep':
        return 'Meal prep plan';
      default:
        return 'Order';
    }
  }

  String _fmtDate(DateTime d) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${m[d.month - 1]} ${d.day}, ${d.year}';
  }
}

class _InvoiceMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool alignEnd;

  const _InvoiceMetric({
    required this.label,
    required this.value,
    required this.color,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption),
        Text(value, style: AppTypography.titleMd.copyWith(color: color)),
      ],
    );
  }
}
