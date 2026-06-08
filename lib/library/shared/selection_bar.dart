import 'package:flutter/material.dart';

class SelectionBar extends StatelessWidget {
  final int selectedCount;
  final int totalCount;
  final bool allSelected;
  final VoidCallback onSelectAll;
  final VoidCallback onClose;
  final VoidCallback onAddToPlaylist;
  final VoidCallback onAddToQueue;
  final VoidCallback onPlayNext;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final VoidCallback onInfo;
  final VoidCallback onArtwork;

  const SelectionBar({
    super.key,
    required this.selectedCount,
    required this.totalCount,
    required this.allSelected,
    required this.onSelectAll,
    required this.onClose,
    required this.onAddToPlaylist,
    required this.onAddToQueue,
    required this.onPlayNext,
    required this.onDelete,
    required this.onShare,
    required this.onInfo,
    required this.onArtwork,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(top: BorderSide(color: Color(0xFF2A2A2A), width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row — select all / range / count / help / close
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onSelectAll,
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border:
                              Border.all(color: Colors.white, width: 1.5),
                          color: allSelected
                              ? Colors.white
                              : Colors.transparent,
                        ),
                        child: allSelected
                            ? const Icon(Icons.check_rounded,
                                color: Colors.black, size: 16)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      const Text('Todo',
                          style: TextStyle(
                              color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.swap_vert_rounded,
                    color: Color(0xFF888888), size: 20),
                const SizedBox(width: 4),
                const Text('Rango',
                    style: TextStyle(
                        color: Color(0xFF888888), fontSize: 13)),
                const Spacer(),
                Text('$selectedCount / $totalCount',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 13)),
                const SizedBox(width: 12),
                const Icon(Icons.help_outline_rounded,
                    color: Color(0xFF888888), size: 20),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 22),
                ),
              ],
            ),
          ),
          const Divider(
              height: 1, thickness: 0.5, color: Color(0xFF2A2A2A)),
          // Action buttons row 1
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionBtn(
                    icon: Icons.add_rounded,
                    label: 'Lista de reprod.',
                    onTap: onAddToPlaylist),
                _ActionBtn(
                    icon: Icons.fast_forward_rounded,
                    label: 'Cola',
                    onTap: onAddToQueue),
                _ActionBtn(
                    icon: Icons.play_arrow_rounded,
                    label: 'Siguiente',
                    onTap: onPlayNext),
                _ActionBtn(
                    icon: Icons.delete_outline_rounded,
                    label: 'Eliminar',
                    onTap: onDelete),
              ],
            ),
          ),
          // Action buttons row 2
          Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionBtn(
                    icon: Icons.share_outlined,
                    label: 'Compartir',
                    onTap: onShare),
                _ActionBtn(
                    icon: Icons.info_outline_rounded,
                    label: 'Info/Etiquetas',
                    onTap: onInfo),
                _ActionBtn(
                    icon: Icons.image_outlined,
                    label: 'Carátula',
                    onTap: onArtwork),
                const SizedBox(width: 64),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionBtn(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Color(0xFF888888), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
