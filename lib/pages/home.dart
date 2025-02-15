import 'package:flutter/material.dart';
import 'package:flutter_crud/database/dbhelper.dart';
import 'package:flutter_crud/person.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Map<String, dynamic>> empdata = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    var data = await Dbhelper.instance.queryAll();
    setState(() {
      empdata = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CRUD")),
      body: Column(
        children: [
          Text("Debug"),
          Text("$empdata"),
          ElevatedButton(
            onPressed: () {
              insert();
            },
            child: Text("Insert"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: empdata.length,
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage('https://icons.veryicon.com/png/o/miscellaneous/standard/avatar-15.png'),
                    ),
                    title: Text(empdata[i]['name']),
                  )
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void insert() {
    TextEditingController input_name = TextEditingController();
    TextEditingController input_department = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Employee Insert"),
          content: Column(
            children: [
              TextField(
                controller: input_name,
                decoration: InputDecoration(labelText: 'Enter Name'),
              ),
              TextField(
                controller: input_department,
                decoration: InputDecoration(labelText: 'Enter Department'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                var employee = Person(
                  name: input_name.text,
                  department: input_department.text,
                );

                await Dbhelper.instance.insertEmp(employee);
                empdata = await Dbhelper.instance.queryAll();
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: Text("Insert"),
            ),
          ],
        );
      },
    );
  }
}
