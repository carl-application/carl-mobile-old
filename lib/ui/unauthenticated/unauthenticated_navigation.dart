import 'package:carl/blocs/authentication/authentication_bloc.dart';
import 'package:carl/blocs/user_registration/user_registration_bloc.dart';
import 'package:carl/blocs/user_registration/user_registration_event.dart';
import 'package:carl/data/repository_dealer.dart';
import 'package:carl/ui/unauthenticated/onboarding_email_page.dart';
import 'package:carl/ui/unauthenticated/onboarding_sex_birthday_page.dart';
import 'package:carl/ui/unauthenticated/onboarding_username_page.dart';
import 'package:carl/ui/unauthenticated/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_password_page.dart';

class UnauthenticatedNavigation extends StatelessWidget {
  PageController _controller = PageController();
  final totalSteps = 5;
  UserRegistrationBloc _registrationBloc;
  var _currentPage = 0;
  var _userName = "";
  var _email = "";
  var _password = "";
  AuthenticationBloc _authenticationBloc;

  void navigateTo(int pageNumber) {
    print("Actual page is $_currentPage");
    print("Need to navigate to $pageNumber");
    if (pageNumber >= 0 && pageNumber < totalSteps) {
      _currentPage = pageNumber;
      _controller.animateToPage(pageNumber, duration: Duration(seconds: 2), curve: Curves.linear);
    }
  }

  @override
  Widget build(BuildContext context) {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _registrationBloc =
        UserRegistrationBloc(RepositoryDealer.of(context).userRepository, _authenticationBloc);
    return Directionality(
        textDirection: TextDirection.ltr,
        child: BlocProvider<UserRegistrationBloc>(
          bloc: _registrationBloc,
          child: Stack(
            children: <Widget>[
              PageView.builder(
                scrollDirection: Axis.vertical,
                controller: _controller,
                physics: NeverScrollableScrollPhysics(),
                itemCount: totalSteps,
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
                          Future.delayed(Duration(milliseconds: 300), () {
                            navigateTo(2);
                          });
                        },
                      );
                    case 2:
                      return OnBoardingEmailPage(
                        email: _email,
                        onBackPressed: () {
                          navigateTo(_currentPage - 1);
                        },
                        onEMailSubmitted: (email) {
                          _email = email;
                          Future.delayed(Duration(milliseconds: 300), () {
                            navigateTo(3);
                          });
                        },
                      );
                    case 3:
                      return OnBoardingPasswordPage(
                        password: _password,
                        onBackPressed: () {
                          navigateTo(_currentPage - 1);
                        },
                        onPasswordSubmitted: (password) {
                          _password = password;
                          Future.delayed(Duration(milliseconds: 300), () {
                            navigateTo(4);
                          });
                        },
                      );
                    case 4:
                      return OnBoardingSexBirthdayPage(
                        pseudo: _userName,
                        email: _email,
                        password: _password,
                        onEmailAlreadyUsedError: () {
                          navigateTo(2);
                        },
                        onBackPressed: () {
                          navigateTo(_currentPage - 1);
                        },
                      );
                  }
                },
              ),
            ],
          ),
        ));
  }
}
