import 'package:carl/blocs/good_deals/good_deals_bloc.dart';
import 'package:carl/blocs/good_deals/good_deals_event.dart';
import 'package:carl/blocs/good_deals/good_deals_state.dart';
import 'package:carl/data/repository_dealer.dart';
import 'package:carl/models/good_deal.dart';
import 'package:carl/translations.dart';
import 'package:carl/ui/authenticated/empty_element.dart';
import 'package:carl/ui/authenticated/good_deal_detail_dialog.dart';
import 'package:carl/ui/shared/error_api_call.dart';
import 'package:carl/ui/shared/loader.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_ink_well/image_ink_well.dart';

class GoodDealsList extends StatelessWidget {
  static const routeName = "/goodDealsListPage";

  _navigateToDetail(BuildContext context, GoodDeal deal, VoidCallback onRead) async {
    //Navigator.of(context).pushNamed(GoodDealDetailPage.routeName, arguments: deal.id);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GoodDealDetailDialog(id: deal.id, onRead: onRead,);
        });
  }

  _navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  Widget _buildUnReadLabel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Text(
          Translations.of(context).text("new"),
          style: CarlTheme.of(context).whiteMediumLabel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _goodDealsBloc = GoodDealsBloc(RepositoryDealer.of(context).userRepository);
    _goodDealsBloc.dispatch(RetrieveGoodDealsEvent());
    return Scaffold(
        body: Container(
      color: CarlTheme.of(context).background,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              top: CarlTheme.of(context).pageVerticalPadding,
              left: CarlTheme.of(context).pageHorizontalPadding,
              right: CarlTheme.of(context).pageHorizontalPadding,
          ),
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  Translations.of(context).text("good_deals_title"),
                  style: CarlTheme.of(context).blackTitle,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: BlocBuilder<GoodDealsEvent, GoodDealsState>(
                  bloc: _goodDealsBloc,
                  builder: (BuildContext context, GoodDealsState state) {
                    if (state is GoodDealsLoading) {
                      return Center(child: Loader());
                    } else if (state is GoodDealsLoadingError) {
                      return Center(
                          child: ErrorApiCall(
                        errorTitle: state.isNetworkError
                            ? Translations.of(context).text("network_error_title")
                            : Translations.of(context).text("error_server_title"),
                        errorDescription: state.isNetworkError
                            ? Translations.of(context).text("network_error_description")
                            : Translations.of(context).text("error_server_description"),
                      ));
                    } else if (state is GoodDealsLoadingSuccess) {
                      final deals = state.goodDeals;
                      if (deals.isEmpty) {
                        return EmptyElement(
                          assetImageUrl: "assets/ic_idea.png",
                          title: Translations.of(context).text("empty_good_deals_title"),
                          description:
                              Translations.of(context).text("empty_good_deals_description"),
                        );
                      }
                      return AnimatedList(
                        initialItemCount: deals.length,
                        itemBuilder:
                            (BuildContext context, int index, Animation<double> animation) {
                          return Stack(
                            children: <Widget>[
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                margin: EdgeInsets.all(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      deals[index].businessName,
                                                      style: CarlTheme.of(context)
                                                          .blackMediumBoldLabel,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      deals[index].title,
                                                      style: CarlTheme.of(context).blackMediumLabel,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      deals[index].description,
                                                      style: CarlTheme.of(context).greyMediumLabel,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Image.asset(
                                                "assets/ic_arrow_right.png",
                                                height: 50,
                                                width: 50,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Material(
                                    child: InkWell(
                                      onTap: () {
                                        _navigateToDetail(context, deals[index], () {
                                          print("haveRead notification");
                                          _goodDealsBloc.dispatch(HaveReadGoodDealEvent(index));
                                        });
                                      },
                                    ),
                                    type: MaterialType.transparency,
                                    borderRadius: BorderRadius.circular(20.0),
                                    clipBehavior: Clip.antiAlias,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 10,
                                child: deals[index].seen == false
                                    ? _buildUnReadLabel(context)
                                    : Container(),
                              )
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleImageInkWell(
                  onPressed: () => _navigateBack(context),
                  size: 50,
                  image: AssetImage('assets/ic_close.png'),
                  splashColor: Colors.black26,
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
