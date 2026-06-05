import 'package:flutter/material.dart';

class SongListItem extends StatelessWidget {
  final String title;
  final String artist;
  final String duration;
  final String format;
  final bool isPlaying;
  final bool isSelected;
  final bool selectionMode;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const SongListItem({
    super.key,
    required this.title,
    required this.artist,
    required this.duration,
    required this.format,
    this.isPlaying = false,
    this.isSelected = false,
    this.selectionMode = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: isPlaying
              ? const Color(0xFF2A2A2A)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              // Portada / checkbox
              Stack(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF2A2A2A),
                    ),
                    child: const Icon(Icons.music_note,
                        color: Color(0xFF555555), size: 24),
                  ),
                  if (selectionMode)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              border: Border.all(
                                  color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: isSelected
                                ? const Icon(Icons.check,
                                    color: Colors.black, size: 14)
                                : null,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isPlaying
                            ? Colors.white
                            : const Color(0xFFEEEEEE),
                        fontSize: 14,
                        fontWeight: isPlaying
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      artist,
                      style: const TextStyle(
                          color: Color(0xFF888888), fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.music_note,
                            color: Color(0xFF666666), size: 10),
                        const SizedBox(width: 3),
                        Text(
                          '$duration | $format',
                          style: const TextStyle(
                              color: Color(0xFF666666), fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
