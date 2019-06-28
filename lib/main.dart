import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:carl/blocs/authentication/authentication_bloc.dart';
import 'package:carl/blocs/authentication/authentication_event.dart';
import 'package:carl/blocs/authentication/authentication_state.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:carl/data/repository_dealer.dart';
import 'package:carl/translations.dart';
import 'package:carl/ui/authenticated/pages/card_detail.dart';
import 'package:carl/ui/authenticated/pages/cards.dart';
import 'package:carl/ui/authenticated/pages/good_deals_list.dart';
import 'package:carl/ui/authenticated/pages/map_search.dart';
import 'package:carl/ui/authenticated/pages/scan.dart';
import 'package:carl/ui/authenticated/pages/search.dart';
import 'package:carl/ui/authenticated/pages/settings.dart';
import 'package:carl/ui/shared/splash_screen_page.dart';
import 'package:carl/ui/shared/vertical_slide_transition.dart';
import 'package:carl/ui/theme.dart';
import 'package:carl/ui/unauthenticated/pages/login.dart';
import 'package:carl/ui/unauthenticated/pages/unauthenticated_navigation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'blocs/login/login_bloc.dart';
import 'blocs/search_businesses/search_businesses_bloc.dart';
import 'blocs/unread_notifications/unread_notification_event.dart';
import 'blocs/unread_notifications/unread_notifications_bloc.dart';
import 'data/providers/user_api_provider.dart';
import 'models/navigation_arguments/card_detail_arguments.dart';
import 'models/navigation_arguments/scan_nfc_arguments.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition);
  }
}

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  FlutterError.onError = (FlutterErrorDetails details) {
    Crashlytics.instance.onError(details);
  };
  runApp(App(UserRepository(userProvider: UserApiProvider())));
}

class App extends StatefulWidget {
  final UserRepository _userRepository;

  App(this._userRepository);

  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  AuthenticationBloc _authenticationBloc;
  LoginBloc _loginBloc;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  UnreadNotificationsBloc _unreadNotificationsBloc;
  SearchBusinessesBloc _searchBusinessesBloc;

  UserRepository get userRepository => widget._userRepository;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRepository, firebaseMessaging: _firebaseMessaging);
    _loginBloc = LoginBloc(userRepository, _authenticationBloc);
    _unreadNotificationsBloc = UnreadNotificationsBloc(userRepository);
    _searchBusinessesBloc = SearchBusinessesBloc(userRepository);
    _authenticationBloc.dispatch(AppStarted());
    firebaseCloudMessagingListeners();
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) askiOSPermission();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        _unreadNotificationsBloc.dispatch(AddNewUnreadNotificationsEvent(1));
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume $message');
        _unreadNotificationsBloc.dispatch(AddNewUnreadNotificationsEvent(1));
        //_openNotificationWhenReceived(message['data']['notificationId'] as int);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch $message');
        _unreadNotificationsBloc.dispatch(AddNewUnreadNotificationsEvent(1));
        //_openNotificationWhenReceived(message['data']['notificationId'] as int);
      },
    );
  }

  void askiOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  void dispose() {
    _authenticationBloc?.dispose();
    _loginBloc?.dispose();
    _searchBusinessesBloc?.dispose();
    super.dispose();
  }

  Widget _selectHomeByState(AuthenticationState state, BuildContext context) {
    if (state is AuthenticationUninitialized) {
      return SplashScreenPage();
    } else if (state is AuthenticationAuthenticated) {
      return Cards();
    } else if (state is AuthenticationLoading) {
      return Container(color: CarlTheme.of(context).background);
    }
    return UnauthenticatedNavigation();
  }

  _forceAppToBeINPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  _forceStatusBarBlackText() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.black, // Color for Android
        statusBarBrightness: Brightness.light // Dark == white status bar -- for IOS.
    ));
  }

  @override
  Widget build(BuildContext context) {
    _forceAppToBeINPortraitMode();
    _forceStatusBarBlackText();
    _unreadNotificationsBloc.dispatch(RefreshUnreadNotificationsCountEvent());
    return BlocProvider<AuthenticationBloc>(
      bloc: _authenticationBloc,
      child: BlocProvider<LoginBloc>(
        bloc: _loginBloc,
        child: BlocProvider<UnreadNotificationsBloc>(
          bloc: _unreadNotificationsBloc,
          child: BlocProvider<SearchBusinessesBloc>(
            bloc: _searchBusinessesBloc,
            child: RepositoryDealer(
              userRepository: userRepository,
              child: CarlTheme(
                child: BlocBuilder<AuthenticationEvent, AuthenticationState>(
                    bloc: _authenticationBloc,
                    builder: (BuildContext context, AuthenticationState state) {
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        localizationsDelegates: [
                          const TranslationsDelegate(),
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                        ],
                        supportedLocales: [
                          const Locale('en', ''),
                          const Locale('fr', ''),
                        ],
                        initialRoute: '/',
                        routes: {
                          MapSearch.routeName: (context) => MapSearch(),
                          Search.routeName: (context) => Search(),
                        },
                        onGenerateRoute: (RouteSettings routeSettings) {
                          final dynamicArguments = routeSettings.arguments;
                          switch (routeSettings.name) {
                            case CardDetail.routeName:
                              if (dynamicArguments is CardDetailArguments) {
                                return VerticalSlideTransition(
                                  widget: CardDetail(dynamicArguments),
                                );
                              }
                              break;
                            case GoodDealsList.routeName:
                              return VerticalSlideTransition(
                                widget: GoodDealsList(),
                              );
                              break;
                            case Login.routeName:
                              return VerticalSlideTransition(
                                widget: Login(),
                              );
                              break;
                            case Settings.routeName:
                              return VerticalSlideTransition(
                                widget: Settings(),
                              );
                              break;
                            case Scan.routeName:
                              if (dynamicArguments is CallSource) {
                                return VerticalSlideTransition(
                                  widget: Scan(
                                    source: dynamicArguments,
                                  ),
                                );
                              }
                              break;
                          }
                        },
                        home: _selectHomeByState(state, context),
                      );
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
