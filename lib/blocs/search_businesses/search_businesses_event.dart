import 'package:equatable/equatable.dart';

abstract class SearchBusinessesEvent extends Equatable {
  SearchBusinessesEvent([List props = const []]) : super(props);
}

class SearchBusinessesByNameEvent extends SearchBusinessesEvent {
  final String name;

  SearchBusinessesByNameEvent(this.name);
  @override
  String toString() => 'SearchBusinessesByNameEvent { name: $name }';
}
