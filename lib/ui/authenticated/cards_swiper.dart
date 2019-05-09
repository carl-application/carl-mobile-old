import 'dart:math';

import 'package:carl/models/business_card.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CardsSwiper extends StatefulWidget {
  final List<BusinessCard> cards;

  const CardsSwiper({Key key, this.cards}) : super(key: key);

  @override
  _CardsSwiperState createState() => _CardsSwiperState();
}

class _CardsSwiperState extends State<CardsSwiper> {
  double currentPage;
  BusinessCard currentCard;
  PageController controller;

  get cards => this.widget.cards;

  @override
  void initState() {
    controller = PageController(initialPage: cards.length - 1);
    currentPage = cards.length - 1.0;
    currentCard = cards[cards.length - 1];
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
        currentCard = cards[controller.page.toInt()];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  currentCard.businessName,
                  style: CarlTheme.of(context).blackTitle,
                ),
                Text(
                  currentCard.businessAddress,
                  style: CarlTheme.of(context).greyMediumLabel,
                )
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              CardScrollWidget(
                currentPage: currentPage,
                cards: cards,
              ),
              Positioned.fill(
                child: PageView.builder(
                  itemCount: cards.length,
                  controller: controller,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return Container();
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class CardScrollWidget extends StatelessWidget {
  final double currentPage;
  final List<BusinessCard> cards;
  var padding = 15.0;
  var verticalInset = 10.0;

  CardScrollWidget({this.currentPage, this.cards});

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();

        for (var index = 0; index < cards.length; index++) {
          var delta = index - currentPage;
          bool isOnRight = delta > 0;

          var start =
              padding + max(primaryCardLeft - horizontalInset * -delta * (isOnRight ? 15 : 1), 0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(color: Colors.black12, offset: Offset(3.0, 6.0), blurRadius: 10.0)
                ]),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.network(
                        cards[index].imageUrl,
                        fit: BoxFit.cover,
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text("${cards.length - index}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "SF-Pro-Text-Regular")),
                                Text("/ ${cards.length}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22.0,
                                        fontFamily: "SF-Pro-Text-Regular")),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}
