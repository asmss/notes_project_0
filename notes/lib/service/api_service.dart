import 'dart:convert';
import 'package:notes/models/notes.dart';
import 'package:notes/service/api.dart';

class ApiService {
  final Api api;
  ApiService(this.api);

  Future<List<Note>> fetch_Notes(String userId) async {
    final response = await api.fetchNotes(userId);

    if (response.statusCode != 200) {
      throw Exception("Notlar alınamadı");
    }
    final decoded = jsonDecode(response.body);
    final List list = decoded["notes"] ?? [];

    return list.map((e) => Note.fromJson(e)).toList();
  }

  Future<Note> addNote(Note note, String userId) async {
    final response = await api.addNote(note.toJson(), userId);
    if (response.statusCode < 200 || response.statusCode > 201) {
      throw Exception("Not eklenemedi");
    }
    final decoded = jsonDecode(response.body);
    return Note.fromJson(decoded);
  }

  Future<void> deletedNotes(String noteId, String userId) async {
    final response = await api.deletedNote(noteId, userId);

    if (response.statusCode != 200) {
      throw Exception("Silme işlemi başarısız");
    }
    return jsonDecode(response.body);
  }

  Future<void> change_button(String noteId, String userId) async {
    final response = await api.changeButton(noteId, userId);
    if (response.statusCode != 200) {
      throw Exception("Durum değiştirilemedi");
    }
    return jsonDecode(response.body);
  }

Future<void> updateNote(Note note, String userId) async {
  print("Güncelleme isteği gönderiliyor. ID: ${note.id}, URL: ${api.baseUrl}/update/${note.id}");

  final response = await api.updateNoteRequest(note.id!, note.toJson(), userId);

  if (response.statusCode != 200) {
    print("Backend hata kodu: ${response.statusCode}");
    print("Backend hata gövdesi: ${response.body}");
    throw Exception("Not güncellenirken bir hata oluştu");
  }
}
}