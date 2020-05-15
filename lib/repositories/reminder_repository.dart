class ReminderRepository {
  ReminderRepository._internal() {
    //
  }
  static ReminderRepository get instance => _singleton;

  static final ReminderRepository _singleton = ReminderRepository._internal();
}
