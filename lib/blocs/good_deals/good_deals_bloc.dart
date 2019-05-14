import 'package:bloc/bloc.dart';
import 'package:carl/data/repositories/user_repository.dart';

import 'good_deals_event.dart';
import 'good_deals_state.dart';

class GoodDealsBloc extends Bloc<GoodDealsEvent, GoodDealsState> {
  GoodDealsBloc(this._userRepository);

  final UserRepository _userRepository;

  @override
  GoodDealsState get initialState => GoodDealsLoading();

  @override
  Stream<GoodDealsState> mapEventToState(GoodDealsEvent event) async* {
    if (event is RetrieveGoodDealsEvent) {
      yield GoodDealsLoading();
      try {
        final unreadGoodDeals = await _userRepository.retrieveUnreadGoodDeals();
        final readGoodDeals = await _userRepository.retrieveReadGoodDeals();

        unreadGoodDeals.addAll(readGoodDeals);

        yield GoodDealsLoadingSuccess(goodDeals: unreadGoodDeals);
      } catch (error) {
        print("cards loading error $error");
        yield GoodDealsLoadingError();
      }
    }
  }
}
