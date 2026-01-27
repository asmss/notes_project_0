import 'package:flutter/material.dart';
import 'package:notes/components/search.dart';
import 'package:notes/models/notes.dart';
import 'package:notes/providers/note_provider.dart';
import 'package:notes/screens/addNote.dart';
import 'package:provider/provider.dart';
import "package:notes/components/editDialog.dart";

class Notelistpage extends StatefulWidget {
  const Notelistpage({super.key});

  @override
  State<Notelistpage> createState() => _NotelistpageState();
}

class _NotelistpageState extends State<Notelistpage> {
  final List<Color> vintageColors = [
    const Color.fromARGB(255, 218, 236, 213), 
    const Color(0xFFFFFAF0), 
    const Color.fromARGB(255, 170, 133, 59), 
    const Color(0xFFFAF0E6), 
    const Color(0xFFFFFACD), 
    const Color.fromARGB(255, 5, 133, 207), 
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteProvider>().allNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();
    final notes = provider.notes;

    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5E6D3),
        title: provider.isSearchActive
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8DC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF8B4513), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(2, 2),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: TextField(
                  controller: provider.searchController,
                  autofocus: true,
                  style: const TextStyle(
                    color: Color(0xFF4A3728),
                    fontFamily: 'serif',
                  ),
                  decoration: const InputDecoration(
                    hintText: "Ara...",
                    hintStyle: TextStyle(color: Color(0xFF9E8B7B)),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => provider.search(value),
                ),
              )
            : const Text(
                "Notlarım",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4A3728),
                  fontFamily: 'serif',
                ),
              ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8DC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF8B4513), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(2, 2),
                  blurRadius: 3,
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                provider.isSearchActive ? Icons.close : Icons.search,
                color: const Color(0xFF8B4513),
              ),
              onPressed: () {
                provider.toggleSearch();
              },
            ),
          ),
        ],
      ),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF8B4513),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(3, 3),
              blurRadius: 8,
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.edit, size: 28, color: Color(0xFFFFF8DC)),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddNote()),
            );
            if (result == true) {
              context.read<NoteProvider>().allNotes();
            }
          },
        ),
      ),

      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF8B4513)),
            )
          : notes.isEmpty
              ? _emptyState()
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    final color = vintageColors[index % vintageColors.length];
                    return _noteCard(note, color, index);
                  },
                ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8DC),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF8B4513), width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(4, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.article_outlined,
              size: 60,
              color: Color(0xFF8B4513),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Henüz not yok",
            style: TextStyle(
              color: Color(0xFF4A3728),
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'serif',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "İlk notunu yaz",
            style: TextStyle(
              color: Color(0xFF9E8B7B),
              fontSize: 16,
              fontFamily: 'serif',
            ),
          ),
        ],
      ),
    );
  }

  Widget _noteCard(Note note, Color color, int index) {
    final provider = context.read<NoteProvider>();
    final String query = provider.searchController.text;

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 60)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: () => showEditDialog(context, note),
        child: Transform.rotate(
          angle: (index % 2 == 0 ? -0.02 : 0.02),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: const Color(0xFF8B4513).withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  offset: const Offset(3, 3),
                  blurRadius: 6,
                ),
                BoxShadow(
                  color: Colors.brown.withOpacity(0.1),
                  offset: const Offset(-1, -1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: List.generate(
                      8,
                      (i) => Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        height: 1,
                        color: const Color(0xFF8B4513).withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              context.read<NoteProvider>().change_completed(note),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: note.isCompleted
                                  ? const Color(0xFF8B4513)
                                  : Colors.transparent,
                              border: Border.all(
                                color: const Color(0xFF8B4513),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: note.isCompleted
                                ? const Icon(
                                    Icons.check,
                                    color: Color(0xFFFFF8DC),
                                    size: 14,
                                  )
                                : null,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => context.read<NoteProvider>().deleted(note),
                          child: const Icon(
                            Icons.close,
                            color: Color(0xFF8B4513),
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      note.title,
                      style: TextStyle(
                        color: const Color(0xFF4A3728),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'serif',
                        decoration: note.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Text(
                        note.content,
                        style: TextStyle(
                          color: const Color(0xFF6B5447),
                          fontSize: 13,
                          height: 1.5,
                          fontFamily: 'serif',
                          decoration: note.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}