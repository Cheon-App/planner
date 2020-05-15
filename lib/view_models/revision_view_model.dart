import 'package:cheon/constants.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/services/key_value_service/key_value_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cheon/utils.dart';
import 'package:cheon/repositories/study_repository.dart';

class RevisionVM extends ChangeNotifier {
  RevisionVM() {
    _revisionSetup = _keyValueService.getValue(KEY_REVISION_SETUP) ?? false;
    _revisionEnabled = _keyValueService.getValue(KEY_REVISION_ENABLED) ?? false;
    _startTime = _keyValueService.getValue(KEY_START_TIME) != null
        ? SerializedTimeOfDay.fromJson(
            _keyValueService.getValue(KEY_START_TIME),
          )
        : const TimeOfDay(hour: 15, minute: 30);
    _endTime = _keyValueService.getValue(KEY_END_TIME) != null
        ? SerializedTimeOfDay.fromJson(_keyValueService.getValue(KEY_END_TIME))
        : const TimeOfDay(hour: 20, minute: 0);

    _revisionLength = _keyValueService.getValue(KEY_REVISION_LENGTH) ?? 25;
    _breakLength = _keyValueService.getValue(KEY_BREAK_LENGTH) ?? 5;
    _extendedBreakLength =
        _keyValueService.getValue(KEY_EXTENDED_BREAK_LENGTH) ?? 20;
    _extendedBreakFrequency =
        _keyValueService.getValue(KEY_EXTENDED_BREAK_FREQUENCY) ?? 4;
    _variety = _keyValueService.getValue(KEY_VARIETY) ?? 3;
    _sessionTarget = _keyValueService.getValue(KEY_SESSION_TARGET) ?? 4;

    _studyRepository.progressTodayStream.listen(
      (double progress) {
        _progressToday = progress;
        notifyListeners();
      },
    );
    _studyRepository.sessionsCompletedStream.listen(
      (int sessionsCompleted) {
        _sessionsCompleted = sessionsCompleted;
        notifyListeners();
      },
    );
    _studyRepository.completionRateStream.listen(
      (int completionRate) {
        _completionRate = completionRate;
        notifyListeners();
      },
    );
    _studyRepository.dailyStreakStream.listen(
      (int streak) {
        _dailyStreak = streak;
        notifyListeners();
      },
    );
  }

  factory RevisionVM.of(BuildContext context, {bool listen = true}) =>
      Provider.of<RevisionVM>(context, listen: listen);

  static const String KEY_REVISION_SETUP = 'revision_setup';
  static const String KEY_REVISION_ENABLED = 'revision_enabled';
  static const String KEY_START_TIME = 'start_time';
  static const String KEY_END_TIME = 'end_time';
  static const String KEY_REVISION_LENGTH = 'revision_length';
  static const String KEY_BREAK_LENGTH = 'break_length';
  static const String KEY_EXTENDED_BREAK_LENGTH = 'extended_break_length';
  static const String KEY_EXTENDED_BREAK_FREQUENCY = 'extended_break_frequency';
  static const String KEY_VARIETY = 'variety';
  static const String KEY_SESSION_TARGET = 'session_target';

  final KeyValueService _keyValueService =
      container<KeyValueService>(KEY_REVISION_BOX);

  final StudyRepository _studyRepository = StudyRepository.instance;

  bool _revisionSetup;
  bool get revisionSetup => _revisionSetup;
  set revisionSetup(bool revisionSetup) {
    if (revisionSetup == _revisionSetup) return;
    _revisionSetup = revisionSetup;
    notifyListeners();
    _keyValueService.setValue(KEY_REVISION_SETUP, revisionSetup);
  }

  bool _revisionEnabled;
  bool get revisionEnabled => _revisionEnabled;
  set revisionEnabled(bool revisionEnabled) {
    if (revisionEnabled == _revisionEnabled) return;
    _revisionEnabled = revisionEnabled;
    notifyListeners();
    _keyValueService.setValue('revision_enabled', revisionEnabled);
  }

