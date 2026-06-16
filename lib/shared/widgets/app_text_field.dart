import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool autofocus;
  final String? initialValue;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.prefixIcon,
    this.suffix,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.onTap,
    this.autofocus = false,
    this.initialValue,
    this.focusNode,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _ownsFocusNode = false;
  bool _obscured = true;

  @override
  void initState() {
    super.initState();
    _setupFocusNode();
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_handleFocusChanged);
      if (_ownsFocusNode) _focusNode.dispose();
      _setupFocusNode();
    }
  }

  void _setupFocusNode() {
    _focusNode = widget.focusNode ?? FocusNode();
    _ownsFocusNode = widget.focusNode == null;
    _focusNode.addListener(_handleFocusChanged);
  }

  void _handleFocusChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.input),
        boxShadow: _focusNode.hasFocus
            ? [
                BoxShadow(
                  color: AppColors.oliveGreen.withAlpha(28),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                const BoxShadow(
                  color: AppColors.ambientShadow,
                  blurRadius: 14,
                  offset: Offset(0, 8),
                ),
              ],
      ),
      child: TextFormField(
        controller: widget.controller,
        initialValue: widget.controller == null ? widget.initialValue : null,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        obscureText: widget.obscureText && _obscured,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        autofocus: widget.autofocus,
        focusNode: _focusNode,
        style: AppTypography.bodyMd.copyWith(color: AppColors.charcoal),
        cursorColor: AppColors.oliveGreen,
        decoration: _decoration(
          label: widget.label,
          hint: widget.hint,
          prefixIcon: widget.prefixIcon,
          suffixIcon: _suffixIcon,
        ),
      ),
    );
  }

  Widget? get _suffixIcon {
    if (!widget.obscureText) return widget.suffix;
    return IconButton(
      icon: Icon(
        _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 20,
        color: AppColors.mutedText,
      ),
      onPressed: () => setState(() => _obscured = !_obscured),
    );
  }
}

class AppTextArea extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? maxLength;
  final void Function(String)? onChanged;
  final String? initialValue;

  const AppTextArea({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.maxLines = 4,
    this.maxLength,
    this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      hint: hint,
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      initialValue: initialValue,
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
    );
  }
}

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final IconData? prefixIcon;
  final String? hint;

  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.prefixIcon,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.input),
        boxShadow: const [
          BoxShadow(
            color: AppColors.ambientShadow,
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        items: items,
        onChanged: onChanged,
        validator: validator,
        style: AppTypography.bodyMd.copyWith(color: AppColors.charcoal),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.mutedText,
        ),
        decoration: _decoration(
          label: label,
          hint: hint,
          prefixIcon: prefixIcon,
        ),
        dropdownColor: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );
  }
}

InputDecoration _decoration({
  required String label,
  String? hint,
  IconData? prefixIcon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    counterText: '',
    filled: true,
    fillColor: AppColors.warmIvory,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.lg,
    ),
    prefixIcon: prefixIcon != null
        ? Icon(prefixIcon, size: 20, color: AppColors.mutedText)
        : null,
    suffixIcon: suffixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: const BorderSide(color: AppColors.softBorder, width: 1.2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: const BorderSide(color: AppColors.softBorder, width: 1.2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: const BorderSide(color: AppColors.oliveGreen, width: 1.6),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: const BorderSide(color: AppColors.errorRed, width: 1.4),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: const BorderSide(color: AppColors.errorRed, width: 1.6),
    ),
    labelStyle: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
    hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
    errorStyle: AppTypography.bodySm.copyWith(color: AppColors.errorRed),
    prefixIconColor: AppColors.mutedText,
    suffixIconColor: AppColors.mutedText,
  );
}

class PremiumTextField extends AppTextField {
  const PremiumTextField({
    super.key,
    required super.label,
    super.hint,
    super.controller,
    super.validator,
    super.keyboardType = TextInputType.text,
    super.textInputAction = TextInputAction.next,
    super.obscureText = false,
    super.prefixIcon,
    super.suffix,
    super.maxLines = 1,
    super.maxLength,
    super.inputFormatters,
    super.onChanged,
    super.onSubmitted,
    super.readOnly = false,
    super.onTap,
    super.autofocus = false,
    super.initialValue,
    super.focusNode,
  });
}
