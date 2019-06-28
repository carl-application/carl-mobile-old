import 'dart:ui';

import 'package:carl/blocs/card_detail/card_detail_bloc.dart';
import 'package:carl/blocs/card_detail/card_detail_event.dart';
import 'package:carl/blocs/card_detail/card_detail_state.dart';
import 'package:carl/blocs/toggle_blacklist/toggle_blacklist_bloc.dart';
import 'package:carl/blocs/toggle_blacklist/toggle_blacklist_event.dart';
import 'package:carl/blocs/toggle_blacklist/toggle_blacklist_state.dart';
import 'package:carl/constants.dart';
import 'package:carl/data/repository_dealer.dart';
import 'package:carl/models/navigation_arguments/card_detail_arguments.dart';
import 'package:carl/models/navigation_arguments/card_detail_back_arguments.dart';
import 'package:carl/models/navigation_arguments/map_search_arguments.dart';
import 'package:carl/ui/authenticated/card_percent_indicator_painter.dart';
import 'package:carl/ui/authenticated/pages/map_search.dart';
import 'package:carl/ui/authenticated/tag_item.dart';
import 'package:carl/ui/authenticated/visits_by_user.dart';
import 'package:carl/ui/shared/clickable_text.dart';
import 'package:carl/ui/shared/error_api_call.dart';
import 'package:carl/ui/shared/loader.dart';
import 'package:carl/ui/shared/rounded_icon.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_ink_well/image_ink_well.dart';

import '../../../translations.dart';

class CardDetail extends StatefulWidget {
  static const routeName = "/cardDetailPage";

  int _cardId;

  CardDetail(CardDetailArguments arguments) {
    this._cardId = arguments.cardId;
  }

  @override
  _CardDetailState createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> with TickerProviderStateMixin {
  CardDetailBloc _cardDetailBloc;
  ToggleBlacklistBloc _toggleBlacklistBloc;
  bool _isBlackListed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cardDetailBloc = CardDetailBloc(RepositoryDealer.of(context).userRepository);
    _toggleBlacklistBloc = ToggleBlacklistBloc(RepositoryDealer.of(context).userRepository);
    _cardDetailBloc.dispatch(RetrieveCardByIdEvent(cardId: widget._cardId));
  }

  @override
  void dispose() {
    _toggleBlacklistBloc.dispose();
    _cardDetailBloc.dispose();
    super.dispose();
  }

  _navigateBack(BuildContext context) {
    Navigator.of(context).pop(CardDetailBackArguments(widget._cardId, _isBlackListed));
  }

