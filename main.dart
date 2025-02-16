import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.ebGaramondTextTheme(),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.ebGaramondTextTheme(),
      ),
      themeMode: ThemeMode.system,
      home: NoteHomePage(),
    );
  }
}

class Note {
  String text;
  bool isCompleted;
  bool isPinned;
  bool isTrashed;

  Note({required this.text, this.isCompleted = false, this.isPinned = false, this.isTrashed = false});
}

class NoteHomePage extends StatefulWidget {
  @override
  _NoteHomePageState createState() => _NoteHomePageState();
}

class _NoteHomePageState extends State<NoteHomePage> {
  List<Note> notes = [];
  TextEditingController controller = TextEditingController();

  void addNote() {
    if (controller.text.isNotEmpty) {
      setState(() {
        notes.add(Note(text: controller.text));
        controller.clear();
      });
    }
  }

  void toggleComplete(int index) {
    setState(() {
      notes[index].isCompleted = !notes[index].isCompleted;
    });
  }

  void togglePin(int index) {
    setState(() {
      notes[index].isPinned = !notes[index].isPinned;
    });
  }

  void moveToTrash(int index) {
    setState(() {
      notes[index].isTrashed = !notes[index].isTrashed;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Note> sortedNotes = notes.where((note) => !note.isTrashed).toList()
      ..sort((a, b) {
        if (a.isPinned != b.isPinned) {
          return a.isPinned ? -1 : 1;
        }
        return a.isCompleted ? 1 : -1;
      });

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              setState(() {
                ThemeMode currentTheme = Theme.of(context).brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Enter Note",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: addNote,
            child: Text("Add Note"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sortedNotes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(sortedNotes[index].text, style: TextStyle(
                    decoration: sortedNotes[index].isCompleted ? TextDecoration.lineThrough : null,
                  )),
                  leading: IconButton(
                    icon: Icon(
                      sortedNotes[index].isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                    ),
                    onPressed: () => togglePin(index),
                  ),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        icon: Icon(
                          sortedNotes[index].isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                        ),
                        onPressed: () => toggleComplete(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => moveToTrash(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
