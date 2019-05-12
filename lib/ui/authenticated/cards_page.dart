import 'package:carl/blocs/cards/cards_bloc.dart';
import 'package:carl/blocs/cards/cards_event.dart';
import 'package:carl/blocs/cards/cards_state.dart';
import 'package:carl/data/providers/user_api_provider.dart';
import 'package:carl/data/providers/user_dummy_provider.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:carl/localization/localization.dart';
import 'package:carl/models/navigation_arguments/scan_nfc_arguments.dart';
import 'package:carl/ui/authenticated/cards_swiper.dart';
import 'package:carl/ui/authenticated/nfc_scan_page.dart';
import 'package:carl/ui/shared/carl_button.dart';
import 'package:carl/ui/shared/error_server.dart';
import 'package:carl/ui/shared/loader.dart';
import 'package:carl/ui/shared/rounded_icon.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'empty_cards.dart';

class CardsPage extends StatefulWidget {
  @override
  _CardsPageState createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  CardsBloc _cardsBloc;

  @override
  initState() {
    super.initState();
    _cardsBloc = CardsBloc(UserRepository(userProvider: UserApiProvider()));
    _cardsBloc.dispatch(RetrieveCardsEvent());
  }

  @override
  dispose() {
    _cardsBloc.dispose();
    super.dispose();
  }

  _navigateToScan(BuildContext context) {
    Navigator.of(context).pushNamed(NfcScanPage.routeName, arguments: CallSource.home);
  }

  Widget _renderBody(context) {
    return BlocBuilder<CardsEvent, CardsState>(
      bloc: _cardsBloc,
      builder: (BuildContext buildContext, CardsState state) {
        if (state is CardsLoading) {
          return Center(
            child: Loader(),
          );
        } else if (state is CardsLoadingSuccess) {
          if (state.cards.isEmpty) {
            return EmptyCards();
          }
          return CardsSwiper(
            cards: state.cards,
            blackListed: state.blackListedBusinesses,
          );
        } else {
          return ErrorServer();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        color: CarlTheme.of(context).background,
        child: SafeArea(
            child: Padding(
          padding: CarlTheme.of(context).pagePadding,
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
                flex: 8,
                child: _renderBody(context),
              ),
              Expanded(
                flex: 1,
                child: Center(
                    child: CarlButton(
                  text: Localization.of(context).add,
                  onPressed: () => _navigateToScan(context),
                  width: MediaQuery.of(context).size.width * .5,
                  color: CarlTheme.of(context).accentColor,
                  textStyle: CarlTheme.of(context).white30Label,
                )),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
