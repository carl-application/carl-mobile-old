import 'package:bloc/bloc.dart';
import 'package:carl/data/repositories/user_repository.dart';

import 'unread_notification_event.dart';
import 'unread_notification_state.dart';

class UnreadNotificationsBloc extends Bloc<UnreadNotificationsEvent, UnreadNotificationsState> {
  UnreadNotificationsBloc(this._userRepository);

  final UserRepository _userRepository;

  @override
  UnreadNotificationsState get initialState => UnreadNotificationsInitialState();

  @override
  Stream<UnreadNotificationsState> mapEventToState(UnreadNotificationsEvent event) async* {
    if (event is RetrieveUnreadNotificationsCountEvent) {
      try {
        final unreadNotifications = await _userRepository.retrieveUnreadNotificationsCount();

        yield RetrieveUnreadNotificationsSuccess(
            unreadNotificationsCount: unreadNotifications.unreadNotificationsCount);
      } catch (error) {
        print("Unread notifications loading error $error");
        yield RetrieveUnreadNotificationsError();
      }
    } else if (event is AddNewUnreadNotificationsEvent) {
      yield OnNewUnreadNotificationsState(count: event.count);
    } else if (event is RefreshUnreadNotificationsCountEvent) {
      final unreadNotifications = await _userRepository.retrieveUnreadNotificationsCount();
      yield RefreshUnreadNotificationsSuccess(
          unreadNotificationsCount: unreadNotifications.unreadNotificationsCount);
    }
  }
}
