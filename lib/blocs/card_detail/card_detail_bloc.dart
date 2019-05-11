import 'package:bloc/bloc.dart';
import 'package:carl/data/repositories/user_repository.dart';

import 'card_detail_event.dart';
import 'card_detail_state.dart';

class CardDetailBloc extends Bloc<CardDetailEvent, CardDetailState> {
  CardDetailBloc(this._userRepository);

  final UserRepository _userRepository;

  @override
  CardDetailState get initialState => CardByIdLoading();

  @override
  Stream<CardDetailState> mapEventToState(CardDetailEvent event) async* {
    if (event is RetrieveCardByIdEvent) {
      yield CardByIdLoading();

      try {
        final cardId = event.cardId;
        final card = await _userRepository.retrieveCardById(cardId);
        final isBlackListedResponse = await _userRepository.isBusinessBlackListed(cardId);

        yield CardByIdLoadingSuccess(
            card: card, isBlackListed: isBlackListedResponse.isBlackListed);
      } catch (error) {
        print("card by id loading error $error");
        yield CardByIdLoadingError();
      }
    }
  }
}
