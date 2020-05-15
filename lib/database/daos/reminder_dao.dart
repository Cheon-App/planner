import 'package:cheon/database/database.dart';
import 'package:cheon/database/tables.dart';
import 'package:moor/moor.dart';

part 'reminder_dao.g.dart';

@UseDao(tables: <Type>[Reminders])
class ReminderDao extends DatabaseAccessor<Database> with _$ReminderDaoMixin {
  ReminderDao(Database db) : super(db);
}
