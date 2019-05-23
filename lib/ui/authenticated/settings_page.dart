import 'package:carl/blocs/authentication/authentication_bloc.dart';
import 'package:carl/blocs/authentication/authentication_event.dart';
import 'package:carl/localization/localization.dart';
import 'package:carl/ui/shared/carl_button.dart';
import 'package:carl/ui/shared/clickable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_ink_well/image_ink_well.dart';

import '../theme.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = "/settingsPage";

  _logOut(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedOut());
  }

  _showLogoutDialog(BuildContext context) async {
     showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfirmationDialog(
            title: Localization.of(context).logOutConfirmationTitle,
            description: Localization.of(context).logOutConfirmationDescription,
            yesButtonText: Localization.of(context).validate,
            noButtonText: Localization.of(context).cancel,
            onYesClicked: () => _logOut(context),
            onNoClicked: () => Navigator.of(context).pop(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: CarlTheme.of(context).background,
      child: SafeArea(
        child: Padding(
          padding: CarlTheme.of(context).pagePadding,
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  Localization.of(context).settingsTitle,
                  style: CarlTheme.of(context).blackTitle,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    SettingsItem(
                      label: Localization.of(context).settingsLogoutLabel,
                      onCLick: () => _showLogoutDialog(context),
                    )
                  ],
                ),
              ),
              Container(
                height: 50,
                child: CircleImageInkWell(
                  onPressed: () => Navigator.of(context).pop(),
                  size: 50,
                  image: AssetImage('assets/ic_close.png'),
                  splashColor: Colors.black26,
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class SettingsItem extends StatelessWidget {
  final String label;
  final VoidCallback onCLick;

  const SettingsItem({Key key, this.label, this.onCLick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration:
                  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            label,
                            style: CarlTheme.of(context).blackMediumBoldLabel,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      "assets/ic_arrow_right.png",
                      height: 50,
                      width: 50,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Positioned.fill(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Material(
            child: InkWell(
              onTap: () {
                if (onCLick != null) {
                  onCLick();
                }
              },
            ),
            type: MaterialType.transparency,
            borderRadius: BorderRadius.circular(20.0),
            clipBehavior: Clip.antiAlias,
          ),
        ),
      ),
    ]);
  }
}

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;
  final String yesButtonText;
  final String noButtonText;
  final VoidCallback onYesClicked;
  final VoidCallback onNoClicked;

  ConfirmationDialog({
    @required this.title,
    @required this.description,
    @required this.yesButtonText,
    @required this.noButtonText,
    @required this.onYesClicked,
    @required this.onNoClicked,
  });

  @override
  Widget build(BuildContext context) {
    final dialogSize = MediaQuery.of(context).size.width * .7;
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          height: dialogSize,
          width: dialogSize,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: CarlTheme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                  child: Center(
                    child: Text(
                      title,
                      style: CarlTheme.of(context).whiteBoldBigLabel,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    description,
                    style: CarlTheme.of(context).blackMediumLabel,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CarlButton(
                          text: yesButtonText,
                          width: MediaQuery.of(context).size.width * .25,
                          textStyle: CarlTheme.of(context).whiteBigLabel,
                          color: CarlTheme.of(context).primaryColor,
                          onPressed: () => onYesClicked(),
                          elevation: 1,
                        ),

                        ClickableText(
                          text: Localization.of(context).cancel,
                          textStyle: CarlTheme.of(context).blackMediumLabel,
                          clickedColor: Colors.white,
                          onClick: () => Navigator.of(context).pop(),
                        )

                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
