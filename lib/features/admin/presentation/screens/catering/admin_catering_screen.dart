import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/models/catering_request_model.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/app_text_field.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/status_badge.dart';

class AdminCateringScreen extends ConsumerWidget {
  const AdminCateringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = MockData.cateringRequests;
    final pending = requests
        .where((request) => request.isPending || request.isQuoted)
        .length;

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: requests.isEmpty
            ? const EmptyStateWidget(
                icon: Icons.event_outlined,
                title: 'No catering requests',
                message: 'Quote requests will appear here.',
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding,
                  AppSpacing.xl,
                  AppSpacing.pagePadding,
                  AppSpacing.huge,
                ),
                children: [
                  Text('Quoting desk',
                      style:
                          AppTypography.displayMedium.copyWith(fontSize: 34)),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '$pending quote${pending == 1 ? '' : 's'} open for operations review.',
                    style: AppTypography.bodyMd
                        .copyWith(color: AppColors.mutedText),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _QuoteBuilder(onTap: () => _showQuoteBuilder(context)),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  const SectionHeader(
                    title: 'Event requests',
                    subtitle:
                        'Budget, guest count, dietary needs, and quote state.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...requests.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                          child: _AdminCateringCard(
                            request: entry.value,
                            index: entry.key,
                            onQuote: () =>
                                _showQuoteBuilder(context, entry.value),
                          ),
                        ),
                      ),
                ],
              ),
      ),
    );
  }

  void _showQuoteBuilder(BuildContext context, [CateringRequest? request]) {
    AppBottomSheet.show(
      context,
      title: 'Quote builder',
      isScrollControlled: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          0,
          AppSpacing.pagePadding,
          AppSpacing.xl,
        ),
        child: Column(
          children: [
            AppTextField(
              label: 'Base price',
              hint: request?.quotedPrice?.toStringAsFixed(0) ?? '8075',
              prefixIcon: Icons.payments_outlined,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            const AppTextArea(
              label: 'Operations notes',
              hint: 'Menu, service staffing, dietary handling...',
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Send quote',
              icon: Icons.send_outlined,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuoteBuilder extends StatelessWidget {
  final VoidCallback onTap;

  const _QuoteBuilder({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          gradient: AppColors.warmGradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.terracotta.withAlpha(48),
              blurRadius: 26,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.white.withAlpha(30),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.request_quote_rounded,
                  color: AppColors.white),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Build a polished quote',
                      style: AppTypography.titleLg
                          .copyWith(color: AppColors.white)),
                  Text(
                    'Combine guest count, service model, staffing, and dietary requirements.',
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.white.withAlpha(205)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminCateringCard extends StatelessWidget {
  final CateringRequest request;
  final int index;
  final VoidCallback onQuote;

  const _AdminCateringCard({
    required this.request,
    required this.index,
    required this.onQuote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.white.withAlpha(180)),
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
                  color: AppColors.terracottaLight,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.event_available_rounded,
                    color: AppColors.terracotta),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.eventType, style: AppTypography.titleMd),
                    Text(
                      request.companyName ?? request.contactPerson,
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.mutedText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              StatusBadge.fromStatus(request.status, size: BadgeSize.small),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              InfoPill(
                  icon: Icons.people_outline_rounded,
                  label: '${request.numberOfGuests} guests'),
              InfoPill(
                  icon: Icons.payments_outlined,
                  label: request.budgetRange,
                  color: AppColors.warmGold),
              InfoPill(
                  icon: Icons.room_service_outlined,
                  label: request.serviceType,
                  color: AppColors.terracotta),
            ],
          ),
          if (request.dietaryRestrictions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text('Dietary needs', style: AppTypography.caption),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: request.dietaryRestrictions.map(
                (diet) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.oliveLight,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      diet,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.oliveGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text(
                  request.quotedPrice == null
                      ? 'No quote sent yet'
                      : 'Quoted at \$${request.quotedPrice!.toStringAsFixed(0)}',
                  style: AppTypography.titleSm
                      .copyWith(color: AppColors.terracotta),
                ),
              ),
              AppButton(
                label: request.quotedPrice == null ? 'Quote' : 'Revise',
                icon: Icons.request_quote_outlined,
                fullWidth: false,
                size: AppButtonSize.small,
                onPressed: onQuote,
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fade(delay: Duration(milliseconds: index * 80), duration: 260.ms);
  }
}
