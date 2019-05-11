import 'package:equatable/equatable.dart';

abstract class ToggleBlacklistState extends Equatable {
  ToggleBlacklistState([List props = const []]) : super(props);
}

class ToggleBlackInitialState extends ToggleBlacklistState {
  @override
  String toString() => 'ToggleBlackInitialState';
}

class ToggleBlackListLoading extends ToggleBlacklistState {
  @override
  String toString() => 'ToggleBlackListLoading';
}

class ToggleBlackListSuccess extends ToggleBlacklistState {
  final bool isBlackListed;

  ToggleBlackListSuccess(this.isBlackListed);

  @override
  String toString() => 'ToggleBlackListSuccess';
}

class ToggleBlackListError extends ToggleBlacklistState {
  @override
  String toString() => 'ToggleBlackListError';
}
