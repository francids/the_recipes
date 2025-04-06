import "package:flutter/material.dart";

class ModernFormField extends StatelessWidget {
  final String hintText;
  final String initialValue;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final ModernFormFieldDecoration decoration;
  final TextInputAction? textInputAction;
  final bool? expands;

  const ModernFormField({
    Key? key,
    required this.hintText,
    this.initialValue = "",
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.decoration = const ModernFormFieldDecoration(),
    this.textInputAction,
    this.expands,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        focusNode: decoration.focusNode,
        autofocus: decoration.autofocus,
        keyboardType: keyboardType,
        obscureText: obscureText,
        // Establecer maxLines a null permite que el campo crezca indefinidamente
        maxLines: decoration.wrapText ? null : 1,
        minLines: decoration.minLines,
        expands: expands ?? false,
        textInputAction: textInputAction,
        initialValue: controller == null ? initialValue : null,
        onChanged: onChanged,
        validator: validator,
        style: theme.textTheme.bodyMedium,
        decoration: decoration.buildInputDecoration(context, hintText),
      ),
    );
  }
}

class ModernFormFieldDecoration {
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final bool autofocus;
  final InputBorder? customEnabledBorder;
  final InputBorder? customFocusedBorder;
  final InputBorder? customErrorBorder;
  final bool wrapText;
  final Color? fillColor;

  const ModernFormFieldDecoration({
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    // El valor predeterminado de maxLines ahora es null para permitir expansión
    this.maxLines,
    this.minLines = 1,
    this.focusNode,
    this.autofocus = false,
    this.customEnabledBorder,
    this.customFocusedBorder,
    this.customErrorBorder,
    this.wrapText = true,
    this.fillColor,
  });

  InputDecoration buildInputDecoration(BuildContext context, String hintText) {
    final theme = Theme.of(context);

    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: fillColor ?? theme.colorScheme.surface,
      isCollapsed: !wrapText,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: customEnabledBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withAlpha(128),
              width: 1.0,
            ),
          ),
      focusedBorder: customFocusedBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2.0,
            ),
          ),
      errorBorder: customErrorBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 1.0,
            ),
          ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: theme.colorScheme.error,
          width: 2.0,
        ),
      ),
      errorStyle: TextStyle(
        color: theme.colorScheme.error,
        fontSize: 12.0,
      ),
    );
  }
}
