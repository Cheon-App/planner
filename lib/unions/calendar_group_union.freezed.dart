// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'calendar_group_union.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$CalendarGroupUnionTearOff {
  const _$CalendarGroupUnionTearOff();

// ignore: unused_element
  _Loading loading() {
    return const _Loading();
  }

// ignore: unused_element
  _Data data(List<CalendarGroup> calendarGroups) {
    return _Data(
      calendarGroups,
    );
  }

// ignore: unused_element
  _NoPermission noPermission() {
    return const _NoPermission();
  }
}

/// @nodoc
// ignore: unused_element
const $CalendarGroupUnion = _$CalendarGroupUnionTearOff();

/// @nodoc
mixin _$CalendarGroupUnion {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result loading(),
    @required Result data(List<CalendarGroup> calendarGroups),
    @required Result noPermission(),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result loading(),
    Result data(List<CalendarGroup> calendarGroups),
    Result noPermission(),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result loading(_Loading value),
    @required Result data(_Data value),
    @required Result noPermission(_NoPermission value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result loading(_Loading value),
    Result data(_Data value),
    Result noPermission(_NoPermission value),
    @required Result orElse(),
  });
}

/// @nodoc
abstract class $CalendarGroupUnionCopyWith<$Res> {
  factory $CalendarGroupUnionCopyWith(
          CalendarGroupUnion value, $Res Function(CalendarGroupUnion) then) =
      _$CalendarGroupUnionCopyWithImpl<$Res>;
}

/// @nodoc
class _$CalendarGroupUnionCopyWithImpl<$Res>
    implements $CalendarGroupUnionCopyWith<$Res> {
  _$CalendarGroupUnionCopyWithImpl(this._value, this._then);

  final CalendarGroupUnion _value;
  // ignore: unused_field
  final $Res Function(CalendarGroupUnion) _then;
}

/// @nodoc
abstract class _$LoadingCopyWith<$Res> {
  factory _$LoadingCopyWith(_Loading value, $Res Function(_Loading) then) =
      __$LoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$LoadingCopyWithImpl<$Res>
    extends _$CalendarGroupUnionCopyWithImpl<$Res>
    implements _$LoadingCopyWith<$Res> {
  __$LoadingCopyWithImpl(_Loading _value, $Res Function(_Loading) _then)
      : super(_value, (v) => _then(v as _Loading));

  @override
  _Loading get _value => super._value as _Loading;
}

/// @nodoc
class _$_Loading implements _Loading {
  const _$_Loading();

  @override
  String toString() {
    return 'CalendarGroupUnion.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result loading(),
    @required Result data(List<CalendarGroup> calendarGroups),
    @required Result noPermission(),
  }) {
    assert(loading != null);
    assert(data != null);
    assert(noPermission != null);
    return loading();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result loading(),
    Result data(List<CalendarGroup> calendarGroups),
    Result noPermission(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result loading(_Loading value),
    @required Result data(_Data value),
    @required Result noPermission(_NoPermission value),
  }) {
    assert(loading != null);
    assert(data != null);
    assert(noPermission != null);
    return loading(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result loading(_Loading value),
    Result data(_Data value),
    Result noPermission(_NoPermission value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements CalendarGroupUnion {
  const factory _Loading() = _$_Loading;
}

/// @nodoc
abstract class _$DataCopyWith<$Res> {
  factory _$DataCopyWith(_Data value, $Res Function(_Data) then) =
      __$DataCopyWithImpl<$Res>;
  $Res call({List<CalendarGroup> calendarGroups});
}

/// @nodoc
class __$DataCopyWithImpl<$Res> extends _$CalendarGroupUnionCopyWithImpl<$Res>
    implements _$DataCopyWith<$Res> {
  __$DataCopyWithImpl(_Data _value, $Res Function(_Data) _then)
      : super(_value, (v) => _then(v as _Data));

  @override
  _Data get _value => super._value as _Data;

  @override
  $Res call({
    Object calendarGroups = freezed,
  }) {
    return _then(_Data(
      calendarGroups == freezed
          ? _value.calendarGroups
          : calendarGroups as List<CalendarGroup>,
    ));
  }
}

/// @nodoc
class _$_Data implements _Data {
  const _$_Data(this.calendarGroups) : assert(calendarGroups != null);

  @override
  final List<CalendarGroup> calendarGroups;

  @override
  String toString() {
    return 'CalendarGroupUnion.data(calendarGroups: $calendarGroups)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Data &&
            (identical(other.calendarGroups, calendarGroups) ||
                const DeepCollectionEquality()
                    .equals(other.calendarGroups, calendarGroups)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(calendarGroups);

  @override
  _$DataCopyWith<_Data> get copyWith =>
      __$DataCopyWithImpl<_Data>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result loading(),
    @required Result data(List<CalendarGroup> calendarGroups),
    @required Result noPermission(),
  }) {
    assert(loading != null);
    assert(data != null);
    assert(noPermission != null);
    return data(calendarGroups);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result loading(),
    Result data(List<CalendarGroup> calendarGroups),
    Result noPermission(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (data != null) {
      return data(calendarGroups);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result loading(_Loading value),
    @required Result data(_Data value),
    @required Result noPermission(_NoPermission value),
  }) {
    assert(loading != null);
    assert(data != null);
    assert(noPermission != null);
    return data(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result loading(_Loading value),
    Result data(_Data value),
    Result noPermission(_NoPermission value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _Data implements CalendarGroupUnion {
  const factory _Data(List<CalendarGroup> calendarGroups) = _$_Data;

  List<CalendarGroup> get calendarGroups;
  _$DataCopyWith<_Data> get copyWith;
}

/// @nodoc
abstract class _$NoPermissionCopyWith<$Res> {
  factory _$NoPermissionCopyWith(
          _NoPermission value, $Res Function(_NoPermission) then) =
      __$NoPermissionCopyWithImpl<$Res>;
}

/// @nodoc
class __$NoPermissionCopyWithImpl<$Res>
    extends _$CalendarGroupUnionCopyWithImpl<$Res>
    implements _$NoPermissionCopyWith<$Res> {
  __$NoPermissionCopyWithImpl(
      _NoPermission _value, $Res Function(_NoPermission) _then)
      : super(_value, (v) => _then(v as _NoPermission));

  @override
  _NoPermission get _value => super._value as _NoPermission;
}

/// @nodoc
class _$_NoPermission implements _NoPermission {
  const _$_NoPermission();

  @override
  String toString() {
    return 'CalendarGroupUnion.noPermission()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _NoPermission);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result loading(),
    @required Result data(List<CalendarGroup> calendarGroups),
    @required Result noPermission(),
  }) {
    assert(loading != null);
    assert(data != null);
    assert(noPermission != null);
    return noPermission();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result loading(),
    Result data(List<CalendarGroup> calendarGroups),
    Result noPermission(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (noPermission != null) {
      return noPermission();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result loading(_Loading value),
    @required Result data(_Data value),
    @required Result noPermission(_NoPermission value),
  }) {
    assert(loading != null);
    assert(data != null);
    assert(noPermission != null);
    return noPermission(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result loading(_Loading value),
    Result data(_Data value),
    Result noPermission(_NoPermission value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (noPermission != null) {
      return noPermission(this);
    }
    return orElse();
  }
}

abstract class _NoPermission implements CalendarGroupUnion {
  const factory _NoPermission() = _$_NoPermission;
}
