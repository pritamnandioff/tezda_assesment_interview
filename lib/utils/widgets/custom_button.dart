import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  final String text;
  final bool isLoading;
  final int? errorCode;
  final VoidCallback? onPressed;
  const CustomElevatedButton(
      {super.key,
      required this.text,
      required this.isLoading,
      this.errorCode,
      this.onPressed});

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  void _handleOnPressed() {
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.isLoading ? null : _handleOnPressed,
      child: widget.isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : Text(widget.text),
    );
  }
}
