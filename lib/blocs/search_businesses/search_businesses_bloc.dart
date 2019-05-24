import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:carl/data/repositories/user_repository.dart';

import 'search_businesses_event.dart';
import 'search_businesses_state.dart';

class SearchBusinessesBloc extends Bloc<SearchBusinessesEvent, SearchBusinessesState> {
  SearchBusinessesBloc(this._userRepository);

  final UserRepository _userRepository;

  @override
  SearchBusinessesState get initialState => SearchBusinessesLoading();

  @override
  Stream<SearchBusinessesState> mapEventToState(SearchBusinessesEvent event) async* {
    if (event is SearchBusinessesByNameEvent) {
      yield SearchBusinessesLoading();
      try {
        final businesses = await _userRepository.searchBusinessesByName(event.name);

        yield SearchBusinessesLoadingSuccess(businesses: businesses);
      } catch (error) {
        print("cards loading error $error");
        yield SearchBusinessesLoadingError(isNetworkError: error is SocketException);
      }
    }
  }
}
