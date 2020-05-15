import 'package:cheon/database/daos/exam_dao.dart';
import 'package:cheon/database/daos/study_dao.dart';
import 'package:cheon/database/daos/test_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/models/compare_date_time.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/models/study_session.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/test.dart';
import 'package:cheon/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

class StudyRepository {
  StudyRepository._internal() {
    _dao.progressTodayStream().listen(_progressTodayStream.add);
    _dao.sessionsCompletedStream().listen(_sessionsCompletedSubject.add);
    _dao.completionRateStream().listen(_completionRateSubject.add);
    _dao.dailyStreakStream().listen(_dailyStreakSubject.add);
  }
  static StudyRepository get instance => _singleton;

  static final StudyRepository _singleton = StudyRepository._internal();

  final StudyDao _dao = Database.instance.studyDao;
  final ExamDao _examDao = Database.instance.examDao;
  final TestDao _testDao = Database.instance.testDao;
  // final LessonDao _lessonDao = Database.instance.lessonDao;

  Stream<List<StudySession>> studySessionListFromDateStream(DateTime date) =>
      _dao.studySessionListFromDateStream(date);

  final BehaviorSubject<double> _progressTodayStream =
      BehaviorSubject<double>();
  Stream<double> get progressTodayStream => _progressTodayStream.stream;

  final BehaviorSubject<int> _sessionsCompletedSubject = BehaviorSubject<int>();
  Stream<int> get sessionsCompletedStream => _sessionsCompletedSubject.stream;

  final BehaviorSubject<int> _completionRateSubject = BehaviorSubject<int>();
  Stream<int> get completionRateStream => _completionRateSubject.stream;

  final BehaviorSubject<int> _dailyStreakSubject = BehaviorSubject<int>();
  Stream<int> get dailyStreakStream => _dailyStreakSubject.stream;

  Stream<List<StudySession>> studySessionListFromExam(Exam exam) =>
      _dao.studySessionListFromExam(exam);

  Stream<List<StudySession>> studySessionListFromTest(Test test) =>
      _dao.studySessionListFromTest(test);

  @visibleForTesting
  // TODO test this
  /// Finds the date of the last exam/test when given a list of exams and tests
  /// If no exams and tests are provided then null is returned
  DateTime lastAssessment({
    @required List<Exam> examList,
    @required List<Test> testList,
  }) {
    DateTime lastAssessmentDate;
    if (examList.isNotEmpty && testList.isNotEmpty) {
      final Exam lastExam = examList.last;
      final Test lastTest = testList.last;
      if (lastExam.compareDateTime.isAfter(lastTest.compareDateTime)) {
        lastAssessmentDate = lastExam.compareDateTime;
      } else {
        lastAssessmentDate = lastTest.compareDateTime;
      }
    } else if (examList.isNotEmpty) {
      lastAssessmentDate = examList.last.compareDateTime;
    } else if (testList.isNotEmpty) {
      lastAssessmentDate = testList.last.compareDateTime;
    }

    return lastAssessmentDate;
  }

  @visibleForTesting
  // TODO test this
  /// Returns the [DateTime] of the start of the first session
  DateTime firstSessionStart({
    @required Duration revisionDuration,
    @required TimeOfDay startTime,
    @required TimeOfDay endTime,
  }) {
    final DateTime now = DateTime.now();
    DateTime nextSessionStart = dateTimeWithTimeOfDay(now, startTime);
    // If we've missed the start time
    if (now.isAfter(nextSessionStart)) {
      if (TimeOfDay.fromDateTime(
        now.add(revisionDuration),
      ).isBeforeOrSameAs(endTime)) {
        // We still have time to add at least one study session
        nextSessionStart = now.add(const Duration(minutes: 1));
      } else {
        // We cannot fit another study session in today so we're skipping to the
        // next day
        nextSessionStart = nextSessionStart.add(const Duration(days: 1));
      }
    }
    return nextSessionStart;
  }

