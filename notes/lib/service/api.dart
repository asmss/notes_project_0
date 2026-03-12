import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notes/models/notes.dart';
class Api {
  final http.Client client;
  Api(this.client);
     final String baseUrl = "https://notes-project-0.onrender.com";
     final Duration timeoutdur = const Duration(seconds: 45); 
// burda timout süresi arttılıacak süre 1 dk ya çıkarılacak renderin çalışması için gereken süre
     Future<http.Response> fetchNotes(String userId)async{
      return client.get(
        Uri.parse("$baseUrl/get_notes"),
        headers: {"Content-Type":"application/json","user-id":userId}
      ).timeout(timeoutdur);
     }

     Future<http.Response> addNote(Map<String,dynamic> body,String userId)async{
       body["userId"] = userId;
      final response = await client.post(Uri.parse("$baseUrl/add"),
       headers: {"Content-Type":"application/json","user-id":userId},
       body:jsonEncode(body)
      ).timeout(timeoutdur);
       return response;
 
     }
     
     Future<http.Response> deletedNote(String note_id,String userId)async{
      final response = await client.delete(
        Uri.parse("$baseUrl/delete/$note_id"),
      headers: {"user-id":userId}
      ).timeout(timeoutdur);
      return response;
     }

     Future<http.Response> changeButton(String note_id,String userId)async{
      final response = await client.put(Uri.parse("$baseUrl/change/$note_id"),
      headers: {"user-id":userId}
      ).timeout(timeoutdur);
      return response;
     }

Future<http.Response> updateNoteRequest(String noteId, Map<String, dynamic> body,String userId) async {
  return client.put(
    Uri.parse("$baseUrl/update/$noteId"),
    headers: {"Content-Type": "application/json","user-id":userId},
    body: jsonEncode(body),
  ).timeout(timeoutdur);
}

}
