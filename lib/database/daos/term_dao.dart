import 'package:cheon/database/database.dart';
import 'package:cheon/database/tables.dart';
import 'package:moor/moor.dart';

part 'term_dao.g.dart';

@UseDao(tables: <Type>[Terms, InsetDay])
class TermDao extends DatabaseAccessor<Database> with _$TermDaoMixin {
  TermDao(Database db) : super(db);

  Future<void> insertTerm(Insertable<TermModel> term) =>
      into(terms).insert(term);
}
