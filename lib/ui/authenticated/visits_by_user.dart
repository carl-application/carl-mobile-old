import 'package:carl/blocs/visits/visits_bloc.dart';
import 'package:carl/blocs/visits/visits_event.dart';
import 'package:carl/blocs/visits/visits_state.dart';
import 'package:carl/data/providers/user_api_provider.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:carl/localization/localization.dart';
import 'package:carl/models/business/visit.dart';
import 'package:carl/ui/shared/error_server.dart';
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
  void initState() {
    super.initState();
    _visitsBloc = VisitsBloc(UserRepository(userProvider: UserApiProvider()));
    _visitsBloc.dispatch(RetrieveVisitsEvent(widget.businessId, 10));
  }

  @override
  void dispose() {
    _visitsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .5,
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
                        Localization.of(context).visitsHistoricTitle,
                        style: CarlTheme.of(context).blackMediumBoldLabel,
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
          } else {
            return ErrorServer();
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      visit.date.day.toString(),
                      style: CarlTheme.of(context).blackMediumLabel,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      Localization.of(context).getMonths[visit.date.month - 1],
                      style: CarlTheme.of(context).blackMediumLabel,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      visit.date.year.toString(),
                      style: CarlTheme.of(context).blackMediumLabel,
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Text(
                "${Localization.of(context).at} ${visit.date.hour.toString()} h ${visit.date.minute.toString()} min ${visit.date.second.toString()} sec",
                style: CarlTheme.of(context).blackMediumLabel,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
