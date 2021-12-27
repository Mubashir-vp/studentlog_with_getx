import 'package:hive_flutter/adapters.dart';
part 'model.g.dart';

@HiveType(typeId: 0)
class Model extends HiveObject{
  @HiveField(0)
   String name;
  @HiveField(1)
   String course;
  @HiveField(2)
   int rollnumber;

  Model({required this.name, required this.course,required this.rollnumber});
}