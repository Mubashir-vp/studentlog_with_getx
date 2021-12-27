import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:provider_sample/model/model.dart';
import 'package:hive_flutter/adapters.dart';

class Homecontroller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    studentBox = Hive.box("students");
  }

  late Box<Model> studentBox;

  final nameformKey = GlobalKey<FormState>();
  final courseformKey = GlobalKey<FormState>();
  final rollnumberformKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController course = TextEditingController();
  TextEditingController rollnumber = TextEditingController();
  void add_student() {
    String studentname = name.text;
    String studentcourse = course.text;

    String studentrollnumber = rollnumber.text;

    Model students = Model(
        name: studentname,
        course: studentcourse,
        rollnumber: int.parse(studentrollnumber));
    studentBox.add(students);
    course.clear();
    rollnumber.clear();

    name.clear();
  }
   void edit_student(Model model, String name, String course, int rollnumber) {
    model.name = name;
    model.course = course;
    model.rollnumber = rollnumber;
    model.save();
  }
}
