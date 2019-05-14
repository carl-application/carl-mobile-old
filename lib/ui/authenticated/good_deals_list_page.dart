import 'package:carl/blocs/good_deals/good_deals_bloc.dart';
import 'package:carl/blocs/good_deals/good_deals_event.dart';
import 'package:carl/blocs/good_deals/good_deals_state.dart';
import 'package:carl/data/providers/user_api_provider.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:carl/ui/shared/loader.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_ink_well/image_ink_well.dart';

class GoodDealsListPage extends StatefulWidget {
  static const routeName = "/goodDealsListPage";

  @override
  _GoodDealsListPageState createState() => _GoodDealsListPageState();
}

class _GoodDealsListPageState extends State<GoodDealsListPage> {
  GoodDealsBloc _goodDealsBloc;

  @override
  initState() {
    super.initState();
    _goodDealsBloc = GoodDealsBloc(UserRepository(userProvider: UserApiProvider()));
    _goodDealsBloc.dispatch(RetrieveGoodDealsEvent());
  }

  @override
  dispose() {
    _goodDealsBloc.dispose();
    super.dispose();
  }

  _navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  Widget _buildUnReadLabel() {
    return Container(
      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Text(
          "New !",
          style: CarlTheme.of(context).whiteMediumLabel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: CarlTheme.of(context).background,
      child: SafeArea(
        child: Padding(
          padding: CarlTheme.of(context).pagePadding,
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  "Bons plans",
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
                    } else if (state is GoodDealsLoadingSuccess) {
                      final deals = state.goodDeals;
                      return ListView.builder(
                        itemCount: deals.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: <Widget>[
                              Padding(
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
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              deals[index].businessName,
                                              style: CarlTheme.of(context).blackMediumBoldLabel,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              deals[index].title,
                                              style: CarlTheme.of(context).blackMediumLabel,
                                            ),
                                            Text(
                                              deals[index].shortDescription,
                                              style: CarlTheme.of(context).greyMediumLabel,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: deals[index].seen == false ? _buildUnReadLabel() : Container(),
                              )
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              CircleImageInkWell(
                onPressed: () => _navigateBack(context),
                size: 50,
                image: AssetImage('assets/ic_close.png'),
                splashColor: Colors.black26,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
