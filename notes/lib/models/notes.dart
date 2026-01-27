import 'package:isar/isar.dart';
part "notes.g.dart";

@collection 
class Note{
 
 Id localId = Isar.autoIncrement; 

@Index(unique: true,replace: true)
String? id;
 late String title;
 late String content;
  late bool isCompleted;
  late DateTime createdAt;

 bool isSynced = false; 
 bool isDeletedLocally = false; 
DateTime? reminderDate;
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.isCompleted,
    required this.createdAt,
    this.isSynced = false,
    this.isDeletedLocally = false,
    this.reminderDate
  });


factory Note.fromJson(Map<String,dynamic> json){
  return Note(
   id:json["id"]?.toString()?? "",
   title:json["title"] ?? "",
   content:json["content"]?? "",
   createdAt: json["createdAt"] != null 
        ? DateTime.parse(json["createdAt"]) 
        : DateTime.now(),
   isCompleted:json["isCompleted"] ?? false,
   isSynced: true, 
   reminderDate: json["reminderDate"]
  );
}

Map<String,dynamic> toJson(){
   return{
    "title":title,
    "content":content,
    "createdAt":createdAt?.toIso8601String(),
    "isCompleted":isCompleted,
    "reminderDate":reminderDate
   };
}


}