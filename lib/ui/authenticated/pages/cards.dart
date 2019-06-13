import 'package:carl/blocs/cards/cards_bloc.dart';
import 'package:carl/blocs/cards/cards_event.dart';
import 'package:carl/blocs/cards/cards_state.dart';
import 'package:carl/blocs/unread_notifications/unread_notification_event.dart';
import 'package:carl/blocs/unread_notifications/unread_notification_state.dart';
import 'package:carl/blocs/unread_notifications/unread_notifications_bloc.dart';
import 'package:carl/data/repository_dealer.dart';
import 'package:carl/models/navigation_arguments/scan_nfc_arguments.dart';
import 'package:carl/translations.dart';
import 'package:carl/ui/authenticated/business_search_delegate.dart';
import 'package:carl/ui/authenticated/cards_swiper.dart';
import 'package:carl/ui/authenticated/empty_element.dart';
import 'package:carl/ui/authenticated/pages/good_deals_list.dart';
import 'package:carl/ui/authenticated/pages/scan.dart';
import 'package:carl/ui/authenticated/pages/settings.dart';
import 'package:carl/ui/shared/carl_blue_gradient_button.dart';
import 'package:carl/ui/shared/error_api_call.dart';
import 'package:carl/ui/shared/loader.dart';
import 'package:carl/ui/shared/rounded_icon.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Cards extends StatelessWidget {
  int _unreadNotificationsCount = 0;
  CardsBloc _cardsBloc;
  UnreadNotificationsBloc _unreadNotificationsBloc;

  _navigateToScan(BuildContext context) {
    Navigator.of(context).pushNamed(Scan.routeName, arguments: CallSource.home);
  }

  _navigateToSettings(BuildContext context) {
    Navigator.of(context).pushNamed(Settings.routeName);
  }

  _navigateToSearchPage(BuildContext context) {
    showSearch(context: context, delegate: BusinessSearchDelegate());
  }

  _navigateToGoodDeals(BuildContext context) async {
    final nbSeenDeals = await Navigator.pushNamed(context, GoodDealsList.routeName) as int;
    if (nbSeenDeals > 0) {
      _unreadNotificationsBloc.dispatch(RetrieveUnreadNotificationsCountEvent());
    }
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
            return EmptyElement(
              assetImageUrl: "assets/empty_cards.png",
              title: Translations.of(context).text("empty_cards_title"),
              description: Translations.of(context).text("empty_cards_description"),
            );
          }
          return CardsSwiper(
            cards: state.cards,
            blackListed: state.blackListedBusinesses,
          );
        } else if (state is CardsLoadingError) {
          return ErrorApiCall(
            errorTitle: state.isNetworkError
                ? Translations.of(context).text("network_error_title")
                : Translations.of(context).text("error_server_title"),
            errorDescription: state.isNetworkError
                ? Translations.of(context).text("network_error_description")
                : Translations.of(context).text("error_server_description"),
          );
        }
      },
    );
  }

  Widget _renderGoodDealsIcon() {
    return BlocBuilder<UnreadNotificationsEvent, UnreadNotificationsState>(
      bloc: _unreadNotificationsBloc,
      builder: (BuildContext context, UnreadNotificationsState state) {
        if (state is RetrieveUnreadNotificationsSuccess) {
          _unreadNotificationsCount = state.unreadNotificationsCount;
        } else if (state is OnNewUnreadNotificationsState) {
          _unreadNotificationsCount += state.count;
        } else if (state is RefreshUnreadNotificationsSuccess) {
          _unreadNotificationsCount = state.unreadNotificationsCount;
        }
        final stackChildren = List<Widget>();
        stackChildren.add(Material(
          shape: CircleBorder(),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.only(right: 5, left: 5),
            child: Container(
              decoration: BoxDecoration(
                  gradient: CarlTheme.of(context).orangeGradient, shape: BoxShape.circle),
              child: Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    _navigateToGoodDeals(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      "assets/ic_idea.png",
                      height: MediaQuery.of(context).size.width * .06,
                      width: MediaQuery.of(context).size.width * .06,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));

        if (_unreadNotificationsCount > 0) {
          stackChildren.add(Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.width * .05,
              width: MediaQuery.of(context).size.width * .05,
              decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  "$_unreadNotificationsCount",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ));
        }
        return Stack(
          children: <Widget>[...stackChildren],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _cardsBloc = CardsBloc(RepositoryDealer.of(context).userRepository);
    _unreadNotificationsBloc = BlocProvider.of<UnreadNotificationsBloc>(context);
    _cardsBloc.dispatch(RetrieveCardsEvent());
    _unreadNotificationsBloc.dispatch(RetrieveUnreadNotificationsCountEvent());
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
                      onClick: () => _navigateToSettings(context),
                    ),
                    RoundedIcon(
                      assetIcon: "assets/ic_search.png",
                      onClick: () => _navigateToSearchPage(context),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: _renderBody(context),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    _renderGoodDealsIcon(),
                    Expanded(
                      flex: 7,
                      child: Center(
                        child: CarlBlueGradientButton(
                          text: Translations.of(context).text("add"),
                          onPressed: () => _navigateToScan(context),
                          width: MediaQuery.of(context).size.width * .5,
                          textStyle: CarlTheme.of(context).white30Label,
                        ),
                      ),
                    ),
                    Spacer()
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
