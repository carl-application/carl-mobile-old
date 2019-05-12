import 'package:bloc/bloc.dart';
import 'package:carl/blocs/cards/cards_event.dart';
import 'package:carl/blocs/cards/cards_state.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:carl/models/business/business_image.dart';

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

        final imagesFutures = <Future>[];
        final logosFutures = <Future>[];

        cards.forEach((c) {
          imagesFutures.add(_userRepository.getImageById(c.image.id));
          logosFutures.add(_userRepository.getImageById(c.logo.id));
        });

        final images = await Future.wait(imagesFutures);
        final logos = await Future.wait(logosFutures);

        images.asMap().forEach((index, value) => cards[index].image = value as BusinessImage);
        logos.asMap().forEach((index, value) => cards[index].logo = value as BusinessImage);

        yield CardsLoadingSuccess(cards: cards, blackListedBusinesses: blackListedBusinesses);
      } catch (error) {
        print("cards loading error $error");
        yield CardsLoadingError();
      }
    }
  }
}
