import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:carl/models/good_deal.dart';

import 'good_deals_event.dart';
import 'good_deals_state.dart';

class GoodDealsBloc extends Bloc<GoodDealsEvent, GoodDealsState> {
  GoodDealsBloc(this._userRepository);

  final UserRepository _userRepository;
  List<GoodDeal> _deals;

  @override
  GoodDealsState get initialState => GoodDealsLoading();

  @override
  Stream<GoodDealsState> mapEventToState(GoodDealsEvent event) async* {
    if (event is RetrieveGoodDealsEvent) {
      yield GoodDealsLoading();
      try {
        _deals = await _userRepository.retrieveUnreadGoodDeals();
        _deals.addAll(await _userRepository.retrieveReadGoodDeals());

        yield GoodDealsLoadingSuccess(goodDeals: _deals);
      } catch (error) {
        print("cards loading error $error");
        yield GoodDealsLoadingError(isNetworkError: error is SocketException);
      }
    } else if (event is HaveReadGoodDealEvent) {
      _deals[event.index].seen = true;
      yield GoodDealsLoadingSuccess(goodDeals: _deals);
    }
  }
}
