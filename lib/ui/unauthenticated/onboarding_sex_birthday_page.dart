import 'package:carl/blocs/user_registration/user_registration_bloc.dart';
import 'package:carl/blocs/user_registration/user_registration_event.dart';
import 'package:carl/blocs/user_registration/user_registration_state.dart';
import 'package:carl/localization/localization.dart';
import 'package:carl/models/registration_model.dart';
import 'package:carl/ui/shared/carl_button.dart';
import 'package:carl/ui/theme.dart';
import 'package:carl/ui/unauthenticated/date_chooser.dart';
import 'package:carl/ui/unauthenticated/onboarding_header.dart';
import 'package:carl/ui/unauthenticated/toggle_chooser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingSexBirthdayPage extends StatefulWidget {
  OnBoardingSexBirthdayPage(
      {@required this.onBackPressed,
      @required this.onEmailAlreadyUsedError,
      @required this.pseudo,
      @required this.email,
      @required this.password});

  final VoidCallback onBackPressed;
  final VoidCallback onEmailAlreadyUsedError;
  final String pseudo;
  final String email;
  final String password;

  @override
  OnBoardingSexBirthdayPageState createState() {
    return OnBoardingSexBirthdayPageState();
  }
}

class OnBoardingSexBirthdayPageState extends State<OnBoardingSexBirthdayPage> {
  ToggleController _toggleController;
  DateController _dateController;
  UserRegistrationBloc _registrationBloc;

  @override
  void initState() {
    super.initState();
    _toggleController = new ToggleController();
    _dateController = new DateController();
    _registrationBloc = BlocProvider.of<UserRegistrationBloc>(context);
  }

  _login() {
    _registrationBloc.dispatch(RegisterUserEvent(
        registrationModel: RegistrationModel(
            pseudo: widget.pseudo,
            userName: widget.email,
            password: widget.password,
            sex: _toggleController.choice.toLowerCase(),
            birthdayDate: _dateController.date.toIso8601String())));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.onBackPressed,
      child: Material(
        child: Container(
          decoration: BoxDecoration(gradient: CarlTheme.of(context).mainGradient),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100),
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      OnBoardingHeader(
                          title: Localization.of(context).onBoardingSexAndAgeTitle, position: 4),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        Localization.of(context).yourSexLabel.toUpperCase(),
                        style: CarlTheme.of(context).white30Label,
                      ),
                      ToggleChooser(
                        choices: [
                          Localization.of(context).np,
                          Localization.of(context).man,
                          Localization.of(context).woman
                        ],
                        toggleController: _toggleController,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: 280,
                        child: Text(
                          Localization.of(context).getBirthdayLabel.toUpperCase(),
                          style: CarlTheme.of(context).white30Label,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DateChooser(
                        date: DateTime.utc(1994, 3, 5),
                        dateController: _dateController,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      BlocBuilder<UserRegistrationEvent, UserRegistrationState>(
                        bloc: _registrationBloc,
                        builder: (BuildContext context, UserRegistrationState state) {
                          final isLoading = state is RegistrationLoading ? true : false;
                          if (state is RegistrationFailed) {
                            if (state.isEmailAlreadyInDatabase) {
                              SchedulerBinding.instance.addPostFrameCallback((_) => widget.onEmailAlreadyUsedError());
                            }
                          }
                          return CarlButton(
                            isLoading: isLoading,
                            textStyle: CarlTheme.of(context).bigButtonLabelStyle,
                            width: MediaQuery.of(context).size.width * 0.8,
                            text: Localization.of(context).validate.toUpperCase(),
                            onPressed: () => _login(),
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
