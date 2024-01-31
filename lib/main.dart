import 'package:flutter/material.dart';
import 'package:my_todo_app/sql.dart';


void main() {
  runApp(NewToDo());
}


class NewToDo extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  NewToDo({super.key});
  
  @override
  State<NewToDo> createState() => _NewToDoState();
}

class _NewToDoState extends State<NewToDo> {
  TextEditingController todoTitle = TextEditingController();

  // bool check = true;
  SqlData sqlDb = SqlData();

  Future<List<Map>> readData() async {
    List<Map> response = await sqlDb.readData("SELECT * FROM 'Todo'");
    setState(() {});
    return response;
  }

  List<bool> checkList = List<bool>.filled(20, false);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          children: [
            Image.asset(
              "assets/images/login.jpg",
              fit: BoxFit.fill,
              height: 202,
            ),
            Padding(
              padding: const EdgeInsets.all(27),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 240,
                        child: TextField(
                          decoration: const InputDecoration(
                            fillColor: Color(0xffEBEFF2),
                            filled: true,
                            hintText: "Note",
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                          controller: todoTitle,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          SqlData().insertData(
                              "INSERT INTO'Todo'('content')VALUES ('${todoTitle.text}')");
                          todoTitle.text = "";
                        },
                        child: Container(
                          color: const Color(0xff20EEB0),
                          height: 60,
                          width: 60,
                          child: const Icon(Icons.add),
                        ),
                      )
                    ],
                  ),
                  // Center(
                  //   child: ElevatedButton(
                  //       onPressed: () async {
                  //         await sqlDb.deleteAlldatabase();
                  //         await sqlDb.openDb();
                  //         setState(() {

                  //         });
                  //       },
                  //       child: Text("Clear the Screen")),
                  // ),
                  FutureBuilder(
                    future: readData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Map>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    snapshot.data![index]["content"],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Checkbox(
                                        value: checkList[index],
                                        onChanged: (value) {
                                          checkList[index] = value!;
                                          setState(() {});
                                        },
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await sqlDb.deleteData(
                                              "DELETE FROM Todo WHERE id= ${snapshot.data![index]["id"]}");
                                          setState(() {});
                                        },
                                        child: const Icon(Icons.delete),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
