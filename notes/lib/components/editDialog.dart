import 'package:flutter/material.dart';
import 'package:notes/models/notes.dart';
import 'package:notes/providers/note_provider.dart';
import 'package:provider/provider.dart';

void showEditDialog(BuildContext context, Note note) {
  final TextEditingController titleController = TextEditingController(text: note.title);
  final TextEditingController contentController = TextEditingController(text: note.content);

  const Color primaryBlue = Color(0xFF0A1128);
  const Color accentBlue = Color(0xFF1D71BA);
  const Color paperColor = Colors.white;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent, 
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.rotate(
                angle: -0.02,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: paperColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: titleController,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Başlık",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.title, color: accentBlue),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              Transform.rotate(
                angle: 0.01,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: paperColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(-4, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: contentController,
                        maxLines: 8,
                        style: const TextStyle(fontSize: 16, color: primaryBlue, height: 1.5),
                        decoration: const InputDecoration(
                          hintText: "Notunuzu buraya yazın...",
                          border: InputBorder.none,
                        ),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("İptal", style: TextStyle(color: Colors.grey.shade600)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.check, size: 18),
                            label: const Text("Güncelle"),
                            onPressed: () {
                              note.title = titleController.text;
                              note.content = contentController.text;
                              context.read<NoteProvider>().update_note(note, titleController.text, contentController.text);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}