  TimeOfDay _startTime;
  TimeOfDay get startTime => _startTime;
  set startTime(TimeOfDay time) {
    if (_startTime == time) return;
    _startTime = time;
    notifyListeners();
    _keyValueService.setValue(KEY_START_TIME, startTime.toJson());
  }

  TimeOfDay _endTime;
  TimeOfDay get endTime => _endTime;
  set endTime(TimeOfDay time) {
    if (_endTime == time) return;
    _endTime = time;
    notifyListeners();
    _keyValueService.setValue(KEY_END_TIME, endTime.toJson());
  }

  int _revisionLength;
  int get revisionLength => _revisionLength;
  set revisionLength(int revisionLength) {
    if (_revisionLength == revisionLength) return;
    _revisionLength = revisionLength;
    notifyListeners();
    _keyValueService.setValue(KEY_REVISION_LENGTH, revisionLength);
  }

  int _breakLength;
  int get breakLength => _breakLength;
  set breakLength(int breakLength) {
    if (_breakLength == breakLength) return;
    _breakLength = breakLength;
    notifyListeners();
    _keyValueService.setValue(KEY_BREAK_LENGTH, breakLength);
  }

  int _extendedBreakLength;
  int get extendedBreakLength => _extendedBreakLength;
  set extendedBreakLength(int extendedBreakLength) {
    if (_extendedBreakLength == extendedBreakLength) return;
    _extendedBreakLength = extendedBreakLength;
    notifyListeners();
    _keyValueService.setValue(
      KEY_EXTENDED_BREAK_LENGTH,
      extendedBreakLength,
    );
  }

  int _extendedBreakFrequency;
  int get extendedBreakFrequency => _extendedBreakFrequency;
  set extendedBreakFrequency(int extendedBreakFrequency) {
    if (_extendedBreakFrequency == extendedBreakFrequency) return;
    _extendedBreakFrequency = extendedBreakFrequency;
    notifyListeners();
    _keyValueService.setValue(
      KEY_EXTENDED_BREAK_FREQUENCY,
      extendedBreakFrequency,
    );
  }

  int _variety;
  int get variety => _variety;
  set variety(int variety) {
    if (_variety == variety) return;
    _variety = variety;
    notifyListeners();
    _keyValueService.setValue(KEY_VARIETY, variety);
  }

  int _sessionTarget;
  // The amount of sessions needed to increment the daily streak
  int get sessionTarget => _sessionTarget;
  set sessionTarget(int sessionGoal) {
    if (_sessionTarget == sessionGoal) return;
    _sessionTarget = sessionGoal;
    notifyListeners();
    _keyValueService.setValue(KEY_SESSION_TARGET, sessionGoal);
  }

  double _progressToday;
  double get progressToday => _progressToday;

  int _sessionsCompleted;
  int get sessionsCompleted => _sessionsCompleted;

  int _completionRate;
  int get completionRate => _completionRate;

  int _dailyStreak;
  int get dailyStreak => _dailyStreak;

  Future<GeneratedRevisionResult> generateRevisionBlocks(
      {bool artificialDelay = false}) async {
    final GeneratedRevisionResult result =
        await _studyRepository.generateRevisionBlocks(
      revisionLength: revisionLength,
      breakLength: breakLength,
      extendedBreakLength: extendedBreakLength,
      extendedBreakFrequency: extendedBreakFrequency,
      startTime: startTime,
      endTime: endTime,
      variety: variety,
    );

    /// Artificial delay is used to instill confidence on behalf of the user.
    if (artificialDelay && result == GeneratedRevisionResult.SUCCESSFUL) {
      await Future<void>.delayed(const Duration(seconds: 3));
    }

    return result;
  }

  Future<void> deleteFutureStudySessions() =>
      _studyRepository.deleteFutureStudySessions();
}
