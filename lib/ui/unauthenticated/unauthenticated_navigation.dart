import 'package:carl/blocs/authentication/authentication_bloc.dart';
import 'package:carl/blocs/user_registration/user_registration_bloc.dart';
import 'package:carl/blocs/user_registration/user_registration_event.dart';
import 'package:carl/blocs/user_registration/user_registration_state.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:carl/ui/unauthenticated/onboarding_sex_birthday_page.dart';
import 'package:carl/ui/unauthenticated/onboarding_username_page.dart';
import 'package:carl/ui/unauthenticated/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class UnauthenticatedNavigation extends StatefulWidget {
  UnauthenticatedNavigation({@required this.userRepository});

  final UserRepository userRepository;

  @override
  UnauthenticatedNavigationState createState() => UnauthenticatedNavigationState();
}

class UnauthenticatedNavigationState extends State<UnauthenticatedNavigation> {
  SwiperController _controller;
  final totalSteps = 2;
  UserRegistrationBloc _registrationBloc;
  var _currentPage = 0;
  var _userName = "";

  @override
  void initState() {
    super.initState();
    _controller = SwiperController();
    final _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _registrationBloc = UserRegistrationBloc(widget.userRepository, _authenticationBloc);
  }

  void navigateTo(int pageNumber) {
    print("Actual page is $_currentPage");
    print("Need to navigate to $pageNumber");
    if (pageNumber >= 0 && pageNumber <= totalSteps) {
      _currentPage = pageNumber;
      _controller.move(pageNumber, animation: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: BlocBuilder<UserRegistrationEvent, UserRegistrationState>(
        bloc: _registrationBloc,
        builder: (BuildContext context, UserRegistrationState state) {
          return Stack(
            children: <Widget>[
              Swiper(
                scrollDirection: Axis.vertical,
                controller: _controller,
                duration: 2000,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  switch (index) {
                    case 0:
                      return WelcomePage(
                        onRegisterAsked: () {
                          navigateTo(1);
                        },
                      );
                    case 1:
                      return OnBoardingUsernamePage(
                        userName: _userName,
                        onBackPressed: () {
                          navigateTo(_currentPage - 1);
                        },
                        onUserNameSubmitted: (userName) {
                          _userName = userName;
                          Future.delayed(Duration(milliseconds: 500), () {
                            navigateTo(2);
                          });
                        },
                      );
                    case 2:
                      return OnBoardingSexBirthdayPage(
                        userName: _userName,
                        onBackPressed: () {
                          navigateTo(_currentPage - 1);
                        },
                      );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _registrationBloc.dispose();
    super.dispose();
  }
}
