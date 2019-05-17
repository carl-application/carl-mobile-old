import 'package:bloc/bloc.dart';
import 'package:carl/data/repositories/user_repository.dart';

import 'good_deal_detail_event.dart';
import 'good_deal_detail_state.dart';

class GoodDealDetailBloc extends Bloc<GoodDealDetailEvent, GoodDealDetailState> {
  GoodDealDetailBloc(this._userRepository);

  final UserRepository _userRepository;

  @override
  GoodDealDetailState get initialState => GoodDealByIdLoading();

  @override
  Stream<GoodDealDetailState> mapEventToState(GoodDealDetailEvent event) async* {
    if (event is RetrieveGoodDealByIdEvent) {
      yield GoodDealByIdLoading();

      try {
        final dealId = event.id;
        final deal = await _userRepository.retrieveGoodDealDetail(dealId);

        yield GoodDealByIdLoadingSuccess(goodDeal: deal);
      } catch (error) {
        print("good deal by id loading error $error");
        yield GoodDealByIdLoadingError();
      }
    }
  }
}
