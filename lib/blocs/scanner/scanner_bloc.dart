import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:carl/models/exceptions/business_not_found_exception.dart';

import 'scanner_event.dart';
import 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  ScannerBloc(this._userRepository);

  final UserRepository _userRepository;

  @override
  ScannerState get initialState => ScannerInitialState();

  @override
  Stream<ScannerState> mapEventToState(ScannerEvent event) async* {
    if (event is ScanVisitEvent) {
      yield ScannerLoading();

      try {
        final scanVisitResponse = await _userRepository.scanVisit(event.businessKey);
        final business =
            await _userRepository.retrieveCardById(scanVisitResponse.createdVisit.businessId);
        yield ScannerSuccess(scanVisitResponse: scanVisitResponse, businessCardDetail: business);
      } catch (error) {
        yield ScannerError(
            isBusinessNotFoundError: error is BusinessNotFoundException,
            isNetworkError: error is SocketException);
      }
    }
  }
}
