import 'package:flutter/material.dart';

class AlphabetIndex extends StatelessWidget {
  final Function(String) onLetterTap;

  const AlphabetIndex({super.key, required this.onLetterTap});

  static const _letters = [
    '⬆', '#', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
    'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _letters.map((l) {
        return GestureDetector(
          onTap: () => onLetterTap(l),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.5),
            child: Text(
              l,
              style: const TextStyle(
                color: Color(0xFF888888),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
