import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/models/order_model.dart';
import '../../../../../shared/widgets/status_badge.dart';
import '../../../../../shared/widgets/common_widgets.dart';

class TrackOrderScreen extends StatefulWidget {
  final String orderId;

  const TrackOrderScreen({super.key, required this.orderId});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> with SingleTickerProviderStateMixin {
  late AnimationController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = MockData.orders.firstWhere(
      (o) => o.id == widget.orderId,
      orElse: () => MockData.orders.first,
    );

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.oliveGreen),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Track Order: ${order.orderNumber}',
          style: AppTypography.headingMd.copyWith(color: AppColors.oliveGreen),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding, vertical: AppSpacing.lg),
          children: [
            _LiveStatusHeader(order: order),
            const SizedBox(height: AppSpacing.lg),
            _LiveRouteMap(status: order.status, animation: _mapController),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(title: 'Delivery Progress'),
            const SizedBox(height: AppSpacing.md),
            _VerticalTimeline(order: order),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(title: 'Order Details'),
            const SizedBox(height: AppSpacing.md),
            _OrderSummaryCard(order: order),
            const SizedBox(height: AppSpacing.huge),
          ],
        ),
      ),
    );
  }
}

class _LiveStatusHeader extends StatelessWidget {
  final OrderModel order;

  const _LiveStatusHeader({required this.order});

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
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.status == 'delivered' ? 'Delivered successfully' : 'On its way',
                  style: AppTypography.titleLg.copyWith(color: AppColors.oliveGreen),
                ),
                const SizedBox(height: 4),
                Text(
                  order.status == 'delivered'
                      ? 'Arrived at ${order.deliveryTime}'
                      : 'Estimated delivery: ${order.deliveryTime ?? "12:30 PM"}',
                  style: AppTypography.bodySm.copyWith(color: AppColors.mutedText),
                ),
              ],
            ),
          ),
          StatusBadge.fromStatus(order.status, size: BadgeSize.medium),
        ],
      ),
    );
  }
}

class _LiveRouteMap extends StatelessWidget {
  final String status;
  final Animation<double> animation;

  const _LiveRouteMap({required this.status, required this.animation});

  @override
  Widget build(BuildContext context) {
    final double progress;
    switch (status) {
      case 'pending':
        progress = 0.05;
        break;
      case 'confirmed':
        progress = 0.25;
        break;
      case 'preparing':
        progress = 0.50;
        break;
      case 'out_for_delivery':
        progress = 0.75;
        break;
      case 'delivered':
        progress = 1.0;
        break;
      default:
        progress = 0.1;
    }

    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.white.withAlpha(180)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.ambientShadow,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Stack(
          children: [
            // Abstract grid map design
            Positioned.fill(
              child: Opacity(
                opacity: 0.08,
                child: CustomPaint(
                  painter: _GridMapPainter(),
                ),
              ),
            ),
            // Custom Route Path
            Positioned.fill(
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _RoutePainter(progress: progress, animVal: animation.value),
                  );
                },
              ),
            ),
            // Floating delivery message indicator
            if (status == 'out_for_delivery')
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.oliveGreen,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.flash_on_rounded, color: AppColors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Driver is 3 mins away',
                        style: AppTypography.caption.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ).animate().fade().scale(),
              ),
          ],
        ),
      ),
    );
  }
}

