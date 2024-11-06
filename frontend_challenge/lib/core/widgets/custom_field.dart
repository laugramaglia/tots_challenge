import 'package:flutter/material.dart';
import 'package:frontend_challenge/core/extensions/context.dart';

enum TextValidator { required, email }

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isObscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final List<TextValidator> validators;

  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.readOnly = false,
    this.suffixIcon,
    this.contentPadding,
    this.validators = const [],
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      cursorColor: context.colorScheme.primary,
      style: context.textTheme.bodyLarge,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        suffixIcon: suffixIcon,
        hintText: hintText,
      ),
      validator: _validator,
      obscureText: isObscureText,
    );
  }

  String? _validator(String? value) {
    if (validators.isNotEmpty) {
      for (final validator in validators) {
        switch (validator) {
          case TextValidator.required:
            if (value == null || value.isEmpty) {
              return "$hintText is missing!";
            }
            break;

          case TextValidator.email:
            if (value != null && value.isNotEmpty) {
              final emailRegex =
                  RegExp(r'^[\w\.\-]+@[a-zA-Z\d\-]+\.[a-zA-Z]{2,}$');
              if (!emailRegex.hasMatch(value)) {
                return "Please enter a valid email address";
              }
            }
            break;
        }
      }
    }
    return null;
  }
}
