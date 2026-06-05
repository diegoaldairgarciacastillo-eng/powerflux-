import 'package:flutter/material.dart';

class AlphabetIndex extends StatelessWidget {
  final ValueChanged<String> onLetterTap;

  const AlphabetIndex({super.key, required this.onLetterTap});

  static const _letters = [
    '⌃', 'O', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
    'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '#',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _letters.map((letter) {
        return Expanded(
          child: GestureDetector(
            onTap: () => onLetterTap(letter),
            child: Container(
              width: 18,
              alignment: Alignment.center,
              child: Text(
                letter,
                style: const TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
