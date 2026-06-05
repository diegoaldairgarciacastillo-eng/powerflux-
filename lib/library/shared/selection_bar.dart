import 'package:flutter/material.dart';

class SelectionBar extends StatelessWidget {
  final int selectedCount;
  final int totalCount;
  final bool allSelected;
  final VoidCallback onSelectAll;
  final VoidCallback onClose;
  final VoidCallback? onAddToPlaylist;
  final VoidCallback? onAddToQueue;
  final VoidCallback? onPlayNext;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;
  final VoidCallback? onInfo;
  final VoidCallback? onCover;

  const SelectionBar({
    super.key,
    required this.selectedCount,
    required this.totalCount,
    required this.allSelected,
    required this.onSelectAll,
    required this.onClose,
    this.onAddToPlaylist,
    this.onAddToQueue,
    this.onPlayNext,
    this.onDelete,
    this.onShare,
    this.onInfo,
    this.onCover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A1A),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fila superior: checkbox todo, rango, contador, ?, X
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Checkbox Todo
                GestureDetector(
                  onTap: onSelectAll,
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: allSelected
                              ? Colors.white
                              : Colors.transparent,
                          border: Border.all(
                              color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: allSelected
                            ? const Icon(Icons.check,
                                color: Colors.black, size: 14)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      const Text('Todo',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.swap_vert,
                    color: Color(0xFF888888), size: 20),
                const SizedBox(width: 4),
                const Text('Rango',
                    style: TextStyle(
                        color: Color(0xFF888888), fontSize: 13)),
                const Spacer(),
                Text(
                  '$selectedCount / $totalCount',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 13),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.help_outline,
                    color: Color(0xFF888888), size: 20),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(Icons.close,
                      color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          // Fila inferior: acciones
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionBtn(
                  icon: Icons.playlist_add,
                  label: 'Lista de reprod.',
                  onTap: onAddToPlaylist ?? () {},
                ),
                _ActionBtn(
                  icon: Icons.queue_music,
                  label: 'Cola',
                  onTap: onAddToQueue ?? () {},
                ),
                _ActionBtn(
                  icon: Icons.play_arrow_outlined,
                  label: 'Siguiente',
                  onTap: onPlayNext ?? () {},
                ),
                _ActionBtn(
                  icon: Icons.delete_outline,
                  label: 'Eliminar',
                  onTap: onDelete ?? () {},
                  color: const Color(0xFF666666),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionBtn(
                  icon: Icons.share_outlined,
                  label: 'Compartir',
                  onTap: onShare ?? () {},
                ),
                _ActionBtn(
                  icon: Icons.info_outline,
                  label: 'Info/Etiquetas',
                  onTap: onInfo ?? () {},
                ),
                _ActionBtn(
                  icon: Icons.image_outlined,
                  label: 'Carátula',
                  onTap: onCover ?? () {},
                ),
                const SizedBox(width: 60),
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
  final Color color;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
