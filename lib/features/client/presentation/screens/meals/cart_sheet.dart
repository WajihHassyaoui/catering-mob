import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/models/order_model.dart';
import '../../providers/client_providers.dart';
import '../../providers/profile_providers.dart';

/// Shows the shopping cart as a modal bottom sheet.
void showCartSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _CartSheet(),
  );
}

/// A tappable cart (panier) icon with a live item-count badge.
///
/// Watches [cartProvider] so the badge updates the moment a meal is added, and
/// opens the cart sheet on tap so the order can be managed from anywhere in the
/// meals section. Use [flat] for a borderless, shadowless variant (e.g. over an
/// app-bar image) and the colour overrides to match the surrounding surface.
class CartIconButton extends ConsumerWidget {
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final bool flat;

  const CartIconButton({
    super.key,
    this.backgroundColor,
    this.iconColor,
    this.size = 46,
    this.flat = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final totalItems = cart.fold(0, (s, c) => s + c.quantity);

    return GestureDetector(
      onTap: () => showCartSheet(context, ref),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.warmIvory,
              shape: BoxShape.circle,
              border: flat ? null : Border.all(color: AppColors.softBorder),
              boxShadow: flat
                  ? null
                  : const [
                      BoxShadow(
                        color: AppColors.ambientShadow,
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
            ),
            child: Icon(
              totalItems > 0
                  ? Icons.shopping_cart_rounded
                  : Icons.shopping_cart_outlined,
              color: iconColor ?? AppColors.oliveGreen,
              size: size * 0.46,
            ),
          ),
          if (totalItems > 0)
            Positioned(
              right: -3,
              top: -3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.terracotta,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppColors.creamBackground, width: 2),
                ),
                child: Text(
                  totalItems > 99 ? '99+' : '$totalItems',
                  textAlign: TextAlign.center,
                  style: AppTypography.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    height: 1.1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CartSheet extends ConsumerWidget {
  const _CartSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    const deliveryFee = 5.0;
    final subtotal = cart.fold(0.0, (s, c) => s + c.subtotal);
    final tax = subtotal * 0.08;
    final total = subtotal + deliveryFee + tax;

    final screenH = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxHeight: screenH * 0.88),
      decoration: const BoxDecoration(
        color: AppColors.creamBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──
            const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.softBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // ── Header ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart_outlined, color: AppColors.oliveGreen),
                const SizedBox(width: 10),
                Text(
                  'My Cart',
                  style: AppTypography.displayMedium.copyWith(fontSize: 22),
                ),
                const Spacer(),
                if (cart.isNotEmpty)
                  TextButton(
                    onPressed: () => ref.read(cartProvider.notifier).clear(),
                    child: Text(
                      'Clear all',
                      style: AppTypography.labelSm.copyWith(color: AppColors.terracotta),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ── Body ──
          if (cart.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Column(
                children: [
                  const Icon(Icons.shopping_cart_outlined,
                      size: 56, color: AppColors.mutedText),
                  const SizedBox(height: 16),
                  Text('Your cart is empty',
                      style: AppTypography.titleMd
                          .copyWith(color: AppColors.mutedText)),
                  const SizedBox(height: 6),
                  Text('Browse meals and tap "Add to cart"',
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.mutedText)),
                ],
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pagePadding, vertical: 8),
                itemCount: cart.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: AppColors.softBorder, height: 1),
                itemBuilder: (_, i) => _CartItemRow(item: cart[i]),
              ),
            ),

          // ── Price summary + checkout ──
          if (cart.isNotEmpty) ...[
            const Divider(color: AppColors.softBorder, thickness: 1),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.md,
                AppSpacing.pagePadding,
                MediaQuery.of(context).padding.bottom + AppSpacing.lg,
              ),
              child: Column(
                children: [
                  _PriceLine(label: 'Subtotal', value: subtotal),
                  const SizedBox(height: 4),
                  const _PriceLine(label: 'Delivery fee', value: deliveryFee),
                  const SizedBox(height: 4),
                  _PriceLine(
                      label: 'Tax (8%)',
                      value: tax,
                      valueStyle: AppTypography.bodySm
                          .copyWith(color: AppColors.mutedText)),
                  const SizedBox(height: 10),
                  const Divider(color: AppColors.softBorder),
                  const SizedBox(height: 6),
                  _PriceLine(
                    label: 'Total',
                    value: total,
                    labelStyle: AppTypography.titleMd,
                    valueStyle: AppTypography.titleMd.copyWith(
                      color: AppColors.oliveGreen,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.oliveGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.check_circle_outline_rounded),
                      label: Text(
                        'Place Order — \$${total.toStringAsFixed(2)}',
                        style: AppTypography.labelMd
                            .copyWith(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () {
                        final currentCart = List<CartItem>.from(cart);
                        Navigator.pop(context);
                        // Use a post-frame callback so Navigator.pop settles
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (context.mounted) {
                            placeCartOrder(
                              ref,
                              context,
                              currentCart,
                            );
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Individual cart row ────────────────────────────────────────────────────────

class _CartItemRow extends ConsumerWidget {
  final CartItem item;
  const _CartItemRow({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Meal image / icon
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: item.mealImageUrl != null
                ? Image.network(
                    item.mealImageUrl!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 12),
          // Name + unit price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.mealName,
                  style: AppTypography.labelMd,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '\$${item.unitPrice.toStringAsFixed(2)} each',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.mutedText),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Quantity stepper
          _QuantityStepper(
            quantity: item.quantity,
            onDecrement: () =>
                ref.read(cartProvider.notifier).decrement(item.mealId),
            onIncrement: () =>
                ref.read(cartProvider.notifier).increment(item.mealId),
          ),
          const SizedBox(width: 12),
          // Line total
          SizedBox(
            width: 60,
            child: Text(
              '\$${item.subtotal.toStringAsFixed(2)}',
              style: AppTypography.labelMd
                  .copyWith(color: AppColors.oliveGreen),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        width: 56,
        height: 56,
        color: AppColors.oliveLight,
        child: const Icon(Icons.restaurant_rounded,
            color: AppColors.oliveGreen, size: 24),
      );
}

// ── Quantity stepper widget ────────────────────────────────────────────────────

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityStepper({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.softBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBtn(icon: Icons.remove_rounded, onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$quantity',
              style: AppTypography.labelMd,
            ),
          ),
          _StepBtn(icon: Icons.add_rounded, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 18, color: AppColors.oliveGreen),
      ),
    );
  }
}

// ── Price summary row ──────────────────────────────────────────────────────────

class _PriceLine extends StatelessWidget {
  final String label;
  final double value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const _PriceLine({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelStyle ??
              AppTypography.bodySm.copyWith(color: AppColors.mutedText),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: valueStyle ??
              AppTypography.bodySm.copyWith(color: AppColors.charcoal),
        ),
      ],
    );
  }
}
