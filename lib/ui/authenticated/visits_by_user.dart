import 'package:carl/blocs/visits/visits_bloc.dart';
import 'package:carl/blocs/visits/visits_event.dart';
import 'package:carl/blocs/visits/visits_state.dart';
import 'package:carl/data/providers/user_dummy_provider.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:carl/data/repository_dealer.dart';
import 'package:carl/localization/localization.dart';
import 'package:carl/models/business/visit.dart';
import 'package:carl/ui/shared/error_api_call.dart';
import 'package:carl/ui/shared/loader.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'empty_element.dart';

const int VISITS_PER_PAGE = 10;

class VisitsByUser extends StatelessWidget {
  final int businessId;
  VisitsBloc _visitsBloc;
  List<Visit> _visits;
  bool _hasReachedMax = false;

  VisitsByUser({Key key, this.businessId}) : super(key: key);

  _renderList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                Localization.of(context).visitsHistoricTitle,
                style: CarlTheme.of(context).blackMediumBoldLabel,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: ListView.builder(
                itemCount: _visits.length + (_hasReachedMax ? 0 : 1),
                itemBuilder: (BuildContext context, int index) {
                  if (index == _visits.length) {
                    if (_visits.length % VISITS_PER_PAGE == 0) {
                      _visitsBloc.dispatch(LoadMoreVisitsEvent(businessId, VISITS_PER_PAGE,
                            lastFetchedDate: _visits[index - 1].date));
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Loader(),
                        ),
                      );
                    } else {
                      return Container(
                        width: 0,
                        height: 0,
                      );
                    }
                  }
                  return VisitItem(
                    visit: _visits[index],
                  );
                }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _visitsBloc = VisitsBloc(RepositoryDealer.of(context).userRepository);
    _visitsBloc.dispatch(RetrieveVisitsEvent(businessId, VISITS_PER_PAGE));
    return Container(
      height: MediaQuery.of(context).size.height * .5,
      child: BlocBuilder<VisitsEvent, VisitsState>(
        bloc: _visitsBloc,
        builder: (BuildContext context, VisitsState state) {
          if (state is VisitsLoading) {
            return Center(child: Loader());
          } else if (state is VisitsLoadingSuccess) {
            _visits = state.visits;
            if (_visits.isEmpty) {
              return EmptyElement(
                assetImageUrl: "assets/empty_cards.png",
                title: Localization.of(context).emptyVisitsLabel,
                description: "",
              );
            }
            return _renderList(context);
          } else if (state is LoadMoreSuccessState) {
            _visits.addAll(state.visits);
            _hasReachedMax = state.hasReachedMax;
            return _renderList(context);
          } else if (state is VisitsLoadingError) {
            return ErrorApiCall(
              errorTitle: state.isNetworkError
                  ? Localization.of(context).networkErrorTitle
                  : Localization.of(context).errorServerTitle,
              errorDescription: state.isNetworkError
                  ? Localization.of(context).networkErrorDescription
                  : Localization.of(context).errorServerDescription,
            );
          }
        },
      ),
    );
  }
}

class VisitItem extends StatelessWidget {
  final Visit visit;

  const VisitItem({Key key, this.visit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Colors.black12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "${Localization.of(context).getWeekDays[visit.localDate.weekday - 1][0].toUpperCase()}${Localization.of(context).getWeekDays[visit.localDate.weekday - 1].substring(1)}",
                      style: CarlTheme.of(context).blackMediumBoldLabel,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      visit.localDate.day.toString(),
                      style: CarlTheme.of(context).blackMediumBoldLabel,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      Localization.of(context).getMonths[visit.localDate.month - 1],
                      style: CarlTheme.of(context).blackMediumBoldLabel,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      visit.localDate.year.toString(),
                      style: CarlTheme.of(context).blackMediumBoldLabel,
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Text(
                "${visit.localDate.hour.toString().padLeft(2, '0')}h${visit.localDate.minute.toString().padLeft(2, '0')}",
                style: CarlTheme.of(context).black12MediumLabel,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
