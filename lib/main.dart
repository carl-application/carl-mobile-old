import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:carl/blocs/authentication/authentication_bloc.dart';
import 'package:carl/blocs/authentication/authentication_event.dart';
import 'package:carl/blocs/authentication/authentication_state.dart';
import 'package:carl/data/providers/user_api_provider.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:carl/localization/localization.dart';
import 'package:carl/ui/authenticated/card_detail_page.dart';
import 'package:carl/ui/authenticated/cards_page.dart';
import 'package:carl/ui/authenticated/nfc_scan_page.dart';
import 'package:carl/ui/shared/VerticalSlideTransition.dart';
import 'package:carl/ui/shared/splash_screen_page.dart';
import 'package:carl/ui/theme.dart';
import 'package:carl/ui/unauthenticated/login_page.dart';
import 'package:carl/ui/unauthenticated/unauthenticated_navigation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/cards/cards_bloc.dart';
import 'blocs/login/login_bloc.dart';
import 'models/navigation_arguments/card_detail_arguments.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition);
  }
}

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
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
  CardsBloc _cardsBloc;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  UserRepository get userRepository => widget._userRepository;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRepository);
    _loginBloc = LoginBloc(userRepository, _authenticationBloc);
    _cardsBloc = CardsBloc(userRepository);
    _authenticationBloc.dispatch(AppStarted());
    firebaseCloudMessaging_Listeners();
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    _loginBloc.dispose();
    _cardsBloc.dispose();
    super.dispose();
  }

  Widget _selectHomeByState(AuthenticationState state, BuildContext context) {
    if (state is AuthenticationUninitialized) {
      return SplashScreenPage();
    } else if (state is AuthenticationAuthenticated) {
      return CardsPage();
    } else if (state is AuthenticationLoading) {
      return Container(color: CarlTheme.of(context).background);
    }
    return UnauthenticatedNavigation(
      userRepository: userRepository,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: _authenticationBloc,
      child: BlocProvider<LoginBloc>(
        bloc: _loginBloc,
        child: CarlTheme(
          child: BlocBuilder<AuthenticationEvent, AuthenticationState>(
              bloc: _authenticationBloc,
              builder: (BuildContext context, AuthenticationState state) {
                return MaterialApp(
                  localizationsDelegates: [
                    const LocalizationDelegate(),
                  ],
                  supportedLocales: [
                    const Locale('en', ''),
                    const Locale('es', ''),
                  ],
                  initialRoute: '/',
                  routes: {
                    LoginPage.routeName: (context) => LoginPage(),
                    NfcScanPage.routeName: (context) => NfcScanPage(),
                  },
                  onGenerateRoute: (RouteSettings routeSettings) {
                    final dynamicArguments = routeSettings.arguments;
                    switch (routeSettings.name) {
                      case CardDetailPage.routeName:
                        if (dynamicArguments is CardDetailArguments) {
                          return VerticalSlideTransition(
                            widget: CardDetailPage(dynamicArguments),
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
    );
  }
}
