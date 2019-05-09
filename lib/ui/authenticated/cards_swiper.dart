import 'dart:math';

import 'package:carl/models/business_card.dart';
import 'package:carl/ui/authenticated/card_detail_page.dart';
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
            padding: const EdgeInsets.all(5.0),
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
              Positioned.fromRect(
                rect: Rect.fromPoints(
                    Offset(15, 15), Offset(MediaQuery.of(context).size.width * .75, 2000)),
                child: PageView.builder(
                  itemCount: cards.length,
                  controller: controller,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          final BusinessCard card = cards[controller.page.toInt()];
                          print("Clicked on card ${card.businessName}");
                          Navigator.pushNamed(
                            context,
                            CardDetailPage.routeName,
                            arguments: card.id,
                          );
                        },
                        child: Container(color: Colors.transparent));
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
            child: CardItem(
              card: cards[index],
              cardAspectRatio: cardAspectRatio,
              position: index,
              total: cards.length,
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

class CardItem extends StatelessWidget {
  final BusinessCard card;
  final double cardAspectRatio;
  final int position;
  final int total;

  CardItem({this.card, this.cardAspectRatio, this.position, this.total});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
                card.imageUrl,
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.black12,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    "assets/ic_bell_card.png",
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
              Center(
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(50.0),
                  child: Image.network(
                    card.logo,
                    height: 100.0,
                    width: 100.0,
                  ),
                ),
              ),
              if (position != null)
                Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text("${total - position}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "SF-Pro-Text-Regular")),
                          Text("/ $total",
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
    );
  }
}
