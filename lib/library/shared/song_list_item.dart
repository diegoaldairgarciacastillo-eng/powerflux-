import 'package:flutter/material.dart';

class SongListItem extends StatelessWidget {
  final String title, artist, duration, format;
  final bool isSelected, selectionMode, isPlaying;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const SongListItem({
    super.key,
    required this.title,
    required this.artist,
    required this.duration,
    required this.format,
    this.isSelected = false,
    this.selectionMode = false,
    this.isPlaying = false,
    required this.onTap,
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
          color: isSelected ? const Color(0xFF1C1C1C) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Row(
            children: [
              // Artwork / checkbox
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 56, height: 56,
                      color: const Color(0xFF1A1A1A),
                      child: isPlaying
                          ? const Icon(Icons.equalizer_rounded,
                              color: Color(0xFF39FF14), size: 28)
                          : const Icon(Icons.music_note_rounded,
                              color: Color(0xFF333333), size: 28),
                    ),
                  ),
                  if (selectionMode)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Container(
                            width: 22, height: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.white, width: 1.5),
                              color: isSelected ? Colors.white : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check_rounded, color: Colors.black, size: 16)
                                : null,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isPlaying ? const Color(0xFF39FF14) : Colors.white,
                        fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 3),
                    Text(artist,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFF888888), fontSize: 12)),
                    const SizedBox(height: 3),
                    Row(children: [
                      const Icon(Icons.music_note_rounded, color: Color(0xFF555555), size: 11),
                      const SizedBox(width: 3),
                      Text('$duration | $format',
                          style: const TextStyle(color: Color(0xFF555555), fontSize: 11)),
                    ]),
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
