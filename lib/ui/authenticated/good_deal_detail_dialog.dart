import 'package:carl/blocs/good_deal_detail/good_deal_detail_bloc.dart';
import 'package:carl/blocs/good_deal_detail/good_deal_detail_event.dart';
import 'package:carl/blocs/good_deal_detail/good_deal_detail_state.dart';
import 'package:carl/blocs/unread_notifications/unread_notification_event.dart';
import 'package:carl/blocs/unread_notifications/unread_notifications_bloc.dart';
import 'package:carl/data/repository_dealer.dart';
import 'package:carl/ui/shared/loader.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoodDealDetailDialog extends StatefulWidget {
  final int id;
  final VoidCallback onRead;

  const GoodDealDetailDialog({Key key, this.id, this.onRead}) : super(key: key);

  @override
  _GoodDealDetailDialogState createState() => _GoodDealDetailDialogState();
}

class _GoodDealDetailDialogState extends State<GoodDealDetailDialog> {
  GoodDealDetailBloc _goodDealDetailBloc;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _goodDealDetailBloc = GoodDealDetailBloc(RepositoryDealer.of(context).userRepository);
    _goodDealDetailBloc.dispatch(RetrieveGoodDealByIdEvent(id: widget.id));
  }

  @override
  dispose() {
    _goodDealDetailBloc.dispose();
    super.dispose();
  }

  _navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  _notifyReading() {
    BlocProvider.of<UnreadNotificationsBloc>(context).dispatch(RemoveOneUnreadNotificationsEvent());
    if (widget.onRead != null) {
      widget.onRead();
    }
  }

  @override
  Widget build(BuildContext context) {
    final logoSize = MediaQuery.of(context).size.width * .2;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: Container(
        height: MediaQuery.of(context).size.height * .7,
        width: MediaQuery.of(context).size.width * .8,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
        child: BlocBuilder<GoodDealDetailEvent, GoodDealDetailState>(
            bloc: _goodDealDetailBloc,
            builder: (BuildContext context, GoodDealDetailState state) {
              if (state is GoodDealByIdLoading) {
                return Center(
                  child: Loader(),
                );
              } else if (state is GoodDealByIdLoadingSuccess) {
                SchedulerBinding.instance.addPostFrameCallback((_) => _notifyReading());
                final goodDeal = state.goodDeal;
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Image.network(
                            goodDeal.logo,
                            height: logoSize,
                            width: logoSize,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          goodDeal.businessName,
                          style: CarlTheme.of(context).notificationDetailBusinessName,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          goodDeal.title,
                          style: CarlTheme.of(context).notificationDetailTitle,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          goodDeal.description,
                          style: CarlTheme.of(context).notificationDetailDescription,
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is GoodDealByIdLoadingError) {
                return Center(
                  child: Text("error on api call"),
                );
              }
            }),
      ),
    );
    return WillPopScope(
      onWillPop: () => _navigateBack(context),
      child: Scaffold(
        backgroundColor: CarlTheme.of(context).background,
        body: SafeArea(
          child: Padding(
            padding: CarlTheme.of(context).pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: IconButton(
                    onPressed: () => _navigateBack(context),
                    icon: Icon(
                      Icons.arrow_back,
                      size: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: BlocBuilder<GoodDealDetailEvent, GoodDealDetailState>(
                      bloc: _goodDealDetailBloc,
                      builder: (BuildContext context, GoodDealDetailState state) {
                        if (state is GoodDealByIdLoading) {
                          return Center(
                            child: Loader(),
                          );
                        } else if (state is GoodDealByIdLoadingSuccess) {
                          SchedulerBinding.instance.addPostFrameCallback((_) =>
                              BlocProvider.of<UnreadNotificationsBloc>(context)
                                  .dispatch(RemoveOneUnreadNotificationsEvent()));
                          final goodDeal = state.goodDeal;
                          return Padding(
                            padding: EdgeInsets.all(10),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    goodDeal.businessName,
                                    style: CarlTheme.of(context).blueTitle,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    goodDeal.title,
                                    style: CarlTheme.of(context).blackTitle,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    goodDeal.shortDescription,
                                    style: CarlTheme.of(context).blackMediumLabel,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    goodDeal.description,
                                    style: CarlTheme.of(context).blackMediumLabel,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (state is GoodDealByIdLoadingError) {
                          return Center(
                            child: Text("error on api call"),
                          );
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
