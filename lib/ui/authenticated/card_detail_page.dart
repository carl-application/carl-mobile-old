import 'dart:ui';

import 'package:carl/blocs/card_detail/card_detail_bloc.dart';
import 'package:carl/blocs/card_detail/card_detail_event.dart';
import 'package:carl/blocs/card_detail/card_detail_state.dart';
import 'package:carl/blocs/toggle_blacklist/toggle_blacklist_bloc.dart';
import 'package:carl/blocs/toggle_blacklist/toggle_blacklist_event.dart';
import 'package:carl/blocs/toggle_blacklist/toggle_blacklist_state.dart';
import 'package:carl/data/providers/user_api_provider.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:carl/localization/localization.dart';
import 'package:carl/models/navigation_arguments/card_detail_arguments.dart';
import 'package:carl/models/navigation_arguments/card_detail_back_arguments.dart';
import 'package:carl/models/navigation_arguments/scan_nfc_arguments.dart';
import 'package:carl/ui/authenticated/nfc_scan_page.dart';
import 'package:carl/ui/authenticated/visits_by_user.dart';
import 'package:carl/ui/shared/carl_blue_gradient_button.dart';
import 'package:carl/ui/shared/loader.dart';
import 'package:carl/ui/shared/rounded_icon.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_ink_well/image_ink_well.dart';

import 'card_percent_indicator_painter.dart';

class CardDetailPage extends StatefulWidget {
  static const routeName = "/cardDetailPage";

  int _cardId;

  CardDetailPage(CardDetailArguments arguments) {
    this._cardId = arguments.cardId;
  }

  @override
  _CardDetailPageState createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> with TickerProviderStateMixin {
  CardDetailBloc _cardDetailBloc;
  ToggleBlacklistBloc _toggleBlacklistBloc;
  bool _isBlackListed = false;

  @override
  void initState() {
    super.initState();
    _cardDetailBloc = CardDetailBloc(UserRepository(userProvider: UserApiProvider()));
    _toggleBlacklistBloc = ToggleBlacklistBloc(UserRepository(userProvider: UserApiProvider()));
    _cardDetailBloc.dispatch(RetrieveCardByIdEvent(cardId: widget._cardId));
  }

  @override
  void dispose() {
    _toggleBlacklistBloc.dispose();
    _cardDetailBloc.dispose();
    super.dispose();
  }

  _navigateToScan(BuildContext context) {
    Navigator.of(context).pushNamed(NfcScanPage.routeName, arguments: CallSource.detail);
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
      return Container(height: 40, width: 40, child: CircularProgressIndicator());
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
                    } else if (state is CardByIdLoadingSuccess) {
                      final cardHeight = MediaQuery.of(context).size.height * .2;
                      final percentIndicatorSize = MediaQuery.of(context).size.width * .25;
                      final card = state.card.business;
                      final userProgression = state.card.userVisitsCount;
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
                                              placeholder: AssetImage('assets/carl_face.png'),
                                              image: NetworkImage(card.image.url),
                                            ),
                                            Center(
                                              child: ClipRRect(
                                                borderRadius: new BorderRadius.circular(50.0),
                                                child: Image.network(
                                                  card.logo.url,
                                                  height: cardHeight * .3,
                                                  width: cardHeight * .3,
                                                  fit: BoxFit.cover,
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
                                Text(
                                  card.businessAddress,
                                  style: CarlTheme.of(context).greyLittleLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(15.0),
                                              child: Container(
                                                color: tagsColors[index % tagsColors.length],
                                                child: Center(
                                                    child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 15.0, vertical: 5.0),
                                                  child: Text(
                                                    card.tags[index].name,
                                                    style: CarlTheme.of(context).whiteMediumLabel,
                                                  ),
                                                )),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        );
                                      }),
                                ),
                                SizedBox(
                                  height: 10,
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
                                  height: 10,
                                ),
                              ],
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  CarlBlueGradientButton(
                                    text: Localization.of(context).add,
                                    onPressed: () => _navigateToScan(context),
                                    width: MediaQuery.of(context).size.width * .5,
                                    textStyle: CarlTheme.of(context).whiteMediumLabel,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CircleImageInkWell(
                                    onPressed: () => _navigateBack(context),
                                    size: 40,
                                    image: AssetImage('assets/ic_close.png'),
                                    splashColor: Colors.black26,
                                  )
                                ],
                              ),
                            )
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
