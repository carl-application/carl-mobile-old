import 'package:bloc/bloc.dart';
import 'package:carl/blocs/authentication/authentication_bloc.dart';
import 'package:carl/blocs/authentication/authentication_event.dart';
import 'package:carl/blocs/authentication/authentication_state.dart';
import 'package:carl/data/providers/user_dummy_provider.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:carl/localization/localization.dart';
import 'package:carl/ui/authenticated/card_detail_page.dart';
import 'package:carl/ui/authenticated/cards_page.dart';
import 'package:carl/ui/shared/VerticalSlideTransition.dart';
import 'package:carl/ui/shared/splash_screen_page.dart';
import 'package:carl/ui/theme.dart';
import 'package:carl/ui/unauthenticated/login_page.dart';
import 'package:carl/ui/unauthenticated/unauthenticated_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/cards/cards_bloc.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition);
  }
}

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(App(UserRepository(userProvider: UserDummyProvider())));
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
  CardsBloc _cardsBloc;

  UserRepository get userRepository => widget._userRepository;

  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc(userRepository);
    _cardsBloc = CardsBloc(userRepository);
    _authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    _cardsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return CarlTheme(
      child: MaterialApp(
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
        },
        onGenerateRoute: (RouteSettings routeSettings) {
          final dynamicArguments = routeSettings.arguments;
          switch (routeSettings.name) {
            case CardDetailPage.routeName:
              if (dynamicArguments is int) {
                return VerticalSlideTransition(
                  widget: CardDetailPage(dynamicArguments.toInt()),
                );
              }
              break;
          }
        },
        home: Scaffold(
          body: BlocProvider<AuthenticationBloc>(
            bloc: _authenticationBloc,
            child: BlocBuilder<AuthenticationEvent, AuthenticationState>(
                bloc: _authenticationBloc,
                builder: (BuildContext context, AuthenticationState state) {
                  if (state is AuthenticationUninitialized) {
                    return SplashScreenPage();
                  }

                  if (state is AuthenticationAuthenticated) {
                    return CardsPage();
                  }

                  return UnauthenticatedNavigation(
                    userRepository: userRepository,
                  );
                }),
          ),
        ),
      ),
    );
  }
}
