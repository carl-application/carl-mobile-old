import 'package:carl/blocs/cards/cards_bloc.dart';
import 'package:carl/blocs/cards/cards_event.dart';
import 'package:carl/blocs/cards/cards_state.dart';
import 'package:carl/blocs/unread_notifications/unread_notification_event.dart';
import 'package:carl/blocs/unread_notifications/unread_notification_state.dart';
import 'package:carl/blocs/unread_notifications/unread_notifications_bloc.dart';
import 'package:carl/data/providers/user_api_provider.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:carl/localization/localization.dart';
import 'package:carl/models/navigation_arguments/scan_nfc_arguments.dart';
import 'package:carl/ui/authenticated/cards_swiper.dart';
import 'package:carl/ui/authenticated/good_deals_list_page.dart';
import 'package:carl/ui/authenticated/nfc_scan_page.dart';
import 'package:carl/ui/shared/carl_blue_gradient_button.dart';
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
  UnreadNotificationsBloc _unreadNotificationsBloc;
  int _unreadNotificationsCount = 0;

  @override
  initState() {
    super.initState();
    _cardsBloc = CardsBloc(UserRepository(userProvider: UserApiProvider()));
    _unreadNotificationsBloc = BlocProvider.of<UnreadNotificationsBloc>(context);
    _cardsBloc.dispatch(RetrieveCardsEvent());
    _unreadNotificationsBloc.dispatch(RetrieveUnreadNotificationsCountEvent());
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
        return Stack(
          children: <Widget>[
            Material(
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
                        Navigator.of(context).pushNamed(GoodDealsListPage.routeName);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/ic_idea.png",
                          height: 20,
                          width: 20,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _unreadNotificationsCount > 0
                ? Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          "$_unreadNotificationsCount",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        );
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
          child: Stack(
            children: <Widget>[
              Positioned(
                  bottom: CarlTheme.of(context).pageVerticalPadding - 8,
                  left: CarlTheme.of(context).pageHorizontalPadding,
                  child: _renderGoodDealsIcon()),
              Column(
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
                        child: CarlBlueGradientButton(
                      text: Localization.of(context).add,
                      onPressed: () => _navigateToScan(context),
                      width: MediaQuery.of(context).size.width * .5,
                      textStyle: CarlTheme.of(context).white30Label,
                    )),
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
