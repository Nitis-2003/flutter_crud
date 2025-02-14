class Person {
  final int id;
  final String name;
  final String department;

  Person({required this.id, required this.name, required this.department});

  // แปลง object Person เป็นรูปแบบคล้ายกับ JSON
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'department': department};
  }

  // แปลงรูปแบบ JSON เป็น object Person
  factory Person.fromMap(Map<String,dynamic> data){
    return Person(id: data['id'], name: data['name'], department: data['department']);
  }

  // เอาไว้ทดสอบแสดงข้อมูล
  @override
  String toString() {
    return '{id:$id, name:$name, department:$department}';
  }
}