  @visibleForTesting
  // TODO test this
  /// Returns a map containing blank [Session]s every day from now until the
  /// day before the last assessment
  Map<int, List<Session>> placeholderSessionMap({
    @required TimeOfDay startTime,
    @required TimeOfDay endTime,
    @required Duration revisionDuration,
    @required Duration shortBreak,
    @required Duration longBreak,
    @required int daysUntilLastAssessment,
    @required int extendedBreakFrequency,
  }) {
    final Map<int, List<Session>> sessionMap = <int, List<Session>>{};

    DateTime nextSessionStart = firstSessionStart(
      startTime: startTime,
      endTime: endTime,
      revisionDuration: revisionDuration,
    );

    final DateTime nowStripped = strippedDateTime(DateTime.now());

    // If no sessions can be created today then the sessionMap[0] should be an
    // empty list
    final bool skippedFirstDay =
        nextSessionStart.isAfter(nowStripped.add(const Duration(days: 1))) ||
            nextSessionStart
                .isAtSameMomentAs(nowStripped.add(const Duration(days: 1)));

    if (skippedFirstDay) sessionMap[0] = <Session>[];

    /// Populates the [sessionMap] with sessions from now
    /// until the last exam
    for (int i = skippedFirstDay ? 1 : 0; i < daysUntilLastAssessment; i++) {
      // Used to decide when to take a long break
      int dailySessionCount = 0;
      final List<Session> sessionList = <Session>[];

      // While there's enough time for another study session
      while (TimeOfDay.fromDateTime(
        nextSessionStart.add(revisionDuration),
      ).isBeforeOrSameAs(endTime)) {
        // Increment the amount of sessions added
        dailySessionCount += 1;
        // Add the study session without a test or exam
        sessionList.add(Session.blank(
          start: nextSessionStart,
          end: nextSessionStart.add(revisionDuration),
        ));
        nextSessionStart = nextSessionStart.add(revisionDuration);

        if (dailySessionCount % extendedBreakFrequency == 0) {
          // add long break
          nextSessionStart = nextSessionStart.add(longBreak);
        } else {
          // add short break
          nextSessionStart = nextSessionStart.add(shortBreak);
        }
      }

      sessionMap[i] = sessionList;

      // Reset the start time and push the day forward by one
      nextSessionStart = nextSessionStart.add(const Duration(days: 1));
      nextSessionStart = dateTimeWithTimeOfDay(nextSessionStart, startTime);
    }
    return sessionMap;
  }

