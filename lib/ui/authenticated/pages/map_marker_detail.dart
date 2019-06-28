import 'package:carl/constants.dart';
import 'package:carl/models/business/business_card.dart';
import 'package:carl/ui/authenticated/tag_item.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';

class MapMarkerDetail extends StatelessWidget {
  MapMarkerDetail({this.business});

  final BusinessCard business;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => print("ok"),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 5,),
                        Container(
                          height: 40,
                          width: 40,
                          child: FadeInImage(
                            fit: BoxFit.cover,
                            placeholder: AssetImage(Constants.IMAGE_PLACEHOLDER_URL),
                            image: NetworkImage(business.logo.url),
                          ),
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
                              SizedBox(height: 10,),
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
                                  height: 25,
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
                                            SizedBox(width: 5,)
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
