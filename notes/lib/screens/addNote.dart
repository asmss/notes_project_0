import 'package:flutter/material.dart';
import 'package:notes/models/notes.dart';
import 'package:notes/providers/note_provider.dart';
import 'package:notes/service/notification_service.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _content = TextEditingController();
  DateTime? _selectedReminderDate;

  int random() {
    return Random().nextInt(1000000);
  }

  Future<void> _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B4513),
              onPrimary: Color(0xFFFFF8DC),
              surface: Color(0xFFFFF8DC),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF8B4513),
                onPrimary: Color(0xFFFFF8DC),
                surface: Color(0xFFFFF8DC),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedReminderDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5E6D3),
        leading: Container(
          margin: const EdgeInsets.all(8),
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
            icon: const Icon(Icons.arrow_back, color: Color(0xFF8B4513)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          "Yeni Not",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4A3728),
            fontFamily: 'serif',
          ),
        ),
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
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.save, color: Color(0xFFFFF8DC)),
          label: const Text(
            "Kaydet",
            style: TextStyle(
              color: Color(0xFFFFF8DC),
              fontWeight: FontWeight.w600,
              fontFamily: 'serif',
            ),
          ),
          onPressed: () async {
            if (_title.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Lütfen başlık giriniz"),
                  backgroundColor: const Color(0xFF8B4513),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
              return;
            }
            final newNote = Note(
              id: random().toString(),
              title: _title.text,
              content: _content.text,
              isCompleted: false,
              createdAt: DateTime.now(),
            );
            await context.read<NoteProvider>().add_note(newNote);
            if (_selectedReminderDate != null) {
              await NotificationService.scheduleNotification(
                id: newNote.localId,
                title: "📝 Not Hatırlatıcı",
                body: newNote.title,
                scheduledDate: _selectedReminderDate!,
              );
            }
            await context.read<NoteProvider>().allNotes();
            Navigator.pop(context, true);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.rotate(
                angle: -0.01,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8DC),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B4513),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "BAŞLIK",
                            style: TextStyle(
                              color: Color(0xFF8B4513),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              fontFamily: 'serif',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 1,
                        color: const Color(0xFF8B4513).withOpacity(0.2),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A3728),
                          fontFamily: 'serif',
                        ),
                        decoration: const InputDecoration(
                          hintText: "Not başlığını yazın...",
                          hintStyle: TextStyle(
                            color: Color(0xFF9E8B7B),
                            fontFamily: 'serif',
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Transform.rotate(
                angle: 0.01,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFAF0),
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
                            12,
                            (i) => Container(
                              margin: const EdgeInsets.only(bottom: 28),
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
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B4513),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "İÇERİK",
                                style: TextStyle(
                                  color: Color(0xFF8B4513),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  fontFamily: 'serif',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 1,
                            color: const Color(0xFF8B4513).withOpacity(0.2),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _content,
                            maxLines: 12,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4A3728),
                              height: 1.8,
                              fontFamily: 'serif',
                            ),
                            decoration: const InputDecoration(
                              hintText: "Notunuzu buraya yazın...",
                              hintStyle: TextStyle(
                                color: Color(0xFF9E8B7B),
                                fontFamily: 'serif',
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Reminder card
              GestureDetector(
                onTap: _pickDateTime,
                child: Transform.rotate(
                  angle: -0.005,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: _selectedReminderDate == null
                          ? const Color(0xFFFFF5E1)
                          : const Color(0xFFFFEBCD),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _selectedReminderDate == null
                            ? const Color(0xFF8B4513).withOpacity(0.3)
                            : const Color(0xFF8B4513),
                        width: _selectedReminderDate == null ? 1 : 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          offset: const Offset(3, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _selectedReminderDate == null
                                ? const Color(0xFF8B4513).withOpacity(0.1)
                                : const Color(0xFF8B4513),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.alarm,
                            color: _selectedReminderDate == null
                                ? const Color(0xFF8B4513)
                                : const Color(0xFFFFF8DC),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedReminderDate == null
                                    ? "Hatırlatıcı Ayarla"
                                    : "Hatırlatıcı Ayarlandı",
                                style: TextStyle(
                                  color: const Color(0xFF4A3728),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'serif',
                                ),
                              ),
                              if (_selectedReminderDate != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "${_selectedReminderDate!.day}/${_selectedReminderDate!.month}/${_selectedReminderDate!.year} - ${_selectedReminderDate!.hour.toString().padLeft(2, '0')}:${_selectedReminderDate!.minute.toString().padLeft(2, '0')}",
                                  style: const TextStyle(
                                    color: Color(0xFF8B4513),
                                    fontSize: 13,
                                    fontFamily: 'serif',
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (_selectedReminderDate != null)
                          GestureDetector(
                            onTap: () => setState(() => _selectedReminderDate = null),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B4513).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 18,
                                color: Color(0xFF8B4513),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80), 
            ],
          ),
        ),
      ),
    );
  }
}