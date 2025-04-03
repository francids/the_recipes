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
        maxLines: decoration.maxLines,
        minLines: decoration.minLines,
        initialValue: initialValue,
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

  const ModernFormFieldDecoration({
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.focusNode,
    this.autofocus = false,
    this.customEnabledBorder,
    this.customFocusedBorder,
    this.customErrorBorder,
  });

  InputDecoration buildInputDecoration(BuildContext context, String hintText) {
    final theme = Theme.of(context);

    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: theme.colorScheme.surface,
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
