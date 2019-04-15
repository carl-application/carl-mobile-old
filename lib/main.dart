import 'package:bloc/bloc.dart';
import 'package:carl/blocs/authentication/authentication_bloc.dart';
import 'package:carl/blocs/authentication/authentication_event.dart';
import 'package:carl/blocs/authentication/authentication_state.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:carl/ui/unauthenticated/login_page.dart';
import 'package:carl/ui/unauthenticated/unauthenticated_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition);
  }
}

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(App(UserRepository()));
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

  UserRepository get userRepository => widget._userRepository;

  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc(userRepository);
    _authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        backgroundColor: Color.fromRGBO(0, 125, 253, 1),
        textTheme: TextTheme(
          title: TextStyle(
              fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.black),
          body1: TextStyle(
              fontSize: 18.0, fontFamily: 'Hind', color: Colors.black),
        ),
      ),
      initialRoute: '/',
      routes: {
        // When we navigate to the "/second" route, build the SecondScreen Widget
        '/login': (context) => LoginPage(),
      },
      home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationUninitialized) {
              return Container(
                color: Colors.green,
                child: Center(
                  child: Text("splash", textDirection: TextDirection.ltr),
                ),
              );
            }

            if (state is AuthenticationAuthenticated) {
              return Container(
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      "Connecté !",
                      textDirection: TextDirection.ltr,
                    ),
                  ));
            }

            if (state is AuthenticationUnauthenticated) {
              return UnauthenticatedNavigation();
            }

            return Container(
                color: Colors.blue,
                child: Center(
                  child: Text(
                    "yo",
                    textDirection: TextDirection.ltr,
                  ),
                ));
          }),
    );
  }
}
