import 'dart:math';

import 'package:carl/models/black_listed.dart';
import 'package:carl/models/business/business_card.dart';
import 'package:carl/models/navigation_arguments/card_detail_arguments.dart';
import 'package:carl/models/navigation_arguments/card_detail_back_arguments.dart';
import 'package:carl/ui/authenticated/pages/card_detail.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../constants.dart';

class CardsSwiper extends StatefulWidget {
  final List<BusinessCard> cards;
  final List<BlackListed> blackListed;

  const CardsSwiper({Key key, this.cards, this.blackListed}) : super(key: key);

  @override
  _CardsSwiperState createState() => _CardsSwiperState();
}

class _CardsSwiperState extends State<CardsSwiper> {
  double currentPage;
  BusinessCard currentCard;
  PageController controller;

  get cards => widget.cards;

  List<BlackListed> blackListedBusinesses;

  @override
  void initState() {
    blackListedBusinesses = widget.blackListed;
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

  _navigateToDetail(BuildContext context) async {
    final BusinessCard card = cards[controller.page.toInt()];
    print("Clicked on card ${card.businessName}");
    final arguments = await Navigator.pushNamed(context, CardDetail.routeName,
        arguments: CardDetailArguments(card.id));

    print("Arguments back from detail are $arguments");
    if (arguments is CardDetailBackArguments) {
      if (arguments.isBlacklisted) {
        final temp = blackListedBusinesses
            .where((blackListed) => blackListed.blackListedBusiness.id == arguments.cardId);
        if (temp.isEmpty) {
          setState(() {
            blackListedBusinesses.add(BlackListed(0, BlackListedBusiness(arguments.cardId)));
          });
        }
      } else {
        final temp = blackListedBusinesses
            .where((blackListed) => blackListed.blackListedBusiness.id == arguments.cardId);
        if (temp.isNotEmpty) {
          setState(() {
            blackListedBusinesses.removeWhere(
                (blackListed) => blackListed.blackListedBusiness.id == arguments.cardId);
          });
        }
      }
    }
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              CardScrollWidget(
                  currentPage: currentPage,
                  cards: cards,
                  blackListedBusinesses: blackListedBusinesses),
              Positioned.fromRect(
                rect: Rect.fromPoints(
                    Offset(15, 15), Offset(MediaQuery.of(context).size.width * .75, 2000)),
                child: PageView.builder(
                  itemCount: cards.length,
                  controller: controller,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () => _navigateToDetail(context),
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
  final List<BlackListed> blackListedBusinesses;
  var padding = 15.0;
  var verticalInset = 10.0;

  CardScrollWidget({this.currentPage, this.cards, this.blackListedBusinesses});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      height: MediaQuery.of(context).size.width * .9,
      child: new AspectRatio(
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

          var fakePaddingLeft = 0.0;
          if (cards.length == 2) {
            fakePaddingLeft = width * .1;
          } else if (cards.length == 1) {
            fakePaddingLeft = width * .125;
          }


          for (var index = 0; index < cards.length; index++) {
            var delta = index - currentPage;
            bool isOnRight = delta > 0;
            bool isInBlackList = blackListedBusinesses
                .where((blackListed) => blackListed.blackListedBusiness.id == cards[index].id)
                .isNotEmpty;

            var start = padding - fakePaddingLeft +
                max(primaryCardLeft - horizontalInset * -delta * (isOnRight ? 15 : 1), 0.0);

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
                isBlackListed: isInBlackList,
              ),
            );
            cardList.add(cardItem);
          }
          return Stack(
            children: cardList,
          );
        }),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final BusinessCard card;
  final double cardAspectRatio;
  final int position;
  final int total;
  final bool isBlackListed;

  CardItem(
      {this.card,
      this.cardAspectRatio,
      this.position,
      this.total,
      this.isBlackListed});

  @override
  Widget build(BuildContext context) {
    final logoSize = MediaQuery.of(context).size.width * .2;
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
              FadeInImage(
                fit: BoxFit.cover,
                placeholder: AssetImage(Constants.IMAGE_PLACEHOLDER_URL),
                image: NetworkImage(card.image.url),
              ),
              Container(
                color: Colors.black12,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: isBlackListed
                      ? Image.asset(
                          "assets/notification_off.png",
                          width: 30,
                          height: 30,
                        )
                      : Image.asset(
                          "assets/ic_bell_card.png",
                          width: 50,
                          height: 50,
                        ),
                ),
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.network(
                      card.logo.url,
                      height: 50,
                      width: 50,
                      fit: BoxFit.contain,
                    ),
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
