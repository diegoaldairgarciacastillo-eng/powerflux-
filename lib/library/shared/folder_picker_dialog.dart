import 'package:flutter/material.dart';

class FolderPickerDialog extends StatefulWidget {
  const FolderPickerDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const FolderPickerDialog(),
    );
  }

  @override
  State<FolderPickerDialog> createState() => _FolderPickerDialogState();
}

class _FolderPickerDialogState extends State<FolderPickerDialog> {
  final List<_FolderEntry> _folders = [
    _FolderEntry(name: 'Music', device: 'RMX3890', isSelected: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2A2A2A),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Selección de carpetas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Lista de carpetas
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: _folders.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text('No hay carpetas',
                            style:
                                TextStyle(color: Color(0xFF666666))),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _folders.length,
                      itemBuilder: (_, i) => _FolderRow(
                        entry: _folders[i],
                        onToggle: () => setState(
                            () => _folders[i].isSelected =
                                !_folders[i].isSelected),
                        onRemove: () =>
                            setState(() => _folders.removeAt(i)),
                      ),
                    ),
            ),
            const Divider(color: Color(0xFF3A3A3A), height: 1),
            // Botón agregar
            _DialogButton(
              label: 'Agregar carpeta o almacenamiento',
              onTap: () {},
            ),
            const Divider(color: Color(0xFF3A3A3A), height: 1),
            // Botón guardar
            _DialogButton(
              label: 'Guardar y escanear',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _FolderEntry {
  final String name;
  final String device;
  bool isSelected;

  _FolderEntry(
      {required this.name,
      required this.device,
      required this.isSelected});
}

class _FolderRow extends StatelessWidget {
  final _FolderEntry entry;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  const _FolderRow(
      {required this.entry,
      required this.onToggle,
      required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.play_arrow,
              color: Color(0xFF888888), size: 16),
          const SizedBox(width: 8),
          const Icon(Icons.folder_outlined,
              color: Color(0xFFAAAAAA), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                Text(entry.device,
                    style: const TextStyle(
                        color: Color(0xFF888888), fontSize: 12)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close,
                color: Color(0xFF888888), size: 20),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: entry.isSelected
                    ? Colors.white
                    : Colors.transparent,
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: entry.isSelected
                  ? const Icon(Icons.check,
                      color: Colors.black, size: 16)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DialogButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
