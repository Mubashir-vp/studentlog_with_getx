import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider_sample/controller/home_controller.dart';
import 'package:provider_sample/model/model.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameformKey = GlobalKey<FormState>();
    final courseformKey = GlobalKey<FormState>();
    final rollnumberformKey = GlobalKey<FormState>();

    var homecontroller = Get.put(Homecontroller());
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: nameformKey,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty || value[0] == " ") {
                                  return "This field is required";
                                }
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.name,
                              controller: homecontroller.name,
                              decoration: InputDecoration(
                                  icon: const Icon(
                                    Icons.person_outline,
                                    color: Colors.blue,
                                  ),
                                  hintText: "Enter Your name...",
                                  hintStyle: TextStyle(
                                      color: Colors.black.withOpacity(.18),
                                      fontWeight: FontWeight.w900)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: courseformKey,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty || value[0] == " ") {
                                  return "This field is required";
                                }
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: homecontroller.course,
                              decoration: InputDecoration(
                                  icon: const Icon(
                                    Icons.android_sharp,
                                    color: Colors.blue,
                                  ),
                                  hintText: "Enter Your Course..",
                                  hintStyle: TextStyle(
                                      color: Colors.black.withOpacity(.18),
                                      fontWeight: FontWeight.w900)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: rollnumberformKey,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty || value[0] == " ") {
                                  return "This field is required";
                                }
                              },
                              controller: homecontroller.rollnumber,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  icon: const Icon(
                                    Icons.format_list_numbered,
                                    color: Colors.blue,
                                  ),
                                  hintText: "RollNumber",
                                  hintStyle: TextStyle(
                                      color: Colors.black.withOpacity(.18),
                                      fontWeight: FontWeight.w900)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  if (rollnumberformKey.currentState!
                                          .validate() &&
                                      courseformKey.currentState!.validate() &&
                                      nameformKey.currentState!.validate()) {
                                    homecontroller.add_student();
                                    Get.back();
                                  } else {}
                                },
                                child: const Text("Save"),
                                color: Colors.blue,
                                textColor: Colors.white,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        child: const Icon(CupertinoIcons.add),
      ),
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            CupertinoIcons.trash_fill,
          ),
        ),
        title: const Text(
          'Student Log',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          Container(
              width: _width,
              height: _height * .35,
              color: Colors.blueAccent,
              child: Center(
                  child: Text(
                "Add Student Details",
                style: TextStyle(
                    color: Colors.white.withOpacity(.8),
                    fontSize: 30,
                    fontWeight: FontWeight.w900),
              ))),
          Expanded(
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: ValueListenableBuilder(
                    valueListenable: homecontroller.studentBox.listenable(),
                    builder: (context, Box<Model> studentShow, child) {
                      List<int> key =
                          homecontroller.studentBox.keys.cast<int>().toList();

                      return ListView.builder(
                        itemBuilder: (con, index) {
                          final indexedKey = key[index];

                          final Model? studentLog =
                              homecontroller.studentBox.get(indexedKey);
                          return key.isEmpty
                              ? const Center(
                                  child: Text(
                                    "Empty",
                                    style: (TextStyle(color: Colors.black)),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15.0, left: 22),
                                      child: Dismissible(
                                        background: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 22.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                              color: Colors.red,
                                            ),
                                            child: const Center(
                                                child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            )),
                                          ),
                                        ),
                                        key: ValueKey<int>(indexedKey),
                                        direction: DismissDirection.endToStart,
                                        confirmDismiss: (direction) async {
                                          if (direction ==
                                              DismissDirection.endToStart) {
                                            final bool res = await showDialog(
                                                context: context,
                                                builder: (BuildContext) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Text(
                                                          " Delete this student",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .redAccent,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        const SizedBox(
                                                          height: 40,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            TextButton(
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(Colors
                                                                            .blue)),
                                                                onPressed: () {
                                                                  homecontroller
                                                                      .studentBox
                                                                      .delete(
                                                                          indexedKey);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          true);
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Yes",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Poppins",
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                )),
                                                            TextButton(
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(Colors
                                                                            .blue)),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          false);
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "No",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Poppins",
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                )),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                });
                                            return res;
                                          } else {
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  var changedname =
                                                      studentLog!.name;
                                                  var changedcourse =
                                                      studentLog.course;

                                                  var changedrollnumber =
                                                      studentLog.rollnumber;
                                                  return AlertDialog(
                                                    content: SizedBox(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Form(
                                                              // key: nameformKey,
                                                              child:
                                                                  TextFormField(
                                                                onChanged:
                                                                    (string) {
                                                                  changedname =
                                                                      string;
                                                                },
                                                                initialValue:
                                                                    (studentLog
                                                                        .name),
                                                                validator:
                                                                    (value) {
                                                                  if (value!
                                                                          .isEmpty ||
                                                                      value[0] ==
                                                                          " ") {
                                                                    return "This field is required";
                                                                  }
                                                                },
                                                                // autovalidateMode:
                                                                //     AutovalidateMode
                                                                //         .onUserInteraction,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .name,
                                                                decoration:
                                                                    InputDecoration(
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .person_outline,
                                                                          color:
                                                                              Colors.blue,
                                                                        ),
                                                                        hintStyle: TextStyle(
                                                                            color:
                                                                                Colors.black.withOpacity(.18),
                                                                            fontWeight: FontWeight.w900)),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Form(
                                                              // key: courseformKey,
                                                              child:
                                                                  TextFormField(
                                                                onChanged:
                                                                    (string) {
                                                                  changedcourse =
                                                                      string;
                                                                },
                                                                initialValue:
                                                                    studentLog
                                                                        .course,
                                                                validator:
                                                                    (value) {
                                                                  if (value!
                                                                          .isEmpty ||
                                                                      value[0] ==
                                                                          " ") {
                                                                    return "This field is required";
                                                                  }
                                                                },
                                                                autovalidateMode:
                                                                    AutovalidateMode
                                                                        .onUserInteraction,
                                                                decoration:
                                                                    InputDecoration(
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .android_sharp,
                                                                          color:
                                                                              Colors.blue,
                                                                        ),
                                                                        hintText:
                                                                            "Enter Your Course..",
                                                                        hintStyle: TextStyle(
                                                                            color:
                                                                                Colors.black.withOpacity(.18),
                                                                            fontWeight: FontWeight.w900)),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Form(
                                                              //   key: rollnumberformKey,
                                                              child:
                                                                  TextFormField(
                                                                onChanged:
                                                                    (string) {
                                                                  changedrollnumber =
                                                                      int.tryParse(
                                                                          string)??0;
                                                                },
                                                                initialValue:
                                                                    studentLog
                                                                        .rollnumber
                                                                        .toString(),
                                                                validator:
                                                                    (value) {
                                                                  if (value!
                                                                          .isEmpty ||
                                                                      value[0] ==
                                                                          " ") {
                                                                    return "This field is required";
                                                                  }
                                                                },
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                decoration:
                                                                    InputDecoration(
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .format_list_numbered,
                                                                          color:
                                                                              Colors.blue,
                                                                        ),
                                                                        hintText:
                                                                            "RollNumber",
                                                                        hintStyle: TextStyle(
                                                                            color:
                                                                                Colors.black.withOpacity(.18),
                                                                            fontWeight: FontWeight.w900)),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                MaterialButton(
                                                                  onPressed:
                                                                      () {
                                                                    
                                                                      Model changed = Model(
                                                                          course:
                                                                              changedcourse,
                                                                          name:
                                                                              changedname,
                                                                          rollnumber:
                                                                              changedrollnumber);
                                                                      homecontroller
                                                                          .studentBox
                                                                          .putAt(
                                                                              index,
                                                                              changed);
                                                                      Get.back();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          "Save"),
                                                                  color: Colors
                                                                      .blue,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: ListTile(
                                            title: Text(
                                              studentLog!.name.toUpperCase(),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            subtitle: Text(studentLog.course,
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.blue,
                                    ),
                                  ],
                                );
                        },
                        itemCount: key.length,
                      );
                    },
                  )))
        ],
      ),
    );
  }
}