  Future<GeneratedRevisionResult> generateRevisionBlocks({
    @required int revisionLength,
    @required int breakLength,
    @required int extendedBreakLength,
    @required int extendedBreakFrequency,
    @required TimeOfDay startTime,
    @required TimeOfDay endTime,
    @required int variety,
    // Multipliers used to signify which properties take priority
    double priorityMultiplier = 1,
    double timeRemainingMultiplier = 1,
    double varietyMultiplier = 1,
  }) async {
    final List<Exam> examList = List<Exam>.unmodifiable(
      await _examDao.currentExamListFuture(),
    );
    final List<Test> testList = List<Test>.unmodifiable(
      await _testDao.currentTestListFuture(),
    );
    // final List<Lesson> lessonList = await _lessonDao.lessonListFuture();
    final Duration revisionDuration = Duration(minutes: revisionLength);
    final Duration shortBreak = Duration(minutes: breakLength);
    final Duration longBreak = Duration(minutes: extendedBreakLength);

    final DateTime lastAssessmentDate = lastAssessment(
      examList: examList,
      testList: testList,
    );

    if (lastAssessmentDate == null) {
      return GeneratedRevisionResult.NO_ASSESSMENTS;
    }

    final DateTime now = DateTime.now();
    final DateTime nowStripped = strippedDateTime(now);

    final int daysUntilLastAssessment =
        strippedDateTime(lastAssessmentDate).difference(nowStripped).inDays;
    print('daysUntilLastAssessment: $daysUntilLastAssessment');
    // Checks if sessions can be created
    if (daysUntilLastAssessment == 0 &&
        CompareDateTime(now).compareTimeTo(endTime) > 0) {
      /// No study sessions can be created as the only assessments are today
      /// and this is being run after the [endTime]
      return GeneratedRevisionResult.NO_SLOTS_AVAILABLE;
    }

    // For every day up until the day before the last assessment a list is added
    //  to this map containing unassigned study sessions for that day
    final Map<int, List<Session>> sessionMap = placeholderSessionMap(
      startTime: startTime,
      endTime: endTime,
      shortBreak: shortBreak,
      longBreak: longBreak,
      daysUntilLastAssessment: daysUntilLastAssessment,
      extendedBreakFrequency: extendedBreakFrequency,
      revisionDuration: revisionDuration,
    );

    print('sessionMap.length: ${sessionMap.length}');

    final List<WeightedAssessment> weightedAssessmentList =
        <WeightedAssessment>[
      ...examList.map(WeightedAssessment.fromExam),
      ...testList.map(WeightedAssessment.fromTest),
    ];

    /// CONSIDERATIONS
    /// -------------------------------
    /// Time Remaining
    /// - No. of sessions before the assessment / sum of no. of sessions before
    /// each assessment
    ///
    /// Exam/Test priority
    /// - Sort lists by priority then adjust score
    ///
    /// Subject variety
    /// - On subsequent sessions, decrease probability of same subject being
    ///   assigned to a certain degree

    /// Uses a probabalistic algorithm to fill blank [Session]s with
    /// [Assessment]s
    for (int dayIndex = 0; dayIndex < daysUntilLastAssessment; dayIndex++) {
      /// A list of blank sessions for the current day
      /// The algorithm will pair these [Session]s with an [Assessment]
      final List<Session> dailySessionList = sessionMap[dayIndex];

      final List<Session> allFutureSessions = <Session>[
        for (int i = dayIndex; i < daysUntilLastAssessment; i++)
          ...sessionMap[i]
      ];

      final DateTime currentDate = nowStripped.add(Duration(days: dayIndex));
      print('Day ${dayIndex + 1} | $currentDate');

      // Retains assessments due tomorrow or in the future
      weightedAssessmentList.retainWhere(
        (WeightedAssessment assessment) =>
            assessment.date.isAfter(currentDate.add(const Duration(days: 1))) ||
            assessment.date
                .isAtSameMomentAs(currentDate.add(const Duration(days: 1))),
      );

      final double initialVarietyWeight = 1 / weightedAssessmentList.length;

      int sessionsBeforeAllAssessmentsSum = 0;
      int userPrioritySum = 0;

      /// Returns a list of sessions that the assessment could be assigned to
      /// based on the date of the sessions and assessment
      List<Session> availableSessionList(WeightedAssessment assessment) {
        return allFutureSessions.where(
          (Session session) {
            return (session.start.isAfter(currentDate) ||
                    session.start.isAtSameMomentAs(currentDate)) &&
                (session.start.isBefore(assessment.date) ||
                    session.start.isAtSameMomentAs(assessment.date));
          },
        ).toList();
      }

      /// Initialises [sessionsBeforeAllAssessmentsSum] and [prioritySum]
      for (WeightedAssessment assessment in weightedAssessmentList) {
        /// Number of sessions available for this assessment
        // int sessionCount = 0;

        /// ┌────────────┬───────────────────────┐
        /// │ Assessment │ Days until assessment │
        /// ├────────────┼───────────────────────┤
        /// │     A      │           3           │
        /// │     B      │           5           │
        /// │     C      │           7           │
        /// └────────────┴───────────────────────┘
        /// [sessionsBeforeAllAssessmentsSum] would equal 3 + 5 + 7 or 15 in
        /// this case

        final List<Session> sessionsBeforeAssessment =
            availableSessionList(assessment);

        sessionsBeforeAllAssessmentsSum += sessionsBeforeAssessment.length;
        userPrioritySum += assessment.userPriority;
      }

      // ######################### START OF WEIGHTING ##########################
      double _debugPrioritySum = 0;
      double _debugTimeRemainingSum = 0;
      double _debugVarietySum = 0;

      /// Assigns weights to every [WeightedAssessment]
      for (WeightedAssessment assessment in weightedAssessmentList) {
        assessment.timeRemainingWeight = 1 -
            (availableSessionList(assessment).length /
                sessionsBeforeAllAssessmentsSum);

        assessment.priorityWeight = assessment.userPriority / userPrioritySum;

        // varietyWeight is initially equal for all assessments until a session
        // is assigned an Assessment
        assessment.varietyWeight = initialVarietyWeight;

        // For debug purposes
        _debugPrioritySum += assessment.priorityWeight;
        _debugTimeRemainingSum += assessment.timeRemainingWeight;
        _debugVarietySum += assessment.varietyWeight;
      }

      // Debug asserts that make sure the weights are assigned correctly
      assert(_debugPrioritySum == 1, 'sum of priority weights should be 1');
      /* assert(
        _debugTimeRemainingSum == 1,
        'sum of time remaining weights should be 1',
      ); */
      assert(_debugVarietySum == 1, 'sum of variety weights should be 1');

      /// Assigns a new score to each [Assessment] based on it's latest weights
      /// then sorts [weightedAssessmentList] based on the new scores
      void updateScores() {
        for (WeightedAssessment assessment in weightedAssessmentList) {
          // TODO consider a better system for calculating assessment scores
          // e.g. Spearmans rank correlation coefficient for all weights
          double score = 0;

          score += assessment.priorityWeight * priorityMultiplier;
          score += assessment.timeRemainingWeight * timeRemainingMultiplier;
          score += assessment.varietyWeight * varietyMultiplier;

          assessment.score = score;
        }

        // Sorts scores from LARGEST to SMALLEST
        weightedAssessmentList.sort(
          (WeightedAssessment a, WeightedAssessment b) =>
              b.score.compareTo(a.score),
        );
      }

      updateScores();

      dailySessionList.map((Session s) => s.start).forEach(print);

      for (Session session in dailySessionList) {
        print('Initialising session');

        /// Assigns a [WeightedAssessment] to a session
        final WeightedAssessment bestAssessment = weightedAssessmentList.first;
        session.addWeightedAssessment(bestAssessment);

        /// Decrease [assessment.varietyWeight] of the assessment that was just
        /// chosen and increase [assessment.varietyWeight] of the other
        /// assessments
        for (WeightedAssessment assessment in weightedAssessmentList) {
          if (assessment == bestAssessment) {
            assessment.varietyWeight = assessment.varietyWeight * 0.5;
          } else {
            assessment.varietyWeight = assessment.varietyWeight *
                (1 + (0.5 / weightedAssessmentList.length));
          }
        }

        updateScores();
      }

      sessionMap[dayIndex] = dailySessionList;
    }

    // Removes old study sessions then adds the newly created ones
    await _dao.removeFutureStudySessions();
    final List<Session> sessionPlaceholders = <Session>[];
    sessionMap.values.forEach(sessionPlaceholders.addAll);
    await _dao.addSessionList(sessionPlaceholders);

    return GeneratedRevisionResult.SUCCESSFUL;
  }

