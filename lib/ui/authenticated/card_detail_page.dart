import 'package:carl/blocs/cards/cards_bloc.dart';
import 'package:carl/blocs/cards/cards_event.dart';
import 'package:carl/blocs/cards/cards_state.dart';
import 'package:carl/data/providers/user_api_provider.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:carl/localization/localization.dart';
import 'package:carl/ui/shared/carl_button.dart';
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

  final int cardId;

  CardDetailPage(this.cardId);

  @override
  _CardDetailPageState createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  CardsBloc _cardsBloc;

  @override
  void initState() {
    super.initState();
    _cardsBloc = CardsBloc(UserRepository(userProvider: UserApiProvider()));
    _cardsBloc.dispatch(RetrieveCardByIdEvent(cardId: widget.cardId));
  }

  @override
  void dispose() {
    _cardsBloc.dispose();
    super.dispose();
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
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.music_note),
                    title: new Text('Music'),
                  ),
                  new ListTile(
                    leading: new Icon(Icons.photo_album),
                    title: new Text('Photos'),
                  ),
                  new ListTile(
                    leading: new Icon(Icons.videocam),
                    title: new Text('Video'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> tagsColors = CarlTheme.of(context).tagsColors;

    return Scaffold(
      body: Container(
          color: CarlTheme.of(context).background,
          child: SafeArea(
            child: Padding(
              padding: CarlTheme.of(context).pagePadding,
              child: BlocBuilder<CardsEvent, CardsState>(
                bloc: _cardsBloc,
                builder: (BuildContext buildContext, CardsState state) {
                  if (state is CardByIdLoading) {
                    return Center(
                      child: Loader(),
                    );
                  } else if (state is CardByIdLoadingSuccess) {
                    final cardHeight = MediaQuery.of(context).size.height * .2;
                    final percentIndicatorSize = MediaQuery.of(context).size.width * .3;
                    final card = state.card.business;
                    final userProgression = state.card.userVisitsCount;
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
                                  RoundedIcon(
                                    assetIcon: "assets/ic_bell.png",
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
                                height: 15,
                              ),
                              Text(
                                card.businessName,
                                style: CarlTheme.of(context).bigBlackTitle,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                card.businessAddress,
                                style: CarlTheme.of(context).greyMediumLabel,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 30,
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
                                height: 40,
                              ),
                              Column(
                                children: <Widget>[
                                  Material(
                                    elevation: 20,
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
                                                    style: CarlTheme.of(context).blackMediumNumber),
                                                Text("${card.total}",
                                                    style: CarlTheme.of(context).blackMediumNumber),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 35,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * .8,
                                    height: 100,
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                CarlButton(
                                  text: Localization.of(context).add,
                                  onPressed: () {},
                                  width: MediaQuery.of(context).size.width * .5,
                                  height: 20,
                                  color: CarlTheme.of(context).accentColor,
                                  textStyle: CarlTheme.of(context).whiteBigLabel,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                CircleImageInkWell(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  size: 50,
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
    );
  }
}
