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
                      backgroundImage: NetworkImage(
                        'https://icons.veryicon.com/png/o/miscellaneous/standard/avatar-15.png',
                      ),
                    ),
                    title: Text("Name: ${empdata[i]['name']}"),
                    subtitle: Text("Dept: ${empdata[i]['department']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(onPressed: (){update(i);}, child: Icon(Icons.edit)),
                        SizedBox(width: 5),
                        ElevatedButton(onPressed: (){delete(empdata[i]['id']);}, child: Icon(Icons.delete)),
                      ]
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void insert() {
    TextEditingController inputName = TextEditingController();
    TextEditingController inputDepartment = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Employee Insert"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: inputName,
                decoration: InputDecoration(labelText: 'Enter Name'),
              ),
              TextField(
                controller: inputDepartment,
                decoration: InputDecoration(labelText: 'Enter Department'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                var employee = Person(
                  name: inputName.text,
                  department: inputDepartment.text,
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
  
  void delete(int id) async{
    await Dbhelper.instance.deleteEmp(id);
    loadData();
  }

  void update(int index) {
    int id = empdata[index]['id'];
    TextEditingController inputName = TextEditingController(text: empdata[index]['name']);
    TextEditingController inputDepartment = TextEditingController(text: empdata[index]['department']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Employee Edit"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: inputName,
                decoration: InputDecoration(labelText: 'Enter Name'),
              ),
              TextField(
                controller: inputDepartment,
                decoration: InputDecoration(labelText: 'Enter Department'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                var employee = Person(
                  id: id,
                  name: inputName.text,
                  department: inputDepartment.text,
                );
                
                print("DEBUG =============== $employee");

                await Dbhelper.instance.updateEmp(employee);
                empdata = await Dbhelper.instance.queryAll();
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
