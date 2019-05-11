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
        final blackListedBusinesses = await _userRepository.retrieveBlackListedBusinesses();

        yield CardsLoadingSuccess(cards: cards, blackListedBusinesses: blackListedBusinesses);
      } catch (error) {
        print("cards loading error $error");
        yield CardsLoadingError();
      }
    }
  }
}