  Future<void> updateStudySession(StudySession session,
          {@required bool completed}) =>
      _dao.updateStudySession(session, completed: completed);

  Future<void> deleteStudySession(StudySession session) =>
      _dao.deleteStudySession(session);

  Future<void> deleteFutureStudySessions() => _dao.removeFutureStudySessions();
}

enum GeneratedRevisionResult {
  SUCCESSFUL,
  NO_ASSESSMENTS,
  NO_SLOTS_AVAILABLE,
}

class Session {
  Session.blank({@required this.start, @required this.end});

  void addWeightedAssessment(WeightedAssessment assessment) {
    _assessmentID = assessment.id;
    _assessmentType = assessment.type;
  }

  String _assessmentID;
  String get assessmentID => _assessmentID;

  AssessmentType _assessmentType;
  AssessmentType get assessmentType => _assessmentType;

  final DateTime start;
  final DateTime end;
}

@visibleForTesting
class WeightedAssessment with EquatableMixin {
  WeightedAssessment._({
    @required this.id,
    @required this.type,
    @required this.userPriority,
    @required this.date,
    @required this.subject,
  });

  static WeightedAssessment fromExam(Exam exam) {
    return WeightedAssessment._(
      id: exam.id,
      type: AssessmentType.EXAM,
      date: strippedDateTime(exam.start),
      userPriority: exam.priority,
      subject: exam.subject,
    );
  }

  static WeightedAssessment fromTest(Test test) {
    return WeightedAssessment._(
      id: test.id,
      type: AssessmentType.TEST,
      date: strippedDateTime(test.date),
      userPriority: test.priority,
      subject: test.subject,
    );
  }

  final String id;
  final AssessmentType type;
  final int userPriority;
  final DateTime date;
  final Subject subject;

  /// The final score used to compare [WeightedAssessment]s when
  /// allocating study sessions an [Assessment]
  double score;

  /// Set once per day
  double timeRemainingWeight;

  /// Set once per day
  double priorityWeight;

  /// Set after each session is allocated an [Assessment]
  double varietyWeight;

  @override
  List<Object> get props => <Object>[id];
}

enum AssessmentType { EXAM, TEST }
