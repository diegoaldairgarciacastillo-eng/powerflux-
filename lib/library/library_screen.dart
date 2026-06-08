import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
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
    final p = context.watch<PlayerProvider>();

    final items = [
      _Item(Icons.music_note_rounded,        'Todas las canciones',       const Color(0xFF5B5BD6), const AllSongsScreen()),
      _Item(Icons.folder_rounded,            'Carpetas',                  const Color(0xFF3B82F6), const FoldersScreen()),
      _Item(Icons.folder_copy_rounded,       'Estructura de carpetas',    const Color(0xFF2563EB), const FolderTreeScreen()),
      _Item(Icons.album_rounded,             'Álbumes',                   const Color(0xFF7C3AED), const AlbumsScreen()),
      _Item(Icons.mic_rounded,               'Artistas',                  const Color(0xFF6D28D9), const ArtistsScreen()),
      _Item(Icons.record_voice_over_rounded, 'Artistas del álbum',        const Color(0xFF7C3AED), const AlbumArtistsScreen()),
      _Item(Icons.library_music_rounded,     'Géneros',                   const Color(0xFF9333EA), const GenresScreen()),
      _Item(Icons.calendar_month_rounded,    'Años',                      const Color(0xFF0891B2), const YearsScreen()),
      _Item(Icons.person_rounded,            'Compositores',              const Color(0xFF059669), const ComposersScreen()),
      _Item(Icons.queue_music_rounded,       'Listas de reproducción',    const Color(0xFF92400E), const PlaylistsScreen()),
      _Item(Icons.wifi_tethering_rounded,    'Transmisiones',             const Color(0xFF047857), const StreamsScreen()),
      _Item(Icons.fast_forward_rounded,      'Cola',                      const Color(0xFFB45309), const QueueScreen()),
      _Item(Icons.bookmark_rounded,          'Favoritos',                 const Color(0xFF1D4ED8), const FavoritesScreen()),
      _Item(Icons.play_circle_rounded,       'Lo más reproducido',        const Color(0xFF7C3AED), const MostPlayedScreen()),
      _Item(Icons.thumb_up_rounded,          'Mejor puntuado',            const Color(0xFF6B7280), const TopRatedScreen()),
      _Item(Icons.thumb_down_rounded,        'Peor puntuado',             const Color(0xFF4B5563), const WorstRatedScreen()),
      _Item(Icons.history_rounded,           'Reproducido recientemente', const Color(0xFF7C3AED), const RecentlyPlayedScreen()),
      _Item(Icons.fiber_new_rounded,         'Agregado recientemente',    const Color(0xFF16A34A), const RecentlyAddedScreen()),
      _Item(Icons.more_time_rounded,         'Pistas largas',             const Color(0xFF6D28D9), const LongTracksScreen()),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Biblioteca',
                      style: TextStyle(color: Colors.white, fontSize: 28,
                          fontWeight: FontWeight.w800)),
                  GestureDetector(
                    onTap: () => LibraryOptionsMenu.show(context,
                        title: 'Biblioteca',
                        icon: Icons.library_music_rounded,
                        iconBgColor: const Color(0xFF5B5BD6),
                        onSelectFolders: () => p.selectFolder()),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF2A2A2A))),
                      child: const Icon(Icons.more_vert_rounded,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),
            // Song count
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text('${p.songs.length} canciones · ${p.musicFolder.split('/').last}',
                  style: const TextStyle(color: Color(0xFF555555), fontSize: 12)),
            ),
            // Loading indicator
            if (p.songs.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text('Toca ⋮ → Seleccionar carpetas para cargar tu música',
                    style: TextStyle(color: Color(0xFF555555), fontSize: 13)),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 8),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  return InkWell(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => item.screen)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(children: [
                        Container(
                          width: 46, height: 46,
                          decoration: BoxDecoration(
                              color: item.color, shape: BoxShape.circle),
                          child: Icon(item.icon, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 16),
                        Text(item.label, style: const TextStyle(
                            color: Colors.white, fontSize: 16,
                            fontWeight: FontWeight.w500)),
                      ]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item {
  final IconData icon; final String label; final Color color; final Widget screen;
  const _Item(this.icon, this.label, this.color, this.screen);
}
