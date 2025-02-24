import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/DataBaseHelper.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToDoList(),
      theme: ThemeData(
        primarySwatch: Colors.teal,),
    );
  }
}

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
final DatabaseHelper _databaseHelper = DatabaseHelper();
  static const primaryColor = Colors.black;
  static const secondaryColor = Colors.tealAccent;
  
  List<ToDoItem> _toDoItems = [];

  final _textController = TextEditingController();

  void _addToDoItem() async {
    if (_textController.text.isNotEmpty) {
     
      ToDoItem item = ToDoItem(
          id: _toDoItems.length + 1,
          title: _textController.text,
          completed: false,
          dueDate: DateTime.now().add(Duration(days: 0)),
      );
      await _databaseHelper.insert(item);
      setState(() {
        _toDoItems.add(item);
      });
        _textController.clear();

    }
  }

  void _toggleCompleted(ToDoItem item) async {
    setState((){
      item.completed = !item.completed;
    });
    await _databaseHelper.update(item);
    
  }


  void _deleteToDoItem(ToDoItem item) async {
    await _databaseHelper.delete(item);
    setState(() {
      _toDoItems.remove(item);
    });
  }
  @override
  void initState() {
    super.initState();
    _loadItems();
  }


  void _loadItems() async {
    List<ToDoItem> items = await _databaseHelper.getAllItems();
    setState(() {
      _toDoItems = items;
    });
  }
  void _sortByTitle() {
    setState(() {
      _toDoItems.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    });
  }

  void _sortByDueDate() {
    setState(() {
      _toDoItems.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        actions: [
          PopupMenuButton(
            iconColor: secondaryColor,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'title',
                child: Text('Sort by Title'),
              ),
              PopupMenuItem(
                value: 'dueDate',
                child: Text('Sort by Date'),
              ),
            ],
            onSelected: (value) {
              if (value == 'title') {
                _sortByTitle();
              } else if (value == 'dueDate') {
                _sortByDueDate();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            
            child: TextField(
              cursorColor: secondaryColor,
              style: TextStyle(color: secondaryColor),
              controller: _textController,
              decoration: InputDecoration(
                fillColor: const Color.fromARGB(110, 138, 138, 138),
                filled: true,
                focusColor: secondaryColor,
                labelText: 'Add to-do',
                labelStyle: TextStyle(color: secondaryColor),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor, width: 3.0),
                ),
                        
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor, width: 1.0),
                ),
              ),
                
            
            
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            
            child: ListView.builder(
              itemCount: _toDoItems.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                  color: secondaryColor,
                  elevation: 3,
                  child: Dismissible(
                    key: Key(_toDoItems[index].id.toString()),
                    background: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      _deleteToDoItem(_toDoItems[index]);
                    },
                    
                    child: ListTile(
                      title: Text(
                        _toDoItems[index].title,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: _toDoItems[index].completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Text(_toDoItems[index].dueDate.toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: _toDoItems[index].completed,
                            onChanged: (value) {
                              _toggleCompleted(_toDoItems[index]);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteToDoItem(_toDoItems[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addToDoItem,
        elevation: 10,
        shape: CircleBorder(),
        backgroundColor: secondaryColor,
        child: Icon(Icons.add , color: primaryColor, ),
      ),
    );
  }
}

class ToDoItem {
  int id;
  String title;
  bool completed;
  DateTime? dueDate;

  ToDoItem({this.id = 0, this.title = '', this.completed = false, this.dueDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'completed': completed ? 1 : 0,
      'dueDate': dueDate?.toIso8601String(),
    };
  }
} 