class _GridMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.charcoal
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw grid roads
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double j = 0; j < size.height; j += 40) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoutePainter extends CustomPainter {
  final double progress;
  final double animVal;

  _RoutePainter({required this.progress, required this.animVal});

  @override
  void paint(Canvas canvas, Size size) {
    final startPt = Offset(size.width * 0.15, size.height * 0.5);
    final controlPt1 = Offset(size.width * 0.4, size.height * 0.25);
    final controlPt2 = Offset(size.width * 0.6, size.height * 0.75);
    final endPt = Offset(size.width * 0.85, size.height * 0.5);

    // Draw full road path background
    final roadPaint = Paint()
      ..color = AppColors.softBorder
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(startPt.dx, startPt.dy)
      ..cubicTo(controlPt1.dx, controlPt1.dy, controlPt2.dx, controlPt2.dy, endPt.dx, endPt.dy);

    canvas.drawPath(path, roadPaint);

    // Draw active progress path
    final activePaint = Paint()
      ..color = AppColors.oliveGreen
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Compute progress subpath
    final pms = path.computeMetrics();
    for (final pm in pms) {
      final subPath = pm.extractPath(0, pm.length * progress);
      canvas.drawPath(subPath, activePaint);

      // Draw pulsating driver location on the progress edge
      if (progress > 0 && progress < 1) {
        final tangent = pm.getTangentForOffset(pm.length * progress);
        if (tangent != null) {
          final pos = tangent.position;
          final pulsePaint = Paint()
            ..color = AppColors.oliveGreen.withAlpha((70 * (1 - animVal)).toInt())
            ..style = PaintingStyle.fill;
          canvas.drawCircle(pos, 16.0 * animVal, pulsePaint);

          final pinPaint = Paint()
            ..color = AppColors.oliveGreen
            ..style = PaintingStyle.fill;
          canvas.drawCircle(pos, 6.0, pinPaint);
        }
      }
    }

    // Draw start node marker (Restaurant)
    final startNodePaint = Paint()
      ..color = AppColors.terracotta
      ..style = PaintingStyle.fill;
    canvas.drawCircle(startPt, 8.0, startNodePaint);

    // Draw end node marker (Destination)
    final endNodePaint = Paint()
      ..color = AppColors.oliveGreen
      ..style = PaintingStyle.fill;
    canvas.drawCircle(endPt, 8.0, endNodePaint);
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.animVal != animVal;
  }
}

class _VerticalTimeline extends StatelessWidget {
  final OrderModel order;

  const _VerticalTimeline({required this.order});

  static const _steps = [
    ('pending', 'Order Received', 'Your request has been sent to our kitchen team.'),
    ('confirmed', 'Order Confirmed', 'The kitchen has accepted your request and scheduled prep.'),
    ('preparing', 'Meals Preparing', 'Our culinary team is hand-crafting your meal boxes.'),
    ('out_for_delivery', 'Out for Delivery', 'The dispatcher has collected your boxes and is driving.'),
    ('delivered', 'Delivered', 'The boxes have been dropped off at your company workspace.'),
  ];

  @override
  Widget build(BuildContext context) {
    final activeIndex = _steps.indexWhere((s) => s.$1 == order.status);
    final clampedIdx = activeIndex == -1 ? 0 : activeIndex;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.white.withAlpha(180)),
      ),
      child: Column(
        children: List.generate(_steps.length, (i) {
          final step = _steps[i];
          final completed = i <= clampedIdx;
          final isCurrent = i == clampedIdx;
          final isLast = i == _steps.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: completed ? AppColors.oliveGreen : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: completed ? AppColors.oliveGreen : AppColors.softBorder,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        completed ? Icons.check_rounded : Icons.circle_outlined,
                        size: 14,
                        color: completed ? AppColors.white : AppColors.mutedText,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: i < clampedIdx ? AppColors.oliveGreen : AppColors.softBorder,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.$2,
                          style: AppTypography.titleSm.copyWith(
                            color: isCurrent ? AppColors.oliveGreen : (completed ? AppColors.charcoal : AppColors.mutedText),
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          step.$3,
                          style: AppTypography.bodySm.copyWith(color: AppColors.mutedText),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  final OrderModel order;

  const _OrderSummaryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.white.withAlpha(180)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  children: [
                    Text(
                      '${item.quantity} x ',
                      style: AppTypography.titleSm.copyWith(color: AppColors.oliveGreen),
                    ),
                    Expanded(
                      child: Text(
                        item.mealName,
                        style: AppTypography.bodySm,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '\$${item.subtotal.toStringAsFixed(2)}',
                      style: AppTypography.labelSm,
                    ),
                  ],
                ),
              )),
          const Divider(color: AppColors.softBorder),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: AppTypography.bodySm.copyWith(color: AppColors.mutedText)),
              Text('\$${order.subtotal.toStringAsFixed(2)}', style: AppTypography.bodySm),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery Fee', style: AppTypography.bodySm.copyWith(color: AppColors.mutedText)),
              Text('\$${order.deliveryFee.toStringAsFixed(2)}', style: AppTypography.bodySm),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tax', style: AppTypography.bodySm.copyWith(color: AppColors.mutedText)),
              Text('\$${order.tax.toStringAsFixed(2)}', style: AppTypography.bodySm),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.softBorder),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTypography.titleSm),
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: AppTypography.titleMd.copyWith(color: AppColors.terracotta),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
