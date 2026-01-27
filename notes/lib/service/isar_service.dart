import 'package:isar/isar.dart';
import 'package:notes/models/notes.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {

late Isar isar;

Future<void> init()async{
  final dir = await getApplicationDocumentsDirectory();
  
  if(Isar.instanceNames.isEmpty){
    isar = await Isar.open([NoteSchema],directory: dir.path);
  }else{
    isar = Isar.getInstance()!;
  }

}


  Future<List<Note>> getAllNotes() async {
    return await isar.notes.filter().isDeletedLocallyEqualTo(false).sortByCreatedAtDesc().findAll();
  }

  Future<void> saveNote(Note note) async {
    await isar.writeTxn(() => isar.notes.put(note));
  }

  Future<void> deleteNotePermanently(int localId) async {
    await isar.writeTxn(() => isar.notes.delete(localId));
  }


  
}
