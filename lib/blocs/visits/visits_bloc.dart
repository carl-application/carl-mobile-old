import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:carl/blocs/visits/visits_event.dart';
import 'package:carl/blocs/visits/visits_state.dart';
import 'package:carl/data/repositories/user_repository.dart';

class VisitsBloc extends Bloc<VisitsEvent, VisitsState> {
  VisitsBloc(this._userRepository);

  final UserRepository _userRepository;

  @override
  VisitsState get initialState => VisitsLoading();

  @override
  Stream<VisitsState> mapEventToState(VisitsEvent event) async* {
    if (event is RetrieveVisitsEvent) {
      yield VisitsLoading();
      try {
        final visits = await _userRepository.retrieveVisits(event.businessId, event.fetchLimit,
            lastFetchedDate: event.lastFetchedDate);

        yield VisitsLoadingSuccess(visits: visits);
      } catch (error) {
        print("visits loading error $error");
        yield VisitsLoadingError(isNetworkError: error is SocketException);
      }
    }
  }
}
