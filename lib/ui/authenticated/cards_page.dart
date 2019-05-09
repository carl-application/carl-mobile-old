import 'package:carl/blocs/cards/cards_bloc.dart';
import 'package:carl/blocs/cards/cards_event.dart';
import 'package:carl/blocs/cards/cards_state.dart';
import 'package:carl/data/providers/user_dummy_provider.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:carl/ui/authenticated/cards_swiper.dart';
import 'package:carl/ui/shared/carl_button.dart';
import 'package:carl/ui/shared/rounded_icon.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardsPage extends StatelessWidget {
  UserRepository _userRepository = new UserRepository(userProvider: UserDummyProvider());
  CardsBloc _cardsBloc;

  Widget _renderBody() {
    return BlocBuilder<CardsEvent, CardsState>(
      bloc: _cardsBloc,
      builder: (BuildContext buildContext, CardsState state) {
        if (state is CardsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CardsLoadingSuccess) {
          return CardsSwiper(
            cards: state.cards,
          );
        } else {
          return Container(
            color: Colors.green,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _cardsBloc = CardsBloc(_userRepository);
    _cardsBloc.dispatch(RetrieveCardsEvent());

    return Container(
      color: CarlTheme.of(context).background,
      child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 18.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RoundedIcon(
                        assetIcon: "assets/ic_settings.png",
                      ),
                      RoundedIcon(
                        assetIcon: "assets/ic_search.png",
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: _renderBody(),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                      child: CarlButton(
                        text: "Ajouter",
                        onPressed: () {},
                        width: MediaQuery.of(context).size.width * .5,
                        height: 20,
                        color: CarlTheme.of(context).accentColor,
                        textStyle: CarlTheme.of(context).whiteBigLabel,
                      )),
                ),
              ],
            ),
          )),
    );
  }
}
