import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karlekstanken/models/love_language.dart';
import 'package:karlekstanken/models/query.dart';
import 'package:karlekstanken/models/user.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:karlekstanken/services/database.dart';
import 'package:provider/provider.dart';

import '../test_screen.dart';

class FinishPage extends StatefulWidget {
  @override
  _FinishPageState createState() => _FinishPageState();
}

class _FinishPageState extends State<FinishPage> {
  int _selected = -1;

  List<String> _calculateLoveLanguage(List<Statement> selectedStatements) {
    Map<String, int> lettersCount = selectedStatements
        .fold({'A': 0, 'B': 0, 'C': 0, 'D': 0, 'E': 0}, (result, statement) {
      String letter = statement.value;
      switch (letter) {
        case 'A':
          result['A'] = result['A'] + 1;
          break;
        case 'B':
          result['B'] = result['B'] + 1;
          break;
        case 'C':
          result['C'] = result['C'] + 1;
          break;
        case 'D':
          result['D'] = result['D'] + 1;
          break;
        case 'E':
          result['E'] = result['E'] + 1;
          break;
      }
      return result;
    });

    List<String> loveLanguages = [];
    int largest = 0;
    lettersCount.forEach((letter, count) {
      if (count > largest) {
        largest = count;
        loveLanguages = [letter];
      } else if (count == largest) {
        largest = count;
        loveLanguages.add(letter);
      }
    });

    return loveLanguages;
  }

  void _saveAndQuit(String loveLanguage) {
    User user = Provider.of<User>(context);
    Provider.of<DatabaseService>(context).saveLoveLangauge(
        loveLanguage: loveLanguage,
        uid: user.uid,
        coupleDataRef: user.coupleDataRef);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var dbService = Provider.of<DatabaseService>(context);
    var state = Provider.of<TestState>(context);

    List<String> loveLanguageIds = _calculateLoveLanguage(state.selected);
    bool hasMultipleLoveLanguages = loveLanguageIds.length > 1;

    return FutureBuilder(
      future: dbService.getLoveLanguages(loveLanguageIds),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<LoveLanguage> loveLanguages = snapshot.data;

        return hasMultipleLoveLanguages
            ? Center(
                child: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(MyStrings.finishPageTitle,
                                style: TextStyle(fontSize: 18)),
                            SizedBox(
                              height: 16,
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: loveLanguages.length,
                              itemBuilder: (context, position) {
                                return RadioListTile(
                                  title: Text(
                                      '${loveLanguages[position].title} (${loveLanguages[position].id})'),
                                  subtitle:
                                      Text(loveLanguages[position].description),
                                  value: position,
                                  groupValue: _selected,
                                  onChanged: (value) {
                                    setState(() {
                                      _selected = value;
                                    });
                                  },
                                );
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(MyStrings.chooseLoveLanguageMsg),
                            SizedBox(
                              height: 16,
                            ),
                            RaisedButton(
                                child: Text(MyStrings.saveAndQuit),
                                onPressed: _selected < 0
                                    ? null
                                    : () => _saveAndQuit(
                                        loveLanguages[_selected].id)),
                          ],
                        ))))
            : Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(MyStrings.finishPageTitle,
                        style: TextStyle(fontSize: 18)),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      '${loveLanguages[0].title} (${loveLanguages[0].id})',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      loveLanguages[0].description,
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    RaisedButton(
                        child: Text(MyStrings.quit),
                        onPressed: () => _saveAndQuit(loveLanguages[0].id)),
                  ],
                ));
      },
    );
  }
}
