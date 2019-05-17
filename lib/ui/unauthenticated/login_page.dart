import 'package:carl/blocs/login/login_bloc.dart';
import 'package:carl/blocs/login/login_event.dart';
import 'package:carl/blocs/login/login_state.dart';
import 'package:carl/localization/localization.dart';
import 'package:carl/ui/shared/carl_button.dart';
import 'package:carl/ui/shared/carl_textfield.dart';
import 'package:carl/ui/shared/clickable_text.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  static const routeName = "/loginPage";

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  LoginBloc _loginBloc;

  _login() {
    print("Logging with credentitals :");
    print("userName : ${_usernameController.text}");
    print("password : ${_passwordController.text}");

    _loginBloc.dispatch(
        LoginButtonPressed(username: _usernameController.text, password: _passwordController.text));
  }

  _navigateBack(BuildContext context) async {
    Navigator.pop(context);
  }

  Widget _renderErrorByState(LoginState loginState, BuildContext context) {
    var widget = Container();
    if (loginState is LoginCredentialsFailure) {
      widget = Container(
        child: Text(
          Localization.of(context).loginPageBadCredentialsErrorText,
          style: CarlTheme.of(context).errorTextStyle,
        ),
      );
    } else if (loginState is LoginFailure) {
      Container(
        child: Text("Server error"),
      );
    }

    return widget;
  }

  @override
  Widget build(BuildContext context) {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    return Material(
      child: Container(
        decoration: BoxDecoration(gradient: CarlTheme.of(context).mainGradient),
        child: SafeArea(
          child: Padding(
            padding: CarlTheme.of(context).pagePadding,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Center(
                              child: Hero(
                                tag: "loginCarlFace",
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  child: Image.asset(
                                    "assets/ic_carl.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            ClickableText(
                              text: "annuler",
                              textStyle: CarlTheme.of(context).whiteBoldBigLabel,
                              clickedColor: CarlTheme.of(context).primaryColor,
                              onClick: () => _navigateBack(context),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          Localization.of(context).loginPageTitle,
                          style: CarlTheme.of(context).whiteBoldBigLabel,
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      CarlTextField(
                        hintText: Localization.of(context).loginPageEmailHintText,
                        controller: _usernameController,
                        textInputAction: TextInputAction.next,
                        focusNode: _userNameFocusNode,
                        onSubmitted: (text) {
                          _userNameFocusNode.unfocus();
                          FocusScope.of(context).requestFocus(_passwordFocusNode);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CarlTextField(
                        hintText: Localization.of(context).loginPagePasswordHintText,
                        obscureText: true,
                        controller: _passwordController,
                        textInputAction: TextInputAction.done,
                        focusNode: _passwordFocusNode,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<LoginEvent, LoginState>(
                        bloc: _loginBloc,
                        builder: (BuildContext context, LoginState loginState) {
                          if (loginState is LoginSuccess) {
                            _navigateBack(context);
                          }
                          return Column(
                            children: <Widget>[
                              CarlButton(
                                text: Localization.of(context).validate.toUpperCase(),
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 30,
                                onPressed: () {
                                  _login();
                                },
                                textStyle: CarlTheme.of(context).bigButtonLabelStyle,
                                isLoading: loginState is LoginLoading,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              _renderErrorByState(loginState, context)
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
