import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes/models/notes.dart';
import 'package:notes/service/api_service.dart';
import 'package:notes/service/isar_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
class NoteProvider extends ChangeNotifier {
  final ApiService apiService;
  final IsarService isarService;
  NoteProvider(this.apiService, this.isarService);

  List<Note> _notes = [];
  List<Note> get notes {
    if (_isSearchActive && _searchController.text.isNotEmpty) {
      return _filteredNotes;
    }
    return _notes;
  }

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Note> _filteredNotes = [];
  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  Future<String> _getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor ?? "unknown_ios";
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; 
    }
  }

  void search(String query) async {
    if (query.isEmpty) {
      _filteredNotes = [];
    } else {
      _filteredNotes = await isarService.isar.notes
          .filter()
          .titleContains(query, caseSensitive: false)
          .or()
          .contentContains(query, caseSensitive: false)
          .findAll();
    }
    notifyListeners();
  }

  Future<void> allNotes() async {
    _notes = await isarService.getAllNotes();
    notifyListeners();

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      String userId = await _getDeviceId(); 
      final remoteNotes = await apiService.fetch_Notes(userId); 

      await isarService.isar.writeTxn(() async {
        for (var n in remoteNotes) {
          await isarService.isar.notes.put(n);
        }
      });

      _notes = await isarService.getAllNotes();
      _error = null;
    } catch (e) {
      print("Provider allNotes Hatası: $e");
      _error = "Çevrimdışı mod: Sunucuya erişilemedi.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add_note(Note note) async {
    note.isSynced = false;
    await isarService.saveNote(note);
    _notes = await isarService.getAllNotes();
    notifyListeners();
    try {
      String userId = await _getDeviceId();
      final syncedNote = await apiService.addNote(note, userId);
      note.id = syncedNote.id;
      note.isSynced = true;

      await isarService.saveNote(note);
      _error = null;
    } catch (e) {
      print("Provider add_note Hatası: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleted(Note note) async {
    note.isDeletedLocally = true;
    await isarService.saveNote(note);
    _notes = await isarService.getAllNotes();
    notifyListeners();

    try {
      String userId = await _getDeviceId();
      await apiService.deletedNotes(note.id!, userId);
      await isarService.deleteNotePermanently(note.localId);
    } catch (e) {
      _error = "$e";
    } finally {
      notifyListeners();
    }
  }

  Future<void> change_completed(Note note) async {
    note.isCompleted = !note.isCompleted;
    note.isSynced = false;
    await isarService.saveNote(note);
    notifyListeners();
    try {
      String userId = await _getDeviceId();
      await apiService.change_button(note.id!, userId); 
      note.isSynced = true;
      await isarService.saveNote(note);
      _error = null;
    } catch (e) {
      print("Provider change_completed Hatası: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> update_note(Note note, String newTitle, String newContent) async {
    note.title = newTitle;
    note.content = newContent;
    note.isSynced = false;

    await isarService.saveNote(note);
    _notes = await isarService.getAllNotes();
    notifyListeners();

    try {
      String userId = await _getDeviceId();
      await apiService.updateNote(note, userId); 
      note.isSynced = true;
      await isarService.saveNote(note);
    } catch (e) {
      print("Provider update_note Hatası: $e");
    } finally {
      notifyListeners();
    }
  }

  bool _isSearchActive = false;
  bool get isSearchActive => _isSearchActive;

  void toggleSearch() {
    _isSearchActive = !_isSearchActive;
    if (!_isSearchActive) {
      _searchController.clear();
      _filteredNotes = [];
    }
    notifyListeners();
  }
}