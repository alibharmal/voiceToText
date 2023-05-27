import 'package:hive/hive.dart';
part 'Note.g.dart';

@HiveType(typeId: 1)
class Note {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? message;
  @HiveField(3)
  DateTime? createdAt;
  @HiveField(4)
  DateTime? updatedAt;

  Note({this.id, this.title, this.message, this.createdAt, this.updatedAt});
}
