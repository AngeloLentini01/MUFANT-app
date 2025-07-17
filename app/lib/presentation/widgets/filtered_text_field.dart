import 'package:flutter/material.dart';
import 'package:app/presentation/services/badWords/bad_words_filter_service.dart';

class FilteredTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool autofocus;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextStyle? style;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction? textInputAction;

  const FilteredTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.autofocus = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.decoration,
    this.style,
    this.contentPadding,
    this.textInputAction,
  });

  @override
  State<FilteredTextField> createState() => _FilteredTextFieldState();
}

class _FilteredTextFieldState extends State<FilteredTextField> {
  final BadWordsFilterService _badWordsService = BadWordsFilterService();
  String _lastValidText = '';

  @override
  void initState() {
    super.initState();
    _initializeBadWordsFilter();
  }

  Future<void> _initializeBadWordsFilter() async {
    await _badWordsService.initialize();
  }

  Future<void> _checkAndFilterText(String text) async {
    if (text == _lastValidText) return;

    final containsBadWords = await _badWordsService.containsBadWords(text);

    if (containsBadWords) {
      final badWords = await _badWordsService.getBadWords(text);

      // Revert to last valid text
      if (widget.controller != null) {
        widget.controller!.text = _lastValidText;
        widget.controller!.selection = TextSelection.fromPosition(
          TextPosition(offset: _lastValidText.length),
        );
      }

      // Show alert
      if (mounted) {
        _badWordsService.showBadWordsAlert(context, badWords);
      }
    } else {
      _lastValidText = text;
      if (widget.onChanged != null) {
        widget.onChanged!(text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      style: widget.style,
      decoration:
          widget.decoration ??
          InputDecoration(
            hintText: widget.hintText,
            labelText: widget.labelText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            contentPadding: widget.contentPadding,
          ),
      onChanged: _checkAndFilterText,
      onSubmitted: widget.onSubmitted,
      textInputAction: widget.textInputAction,
    );
  }
}
