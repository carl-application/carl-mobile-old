import 'package:carl/blocs/visits/visits_bloc.dart';
import 'package:carl/blocs/visits/visits_event.dart';
import 'package:carl/blocs/visits/visits_state.dart';
import 'package:carl/data/repository_dealer.dart';
import 'package:carl/localization/localization.dart';
import 'package:carl/models/business/visit.dart';
import 'package:carl/ui/shared/error_api_call.dart';
import 'package:carl/ui/shared/loader.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VisitsByUser extends StatefulWidget {
  final int businessId;

  const VisitsByUser({Key key, this.businessId}) : super(key: key);

  @override
  _VisitsByUserState createState() => _VisitsByUserState();
}

class _VisitsByUserState extends State<VisitsByUser> {
  VisitsBloc _visitsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _visitsBloc = VisitsBloc(RepositoryDealer
        .of(context)
        .userRepository);
    _visitsBloc.dispatch(RetrieveVisitsEvent(widget.businessId, 10));
  }

  @override
  void dispose() {
    _visitsBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * .5,
      child: BlocBuilder<VisitsEvent, VisitsState>(
        bloc: _visitsBloc,
        builder: (BuildContext context, VisitsState state) {
          if (state is VisitsLoading) {
            return Center(child: Loader());
          } else if (state is VisitsLoadingSuccess) {
            final visits = state.visits;
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        Localization
                            .of(context)
                            .visitsHistoricTitle,
                        style: CarlTheme
                            .of(context)
                            .blackMediumBoldLabel,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: ListView.builder(
                        itemCount: visits.length,
                        itemBuilder: (BuildContext context, int index) {
                          return VisitItem(
                            visit: visits[index],
                          );
                        }),
                  ),
                ],
              ),
            );
          } else if (state is VisitsLoadingError) {
            return ErrorApiCall(
              errorTitle: state.isNetworkError
                  ? Localization
                  .of(context)
                  .networkErrorTitle
                  : Localization
                  .of(context)
                  .errorServerTitle,
              errorDescription: state.isNetworkError
                  ? Localization
                  .of(context)
                  .networkErrorDescription
                  : Localization
                  .of(context)
                  .errorServerDescription,
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
                      "${Localization
                          .of(context)
                          .getWeekDays[visit.date.weekday - 1][0].toUpperCase()}${Localization
                          .of(context)
                          .getWeekDays[visit.date.weekday - 1].substring(1)}",
                      style: CarlTheme
                          .of(context)
                          .blackMediumBoldLabel,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      visit.date.day.toString(),
                      style: CarlTheme
                          .of(context)
                          .blackMediumBoldLabel,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      Localization
                          .of(context)
                          .getMonths[visit.date.month - 1],
                      style: CarlTheme
                          .of(context)
                          .blackMediumBoldLabel,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      visit.date.year.toString(),
                      style: CarlTheme
                          .of(context)
                          .blackMediumBoldLabel,
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Text(
                    "${visit.date.hour.toString().padLeft(2, '0')}h${visit.date.minute.toString()
                        .padLeft(2, '0')}",
                    style: CarlTheme
                        .of(context)
                        .black12MediumLabel,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
