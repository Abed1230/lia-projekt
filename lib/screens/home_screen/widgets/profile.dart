import 'package:flutter/material.dart';
import 'package:karlekstanken/models/couple_data.dart';
import 'package:karlekstanken/models/love_language.dart';
import 'package:karlekstanken/models/other_user.dart';
import 'package:karlekstanken/models/user.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:karlekstanken/screens/home_screen/widgets/detail_page.dart';
import 'package:karlekstanken/screens/home_screen/widgets/love_language_card.dart';
import 'package:karlekstanken/screens/pairing_screen/pairing_screen.dart';
import 'package:karlekstanken/services/database.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User _user;
  OtherUser _partner;

  Future<LoveLanguage> _userLoveLanguageFuture;
  Future<LoveLanguage> _partnerLoveLanguageFuture;

  LoveLanguage _userLoveLanguage;
  LoveLanguage _partnerLoveLanguage;

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

  void _getUserLoveLanguage() async {
    if (_user.loveLanguage != null) {
      // Cache future so that we don't do a new database call everytime this method is called
      if (_userLoveLanguageFuture == null)
        _userLoveLanguageFuture = Provider.of<DatabaseService>(context)
            .getLoveLanguage(_user.loveLanguage);

      LoveLanguage userLoveLanguage = await _userLoveLanguageFuture;
      if (this.mounted) {
        setState(() {
          _userLoveLanguage = userLoveLanguage;
        });
      }
    }
  }

  void _getPartnerLoveLanguage() async {
    CoupleData coupleData = Provider.of<CoupleData>(context);
    if (_partner != null &&
        coupleData != null &&
        coupleData.loveLanguages != null &&
        coupleData.loveLanguages.containsKey(_partner.uid)) {
      // Cache future so that we don't do a new database call everytime this method is called
      if (_partnerLoveLanguageFuture == null)
        _partnerLoveLanguageFuture = Provider.of<DatabaseService>(context)
            .getLoveLanguage(coupleData.loveLanguages[_partner.uid]);

      LoveLanguage partnerLoveLanguage = await _partnerLoveLanguageFuture;
      if (this.mounted) {
        setState(() {
          _partnerLoveLanguage = partnerLoveLanguage;
        });
      }
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    _user = Provider.of<User>(context);
    _partner = _user?.partner != null ? OtherUser.fromMap(_user.partner) : null;

    _getUserLoveLanguage();
    _getPartnerLoveLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return _user != null
        ? SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 32, bottom: 10),
                        child: Text(
                          _partner != null
                              ? '${MyStrings.you} & ${_partner.name}'
                              : '${MyStrings.you} & ?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 26,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300),
                        )),
                    _partner == null
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
                    if (_partnerLoveLanguage != null) ...[
                      LoveLanguageCard(
                          header: '${_partner.name}\'s kärleksspråk',
                          text: _partnerLoveLanguage.title,
                          onTap: () => _showDetailPage(
                              '${_partnerLoveLanguage.title} (${_partnerLoveLanguage.id})',
                              _partnerLoveLanguage.description)),
                      SizedBox(
                        height: 8,
                      )
                    ],
                    if (_userLoveLanguage != null)
                      LoveLanguageCard(
                          header: MyStrings.yourLoveLanguage,
                          text: _userLoveLanguage.title,
                          onTap: () => _showDetailPage(
                              '${_userLoveLanguage.title} (${_userLoveLanguage.id})',
                              _userLoveLanguage.description)),
                  ],
                )))
        : SizedBox();
  }
}
