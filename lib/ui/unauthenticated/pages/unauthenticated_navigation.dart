import 'package:carl/blocs/authentication/authentication_bloc.dart';
import 'package:carl/blocs/user_registration/user_registration_bloc.dart';
import 'package:carl/data/repository_dealer.dart';
import 'package:carl/translations.dart';
import 'package:carl/ui/theme.dart';
import 'package:carl/ui/unauthenticated/pages/onboarding_email.dart';
import 'package:carl/ui/unauthenticated/pages/onboarding_password.dart';
import 'package:carl/ui/unauthenticated/pages/onboarding_sex_birthday.dart';
import 'package:carl/ui/unauthenticated/pages/onboarding_username.dart';
import 'package:carl/ui/unauthenticated/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  _showEmailAlreadyUsedError(BuildContext context) {
    final dialogSize = MediaQuery.of(context).size.width * .8;
    final imageSize = MediaQuery.of(context).size.width * .25;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Container(
                height: dialogSize,
                width: dialogSize,
                decoration: BoxDecoration(
                  color: CarlTheme.of(context).background,
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(1000.0)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Image.asset(
                              "assets/scan_limit.png",
                              fit: BoxFit.contain,
                              width: imageSize,
                              height: imageSize,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          Translations.of(context).text('email_already_exist_error_message'),
                          style: CarlTheme.of(context).blackMediumLabel,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
          );
        });
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
                      return Welcome(
                        onRegisterAsked: () {
                          navigateTo(1);
                        },
                      );
                    case 1:
                      return OnBoardingUsername(
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
                      return OnBoardingEmail(
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
                      return OnBoardingPassword(
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
                      return OnBoardingSexBirthday(
                        pseudo: _userName,
                        email: _email,
                        password: _password,
                        onEmailAlreadyUsedError: () {
                          navigateTo(2);
                          _showEmailAlreadyUsedError(context);
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
