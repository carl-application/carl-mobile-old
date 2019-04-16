import 'package:carl/blocs/authentication/authentication_bloc.dart';
import 'package:carl/blocs/user_registration/user_registration_bloc.dart';
import 'package:carl/blocs/user_registration/user_registration_event.dart';
import 'package:carl/blocs/user_registration/user_registration_state.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:carl/ui/unauthenticated/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnauthenticatedNavigation extends StatefulWidget {
  UnauthenticatedNavigation({@required this.userRepository});

  final UserRepository userRepository;

  @override
  UnauthenticatedNavigationState createState() =>
      UnauthenticatedNavigationState();
}

class UnauthenticatedNavigationState extends State<UnauthenticatedNavigation> {
  PageController _controller;
  final _navigationAnimationTimeInSeconds = 2;
  UserRegistrationBloc _registrationBloc;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    final _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _registrationBloc =
        UserRegistrationBloc(widget.userRepository, _authenticationBloc);
    super.initState();
  }

  void navigateTo(int pageNumber) {
    if (_controller.hasClients) {
      _controller.animateToPage(pageNumber,
          duration: Duration(seconds: _navigationAnimationTimeInSeconds),
          curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: BlocProvider<UserRegistrationBloc>(
        bloc: _registrationBloc,
        child: BlocBuilder<UserRegistrationEvent, UserRegistrationState>(
          bloc: _registrationBloc,
          builder: (BuildContext context, UserRegistrationState state) {
            if (state is RegistrationNotStarted) {
              navigateTo(0);
            } else if (state is RegistrationStarted) {
              navigateTo(1);
            } else if (state is UserNameSet) {
              navigateTo(2);
            }

            return PageView(
              scrollDirection: Axis.vertical,
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                WelcomePage(),
                Container(
                  child: Center(
                    child: RaisedButton(
                        child: Text(
                          "back",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          _registrationBloc
                              .dispatch(SetUsernameEvent(userName: "toto"));
                        }),
                  ),
                ),
                Container(
                  color: Colors.deepPurple,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
