import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

class CompanyCateringScreen extends ConsumerWidget {
  const CompanyCateringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = MockData.cateringRequests;

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: requests.isEmpty
            ? EmptyStateWidget(
                icon: Icons.event_outlined,
                title: 'No catering requests',
                message:
                    'Plan your next corporate event with a guided request.',
                actionLabel: 'Request catering',
                onAction: () => _showRequestSheet(context),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding,
                  AppSpacing.xl,
                  AppSpacing.pagePadding,
                  AppSpacing.huge,
                ),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Catering',
                                style: AppTypography.displayMedium
                                    .copyWith(fontSize: 34)),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Plan events with quotes, budgets, and dietary needs in one place.',
                              style: AppTypography.bodyMd
                                  .copyWith(color: AppColors.mutedText),
                            ),
                          ],
                        ),
                      ),
                      AppButton(
                        label: 'New',
                        icon: Icons.add_rounded,
                        fullWidth: false,
                        size: AppButtonSize.small,
                        variant: AppButtonVariant.secondary,
                        onPressed: () => _showRequestSheet(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _RequestHero(onTap: () => _showRequestSheet(context)),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  const SectionHeader(
                    title: 'Booking pipeline',
                    subtitle:
                        'Quotes, confirmed events, and completed requests.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...requests.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                          child: _CateringRequestCard(
                            request: entry.value,
                            index: entry.key,
                          ),
                        ),
                      ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRequestSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Request'),
        backgroundColor: AppColors.terracotta,
      ),
    );
  }

  void _showRequestSheet(BuildContext context) {
    AppBottomSheet.show(
      context,
      title: 'Event request',
      isScrollControlled: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            0,
            AppSpacing.pagePadding,
            AppSpacing.xl,
          ),
          child: Column(
            children: [
              const AppTextField(
                label: 'Event type',
                hint: 'Leadership offsite',
                prefixIcon: Icons.event_outlined,
              ),
              const SizedBox(height: AppSpacing.md),
              const AppTextField(
                label: 'Guests',
                hint: '80',
                prefixIcon: Icons.people_outline_rounded,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.md),
              const AppTextField(
                label: 'Budget range',
                hint: '\$5,000 - \$10,000',
                prefixIcon: Icons.payments_outlined,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Review request',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestHero extends StatelessWidget {
  final VoidCallback onTap;

  const _RequestHero({required this.onTap});

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
              color: AppColors.terracotta.withAlpha(50),
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
              child: const Icon(Icons.room_service_rounded,
                  color: AppColors.white),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Build an event quote',
                      style: AppTypography.titleLg
                          .copyWith(color: AppColors.white)),
                  Text(
                    'Guest count, service style, dietary exclusions, and review before submit.',
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.white.withAlpha(205)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded, color: AppColors.white),
          ],
        ),
      ),
    );
  }
}

class _CateringRequestCard extends StatelessWidget {
  final CateringRequest request;
  final int index;

  const _CateringRequestCard({required this.request, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/company/catering/${request.id}'),
      child: Container(
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
                        request.serviceType,
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
                    icon: Icons.calendar_today_outlined,
                    label: _fmtDate(request.eventDate),
                    color: AppColors.terracotta),
                InfoPill(
                    icon: Icons.payments_outlined,
                    label: request.budgetRange,
                    color: AppColors.warmGold),
              ],
            ),
            if (request.dietaryRestrictions.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: request.dietaryRestrictions
                    .take(4)
                    .map(
                      (diet) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 6),
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
                      ),
                    )
                    .toList(),
              ),
            ],
            if (request.quotedPrice != null) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Quoted price',
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.mutedText)),
                  Text(
                    '\$${request.quotedPrice!.toStringAsFixed(2)}',
                    style: AppTypography.titleMd
                        .copyWith(color: AppColors.terracotta),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    )
        .animate()
        .fade(delay: Duration(milliseconds: index * 90), duration: 260.ms);
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
