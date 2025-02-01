import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final List<ToDoItem> _toDoItems = [
    ToDoItem(id: 1, title: 'Buy milk', completed: false, dueDate: DateTime.now().add(Duration(days: 1))),
    ToDoItem(id: 2, title: 'Walk the dog', completed: false, dueDate: DateTime.now().add(Duration(days: 2))),
    ToDoItem(id: 3, title: 'Do laundry', completed: false, dueDate: DateTime.now().add(Duration(days: 3))),
  ];

  final _textController = TextEditingController();

  void _addToDoItem() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _toDoItems.add(ToDoItem(
          id: _toDoItems.length + 1,
          title: _textController.text,
          completed: false,
          dueDate: DateTime.now().add(Duration(days: 0)),
        ));
        _textController.clear();
      });
    }
  }

  void _toggleCompleted(ToDoItem item) {
    setState(() {
      item.completed = !item.completed;
    });
  }

  void _deleteToDoItem(ToDoItem item) {
    setState(() {
      _toDoItems.remove(item);
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton(
            iconColor: Colors.yellow,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'title',
                child: Text('Sort by Title'),
              ),
              PopupMenuItem(
                value: 'dueDate',
                child: Text('Sort by Due Date'),
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
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              style: TextStyle(color: Colors.yellow),
              controller: _textController,
              decoration: InputDecoration(
                focusColor: Colors.yellow,
                labelText: 'Add new to-do item',
                labelStyle: TextStyle(color: Colors.yellow),
                border: OutlineInputBorder(),
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
                  color: Colors.yellow,
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      _toDoItems[index].title,
                      style: TextStyle(
                        color: Colors.black,
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
        backgroundColor: Colors.yellow,
        child: Icon(Icons.add , color: Colors.black, ),
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
} 