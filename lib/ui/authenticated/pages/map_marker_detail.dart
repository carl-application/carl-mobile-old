import 'package:carl/constants.dart';
import 'package:carl/models/business/business_card.dart';
import 'package:carl/models/navigation_arguments/card_detail_arguments.dart';
import 'package:carl/ui/authenticated/pages/card_detail.dart';
import 'package:carl/ui/authenticated/tag_item.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';

class MapMarkerDetail extends StatelessWidget {
  MapMarkerDetail({this.business});

  final BusinessCard business;

  _openCardDetail(BuildContext context, BusinessCard card) {
    Navigator.pushNamed(context, CardDetail.routeName, arguments: CardDetailArguments(card.id));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 160,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openCardDetail(context, business),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          child: Image.network(business.logo.url)
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                business.businessName,
                                style: CarlTheme.of(context).blackMediumBoldLabel,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      business.businessAddress,
                                      style: CarlTheme.of(context).greyLittleLabel,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    width: MediaQuery.of(context).size.width * .6,
                                  ),
                                  Image.asset(
                                    "assets/ic_arrow_right.png",
                                    height: 30,
                                    width: 30,
                                  )
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  height: 30,
                                  width: MediaQuery.of(context).size.width * .7,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: business.tags.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Row(
                                          children: <Widget>[
                                            TagItem(
                                              color: CarlTheme.of(context).tagsColors[
                                                  index % CarlTheme.of(context).tagsColors.length],
                                              name: business.tags[index].name,
                                              textStyle: CarlTheme.of(context).whiteMediumLabel,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            )
                                          ],
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
