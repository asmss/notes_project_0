import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notes/providers/note_provider.dart';
import 'package:notes/screens/NoteListPage.dart';
import 'package:notes/service/api.dart';
import 'package:notes/service/api_service.dart';
import 'package:notes/service/isar_service.dart';
import 'package:notes/service/notification_service.dart';
import 'package:provider/provider.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
    await NotificationService.initializeNotification();
    final isarService = IsarService();
    await isarService.init(); 
    runApp(
      MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=> NoteProvider(ApiService(Api(http.Client())),isarService))
      ],
      child:const Main())
      );
   }

class Main extends StatefulWidget {
  const Main({super.key});


  @override
  State<Main> createState() => _MyWidgetState();

}

class _MyWidgetState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: const Notelistpage()
      ),
    );
  }
}