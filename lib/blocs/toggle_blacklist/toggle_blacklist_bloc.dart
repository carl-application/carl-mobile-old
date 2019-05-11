import 'package:bloc/bloc.dart';
import 'package:carl/data/repositories/user_repository.dart';

import 'toggle_blacklist_event.dart';
import 'toggle_blacklist_state.dart';

class ToggleBlacklistBloc extends Bloc<ToggleBlacklistEvent, ToggleBlacklistState> {
  ToggleBlacklistBloc(this._userRepository);

  final UserRepository _userRepository;

  @override
  ToggleBlacklistState get initialState => ToggleBlackInitialState();

  @override
  Stream<ToggleBlacklistState> mapEventToState(ToggleBlacklistEvent event) async* {
    if (event is ToggleNotificationBlackListEvent) {
      yield ToggleBlackListLoading();

      try {
        final isBlackListedResponse = await _userRepository.toggleBlackList(event.cardId);
        yield ToggleBlackListSuccess(isBlackListedResponse.isBlackListed);
      } catch (error) {
        yield ToggleBlackListError();
      }
    }
  }
}
