import 'package:flutter/material.dart';
import 'package:karlekstanken/models/other_user.dart';
import 'package:karlekstanken/models/user.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:karlekstanken/screens/home_screen/widgets/detail_page.dart';
import 'package:karlekstanken/screens/home_screen/widgets/love_language_card.dart';
import 'package:karlekstanken/screens/pairing_screen/pairing_screen.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void _navigateToPairingScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => new PairingScreen(null)));
  }

  void _showDetailPage(String title, String text) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => new DetailPage(
                  title: title,
                  text: text,
                )));
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    OtherUser partner =
        user?.partner != null ? OtherUser.fromMap(user.partner) : null;
    return user != null
        ? SizedBox.expand(
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 32, bottom: 10),
                        child: Text(
                          partner != null
                              ? '${MyStrings.you} & ${partner.name}'
                              : '${MyStrings.you} & ?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 26,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300),
                        )),
                    partner == null
                        ? FlatButton(
                            child: Text(
                              MyStrings.addPartner,
                            ),
                            onPressed: _navigateToPairingScreen,
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 20,
                    ),
                    LoveLanguageCard(
                      header: 'John\'s kärleksspråk',
                      text: 'Uppskattande ord',
                      onTap: () => _showDetailPage('Uppskattande ord (A)',
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse sed cursus ex. Aliquam neque velit, tincidunt id lectus vel, eleifend feugiat ligula. Nullam ipsum metus, faucibus sed sodales eget, blandit eget tortor. Ut maximus et lacus et gravida. In eu feugiat mauris. Donec venenatis id turpis ut consequat. Donec ut sem et ex facilisis interdum. Suspendisse ut blandit sapien. Ut blandit erat nulla, ac dictum justo congue vel. Curabitur commodo, tellus sit amet sodales pulvinar, lacus purus accumsan mauris, sodales suscipit nulla dui id velit. Aenean sodales vestibulum est, eu blandit sapien auctor quis. Praesent volutpat ante ac risus venenatis tincidunt. Aliquam viverra purus imperdiet sapien tincidunt blandit. Curabitur ac eleifend ligula, a laoreet sapien.'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    LoveLanguageCard(
                        header: 'Ditt kärleksspråk',
                        text: 'Gåvor',
                        onTap: () => _showDetailPage('Gåvor (B)',
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse sed cursus ex. Aliquam neque velit, tincidunt id lectus vel, eleifend feugiat ligula. Nullam ipsum metus, faucibus sed sodales eget, blandit eget tortor. Ut maximus et lacus et gravida. In eu feugiat mauris. Donec venenatis id turpis ut consequat. Donec ut sem et ex facilisis interdum. Suspendisse ut blandit sapien. Ut blandit erat nulla, ac dictum justo congue vel. Curabitur commodo, tellus sit amet sodales pulvinar, lacus purus accumsan mauris, sodales suscipit nulla dui id velit. Aenean sodales vestibulum est, eu blandit sapien auctor quis. Praesent volutpat ante ac risus venenatis tincidunt. Aliquam viverra purus imperdiet sapien tincidunt blandit. Curabitur ac eleifend ligula, a laoreet sapien.')),
                  ],
                )))
        : SizedBox();
  }
}
