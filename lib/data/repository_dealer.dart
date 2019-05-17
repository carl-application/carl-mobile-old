import 'package:carl/data/repositories/user_repository.dart';
import 'package:flutter/widgets.dart';

class RepositoryDealer extends InheritedWidget {
  final UserRepository userRepository;

  RepositoryDealer({@required Widget child, this.userRepository}) : super(child: child);

  static RepositoryDealer of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(RepositoryDealer);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