  _showBottomSheet(context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15), topRight: Radius.circular(15))),
              child: VisitsByUser(
                businessId: widget._cardId,
              ),
            ),
          );
        });
  }

  Widget _buildIcon(bool isBlackListed) {
    return isBlackListed
        ? RoundedIcon(
            onClick: () => _toggleBlacklistBloc
                .dispatch(ToggleNotificationBlackListEvent(cardId: widget._cardId)),
            assetIcon: "assets/notification_off.png",
          )
        : RoundedIcon(
            onClick: () => _toggleBlacklistBloc
                .dispatch(ToggleNotificationBlackListEvent(cardId: widget._cardId)),
            assetIcon: "assets/ic_bell.png",
          );
  }

  Widget _selectNotificationIconByState(ToggleBlacklistState state) {
    if (state is ToggleBlackListSuccess) {
      _isBlackListed = state.isBlackListed;
      return _buildIcon(state.isBlackListed);
    } else if (state is ToggleBlackListLoading) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(height: 20, width: 20, child: CircularProgressIndicator()),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> tagsColors = CarlTheme.of(context).tagsColors;

    return WillPopScope(
      onWillPop: () => _navigateBack(context),
      child: Scaffold(
        body: Container(
            color: CarlTheme.of(context).background,
            child: SafeArea(
              child: Padding(
                padding: CarlTheme.of(context).pagePadding,
                child: BlocBuilder<CardDetailEvent, CardDetailState>(
                  bloc: _cardDetailBloc,
                  builder: (BuildContext buildContext, CardDetailState state) {
                    if (state is CardByIdLoading) {
                      return Center(
                        child: Loader(),
                      );
                    } else if (state is CardByIdLoadingError) {
                      return Center(
                        child: ErrorApiCall(
                          errorTitle: state.isNetworkError
                              ? Translations.of(context).text("network_error_title")
                              : Translations.of(context).text("error_server_title"),
                          errorDescription: state.isNetworkError
                              ? Translations.of(context).text("network_error_description")
                              : Translations.of(context).text("error_server_description"),
                        ),
                      );
                    } else if (state is CardByIdLoadingSuccess) {
                      final cardHeight = MediaQuery.of(context).size.height * .2;
                      final percentIndicatorSize = MediaQuery.of(context).size.width * .25;
                      final card = state.card.business;
                      final userProgression = state.card.userVisitsCount % card.total == 0 &&
                              state.card.userVisitsCount > 0
                          ? card.total
                          : state.card.userVisitsCount % card.total;
                      _isBlackListed = state.isBlackListed;
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    BlocBuilder<ToggleBlacklistEvent, ToggleBlacklistState>(
                                      bloc: _toggleBlacklistBloc,
                                      builder:
                                          (BuildContext context, ToggleBlacklistState toggleState) {
                                        if (toggleState is ToggleBlackInitialState) {
                                          return _buildIcon(state.isBlackListed);
                                        } else {
                                          return _selectNotificationIconByState(toggleState);
                                        }
                                      },
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(22.0),
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.white, boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              offset: Offset(3.0, 6.0),
                                              blurRadius: 10.0)
                                        ]),
                                        width: cardHeight * .8,
                                        height: cardHeight,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: <Widget>[
                                            FadeInImage(
                                              fit: BoxFit.cover,
                                              placeholder:
                                                  AssetImage(Constants.IMAGE_PLACEHOLDER_URL),
                                              image: NetworkImage(card.image.url),
                                            ),
                                            Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white, shape: BoxShape.circle),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Image.network(
                                                    card.logo.url,
                                                    height: cardHeight * .2,
                                                    width: cardHeight * .2,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    RoundedIcon(
                                      assetIcon: "assets/ic_option.png",
                                      onClick: () {
                                        _showBottomSheet(context);
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  card.businessName,
                                  style: CarlTheme.of(context).bigBlackTitle,
                                ),
                                ClickableText(
                                    clickedColor: Colors.black,
                                    text: card.businessAddress,
                                    textStyle: CarlTheme.of(context).greyLittleLabel,
                                    onClick: () {
                                      Navigator.of(context).pushNamed(MapSearch.routeName,
                                          arguments: MapSearchArguments(
                                              latitude: card.latitude, longitude: card.longitude));
                                    }),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: card.tags.length > 0 ? 25 : 0,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: card.tags.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Row(
                                          children: <Widget>[
                                            TagItem(
                                              color: tagsColors[index % tagsColors.length],
                                              name: card.tags[index].name,
                                              textStyle: CarlTheme.of(context).whiteMediumLabel,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        );
                                      }),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: <Widget>[
                                    Material(
                                      elevation: 10,
                                      type: MaterialType.circle,
                                      color: Colors.transparent,
                                      child: Container(
                                        width: percentIndicatorSize,
                                        height: percentIndicatorSize,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle, color: Colors.white),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: CustomPaint(
                                            foregroundPainter: CardPercentIndicatorPainter(
                                                lineColor: Colors.transparent,
                                                completeColor: CarlTheme.of(context)
                                                    .percentIndicatorCompleteColor,
                                                completePercent: userProgression / card.total * 100,
                                                width: 10.0),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Text("$userProgression",
                                                      style: CarlTheme.of(context).blackBigNumber),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text("/",
                                                      style:
                                                          CarlTheme.of(context).blackMediumNumber),
                                                  Text("${card.total}",
                                                      style:
                                                          CarlTheme.of(context).blackMediumNumber),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * .8,
                                      height: MediaQuery.of(context).size.height * .15,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15.0)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Text(card.description ?? "No description",
                                                textAlign: TextAlign.center,
                                                style: CarlTheme.of(context).blackMediumLabel),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                            Container(
                                child: CircleImageInkWell(
                              onPressed: () => _navigateBack(context),
                              size: 50,
                              image: AssetImage('assets/ic_close.png'),
                              splashColor: Colors.black26,
                            ))
                          ],
                        ),
                      );
                    } else {
                      return Container(color: CarlTheme.of(context).background);
                    }
                  },
                ),
              ),
            )),
      ),
    );
  }
}
