import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_june_sample/controller/home_screen_controller.dart';
import 'package:firebase_june_sample/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> students = [];
  final Stream<QuerySnapshot> _studentsStream =
      FirebaseFirestore.instance.collection('students').snapshots();

  void _addOrEditStudent(
      {Map<String, String>? student, int? index, String? id}) {
    final nameController = TextEditingController(text: student?['name'] ?? '');
    final phoneController =
        TextEditingController(text: student?['phone'] ?? '');
    final courseController =
        TextEditingController(text: student?['course'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  print("helloo");
                  context.read<HomeScreenController>().pickImage();
                },
                child: CircleAvatar(
                  radius: 80,
                ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: courseController,
                decoration: InputDecoration(labelText: 'Course'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final newStudent = {
                    "name": nameController.text,
                    "ph": phoneController.text,
                    "sub": courseController.text,
                  };
                  if (index != null) {
                    HomeScreenController.editData(id: id!, data: newStudent);
                  } else {
                    HomeScreenController.addData(data: newStudent);
                  }
                  Navigator.of(ctx).pop();
                },
                child: Text(index == null ? 'Add Student' : 'Update Student'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Manager')),
      body: StreamBuilder(
        stream: _studentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: const Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) {
                final studentlist = snapshot.data!.docs;

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(studentlist[index]["name"]),
                    subtitle: Text(
                        'Phone: ${studentlist[index]["ph"] ?? ''}\nCourse: ${studentlist[index]["sub"] ?? ''}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _addOrEditStudent(
                                  student: {},
                                  index: index,
                                  id: studentlist[index].id);
                            }),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              HomeScreenController.deleteData(
                                  studentlist[index].id);
                            }),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditStudent(),
        child: Icon(Icons.add),
      ),
    );
  }
}
