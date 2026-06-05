import 'package:flutter/material.dart';
import 'shared/library_options_menu.dart';
import 'all_songs_screen.dart';
import 'folders_screen.dart';
import 'folder_tree_screen.dart';
import 'albums_screen.dart';
import 'artists_screen.dart';
import 'album_artists_screen.dart';
import 'genres_screen.dart';
import 'years_screen.dart';
import 'composers_screen.dart';
import 'playlists_screen.dart';
import 'streams_screen.dart';
import 'queue_screen.dart';
import 'favorites_screen.dart';
import 'most_played_screen.dart';
import 'top_rated_screen.dart';
import 'worst_rated_screen.dart';
import 'recently_played_screen.dart';
import 'recently_added_screen.dart';
import 'long_tracks_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = _libraryItems(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  const Text(
                    'Biblioteca',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => LibraryOptionsMenu.show(
                      context,
                      title: 'Biblioteca',
                      icon: Icons.library_music,
                    ),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF444444)),
                      ),
                      child: const Icon(
                        Icons.more_vert,
                        color: Color(0xFFAAAAAA),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Lista de categorías
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) => _LibraryTile(item: items[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_LibraryItem> _libraryItems(BuildContext context) => [
    _LibraryItem(
      color: const Color(0xFF5B6EAE),
      icon: Icons.music_note,
      label: 'Todas las canciones',
      onTap: () => _push(context, const AllSongsScreen()),
    ),
    _LibraryItem(
      color: const Color(0xFF3A7BD5),
      icon: Icons.folder,
      label: 'Carpetas',
      onTap: () => _push(context, const FoldersScreen()),
    ),
    _LibraryItem(
      color: const Color(0xFF3A7BD5),
      icon: Icons.account_tree,
      label: 'Estructura de carpetas',
      onTap: () => _push(context, const FolderTreeScreen()),
    ),
    _LibraryItem(
      color: const Color(0xFF6A5ACD),
      icon: Icons.album,
      label: 'Álbumes',
      onTap: () => _push(context, const AlbumsScreen()),
    ),
    _LibraryItem(
      color: const Color(0xFF7B4FAE),
      icon: Icons.mic,
      label: 'Artistas',
      onTap: () => _push(context, const ArtistsScreen()),
    ),
    _LibraryItem(
      color: const Color(0xFF8B4FAE),
      icon: Icons.person,
      label: 'Artistas del álbum',
      onTap: () => _push(context, const AlbumArtistsScreen()),
    ),
    _LibraryItem(
      color: const Color(0xFF9B3FAE),
      icon: Icons.music_note_outlined,
      label: 'Géneros',
      onTap: () => _push(context, const GenresScreen()),
    ),
    _LibraryItem(
      color: const Color(0xFF2AA8B0),
      icon: Icons.calendar_today,
      label: 'Años',
      onTap: () => _push(context, const YearsScreen()),
    ),
    _LibraryItem(
      color: const Color(0xFF2D8A5E),
      icon: Icons.person_outline,
      label: 'Compositores',
      onTap: () => _push(context, const ComposersScreen()),
    ),
    _LibraryItem(
      color: const Color(0xFF8B4A3A),
      icon: Icons.queue_music,
      label: 'Listas de reproducción',
      onTap: () => _push(context, const PlaylistsScreen()),
    ),
    _LibraryItem(
      color: const Color(0xFF2D7A5E),
      icon: Icons.radio,
      label: 'Transmisiones',
      onTap: () => _push(context, const StreamsScreen()),
    ),
    _LibraryItem(
      color: const Color(0xFF8B7A2A),
      icon: Icons.fast_forward,
      label: 'Cola',
      badge: '1/1',
      onTap: () => _push(context, const QueueScreen()),
    ),
    _LibraryItem(
      color: const Color(0xFF2A5BD5),
      icon: Icons.bookmark,
      label: 'Favoritos',
      onTap: () => _push(context, const FavoritesScreen()),
    ),
    _LibraryItem(
      color: const Color(0xFF8B3FAE),
      icon: Icons.play_circle,
      label: 'Lo más reproducido',
      onTap: () => _push(context, const MostPlayedScreen()),
    ),
    _LibraryItem(
      color: const Color(0xFF6A6A6A),
      icon: Icons.thumb_up,
      label: 'Mejor puntuado',
      onTap: () => _push(context, const TopRatedScreen()),
    ),
    _LibraryItem(
      color: const Color(0xFF4A4A4A),
      icon: Icons.thumb_down,
      label: 'Peor puntuado',
      onTap: () => _push(context, const WorstRatedScreen()),
    ),
    _LibraryItem(
      color: const Color(0xFF5B4ACD),
      icon: Icons.play_circle_outline,
      label: 'Reproducido recientemente',
      onTap: () => _push(context, const RecentlyPlayedScreen()),
    ),
    _LibraryItem(
      color: const Color(0xFF2A7A3A),
      icon: Icons.add_circle_outline,
      label: 'Agregado recientemente',
      onTap: () => _push(context, const RecentlyAddedScreen()),
    ),
    _LibraryItem(
      color: const Color(0xFF6A3ACD),
      icon: Icons.more_horiz,
      label: 'Pistas largas',
      onTap: () => _push(context, const LongTracksScreen()),
    ),
  ];

  void _push(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _LibraryItem {
  final Color color;
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback onTap;

  _LibraryItem({
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
  });
}

class _LibraryTile extends StatelessWidget {
  final _LibraryItem item;

  const _LibraryTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
        child: Icon(item.icon, color: Colors.white, size: 22),
      ),
      title: Row(
        children: [
          Text(
            item.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (item.badge != null) ...[
            const SizedBox(width: 8),
            Text(
              item.badge!,
              style: const TextStyle(color: Color(0xFF888888), fontSize: 13),
            ),
          ],
        ],
      ),
      onTap: item.onTap,
    );
  }
}
