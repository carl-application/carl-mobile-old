import 'package:bloc/bloc.dart';
import 'package:carl/blocs/cards/cards_event.dart';
import 'package:carl/blocs/cards/cards_state.dart';
import 'package:carl/data/repositories/user_repository.dart';

class CardsBloc extends Bloc<CardsEvent, CardsState> {
  CardsBloc(this._userRepository);

  final UserRepository _userRepository;

  @override
  CardsState get initialState => CardsLoading();

  @override
  Stream<CardsState> mapEventToState(CardsEvent event) async* {
    if (event is RetrieveCardsEvent) {
      yield CardsLoading();
      try {
        final cards = await _userRepository.retrieveCards();

        yield CardsLoadingSuccess(cards: cards);
      } catch (error) {
        yield CardsLoadingError();
      }
    } else if (event is RetrieveCardByIdEvent) {
      yield CardByIdLoading();

      try {
        final cardId = event.cardId;
        final card = await _userRepository.retrieveCardById(cardId);

        yield CardByIdLoadingSuccess(card: card);
      } catch (error) {
        yield CardByIdLoadingError();
      }
    }
  }
}
