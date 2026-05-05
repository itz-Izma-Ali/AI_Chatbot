import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SuggestionsBar extends StatelessWidget {
  final void Function(String) onTap;
  const SuggestionsBar({super.key, required this.onTap});

  static const _suggestions = ['Tell me more', 'Give an example', 'Explain differently'];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _suggestions
              .map(
                (s) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Material(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => onTap(s),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: colors.border, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          s,
                          style: TextStyle(fontSize: 14, color: colors.textPrimary),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
